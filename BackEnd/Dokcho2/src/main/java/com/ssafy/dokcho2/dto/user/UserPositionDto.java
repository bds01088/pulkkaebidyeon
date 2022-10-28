package com.ssafy.dokcho2.dto.user;

import com.ssafy.dokcho2.domain.user.User;
import io.swagger.annotations.ApiModel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@ApiModel(value = "UserPositionDto", description = "유저 위치 정보 Dto")
public class UserPositionDto {
    private Double x;
    private Double y;
    private Double z;

    public static UserPositionDto from(User entity){
        return UserPositionDto.builder()
                .x(entity.getX())
                .y(entity.getY())
                .z(entity.getZ())
                .build();
    }
}
