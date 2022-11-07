package com.ssafy.dokcho2.service.mission;

import com.ssafy.dokcho2.domain.enums.MissionStatus;
import com.ssafy.dokcho2.domain.monster.Monster;
import com.ssafy.dokcho2.domain.user.User;
import com.ssafy.dokcho2.dto.mission.BossDto;
import com.ssafy.dokcho2.dto.mission.MissionDto;
import com.ssafy.dokcho2.dto.mission.QuizDto;

import java.util.List;

public interface MissionService {
    MissionDto getMissionInfo(Long missionId);
    List<QuizDto> getQuizList(Long missionId);
    List<MissionDto> getMissionList();
    void changeMissionStatus(Long missionId, MissionStatus nowStatus);
    void completeMission(Long missionId);
    BossDto getBossInfo(Long missionId);
    void updateExp(Integer rewardExp);
}
