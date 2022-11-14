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
    private String description;
    private String next;
    private MissionStatus status;
    private Long relic;
    private Long item;

    public static MissionDto from(Mission entity, MissionStatus status){
        String line = "";
        String next = "";
        String[] nexts = entity.getNext().split("\\\\t");
        if(status == MissionStatus.READY){
            line = entity.getLine1();
            next = nexts[2];
        }else if(status == MissionStatus.STARTED){
            line = entity.getLine2();
            next = nexts[3];
        }else if (status == MissionStatus.QUIZ_PASSED){
            line = entity.getLine3();
            next = nexts[4];
        }else if(status == MissionStatus.BATTLE_WIN){
            line = entity.getLine4();
            next = nexts[5];
        } else if(status == MissionStatus.NOT_YET){
            line = entity.getLine0();
            next = nexts[0];
        } else{
            line = entity.getLine0();
            next = nexts[5];
        }

        return MissionDto.builder()
                .missionId(entity.getMissionId())
                .characters(entity.getCharacters())
                .line(line)
                .description(entity.getDescription())
                .status(status)
                .next(next)
                .relic(entity.getRelic())
                .item(entity.getItem())
                .build();
    }
}
