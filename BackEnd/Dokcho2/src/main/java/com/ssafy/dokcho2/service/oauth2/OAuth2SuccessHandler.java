package com.ssafy.dokcho2.service.oauth2;

import com.ssafy.dokcho2.domain.enums.Role;
import com.ssafy.dokcho2.domain.user.User;
import com.ssafy.dokcho2.domain.user.UserRepository;
import com.ssafy.dokcho2.dto.jwt.TokenDto;
import com.ssafy.dokcho2.jwt.TokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import java.util.Optional;

@RequiredArgsConstructor
@Component
public class OAuth2SuccessHandler implements AuthenticationSuccessHandler {
    private final TokenProvider tokenProvider;
    private final UserRepository userRepository;
    private final PasswordMaker passwordMaker;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();
        Map<String, Object> attributes = oAuth2User.getAttributes();


        if(attributes.get("kakao_account")!=null){
            attributes = (Map<String, Object>) attributes.get("kakao_account");
        }

        String email = (String) attributes.get("email");

        // db 확인
        // 새로운 유저 -> 회원가입
        Optional<User> entity = userRepository.findByEmail(email);
        TokenDto tokenDto = new TokenDto();

        if(!entity.isPresent()){
            User user = User.builder().username(email)
                    .password(passwordMaker.make())
                    .email(email)
                    .nickname("")
                    .role(Role.ROLE_USER)
                    .build();

            // 토큰 생성
            tokenDto = tokenProvider.generateTokenDto(user.getUsername(), user.getRole().toString());
            user.saveToken(tokenDto.getRefreshToken());
            userRepository.save(user);
        }else {
            // 토큰 생성
            tokenDto = tokenProvider.generateTokenDto(entity.get().getUsername(), entity.get().getRole().toString());
            entity.get().saveToken(tokenDto.getRefreshToken());
            userRepository.save(entity.get());
        }

        // 리다이렉트
        String target = "http://localhost:8082/oauth?Auth=" + tokenDto.getAccessToken() + "&Refresh=" + tokenDto.getRefreshToken();
        RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
        redirectStrategy.sendRedirect(request, response, target);
    }
}
