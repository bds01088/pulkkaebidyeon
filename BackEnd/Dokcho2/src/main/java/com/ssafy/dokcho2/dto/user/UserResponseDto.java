package com.ssafy.dokcho2.dto.user;

import com.ssafy.dokcho2.domain.enums.Role;
import com.ssafy.dokcho2.domain.user.User;
import io.swagger.annotations.ApiModel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.format.DateTimeFormatter;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@ApiModel(value = "UserResponseDto", description = "유저 정보 응답 Dto")
public class UserResponseDto {
    private Long user_id;
    private String username;
    private String nickname;
    private String email;
    private int rank_point;
    private int money;
    private Role role;
    private Boolean newbie;
    private Boolean starter;
    private String createDate;
    private Long profile_img;

    public static UserResponseDto from(User entity){
        String createDate = DateTimeFormatter.ofPattern("yyyy-MM-dd").format(entity.getCreatedDate()).toString();

        return UserResponseDto.builder()
                .user_id(entity.getUserId())
                .username(entity.getUsername())
                .email(entity.getEmail())
                .nickname(entity.getNickname())
                .role(entity.getRole())
                .createDate(createDate)
                .build();
    }
}
