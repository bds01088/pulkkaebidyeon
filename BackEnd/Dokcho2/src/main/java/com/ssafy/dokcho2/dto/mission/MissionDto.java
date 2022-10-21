package com.ssafy.dokcho2.dto.mission;

import com.ssafy.dokcho2.domain.enums.MissionStatus;
import com.ssafy.dokcho2.domain.mission.Mission;
import io.swagger.annotations.ApiModel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@ApiModel(value = "MissionDto", description = "미션 정보 응답 Dto")
public class MissionDto {
    private Long missionId;
    private String characters;
    private String line;
    private MissionStatus status;
    private Long relic;
    private Long item;

    public static MissionDto from(Mission entity, MissionStatus status){
        String line = "";
        if(status == MissionStatus.READY){
            line = entity.getLine1();
        }else if(status == MissionStatus.STARTED){
            line = entity.getLine2();
        }else if (status == MissionStatus.QUIZ_PASSED){
            line = entity.getLine3();
        }else {
            line = entity.getLine4();
        }

        return MissionDto.builder()
                .missionId(entity.getMissionId())
                .characters(entity.getCharacters())
                .line(line)
                .status(status)
                .relic(entity.getRelic())
                .item(entity.getItem())
                .build();
    }
}
