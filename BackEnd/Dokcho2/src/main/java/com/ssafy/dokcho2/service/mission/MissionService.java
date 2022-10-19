package com.ssafy.dokcho2.service.mission;

import com.ssafy.dokcho2.domain.enums.MissionStatus;
import com.ssafy.dokcho2.dto.mission.MissionDto;
import com.ssafy.dokcho2.dto.mission.QuizDto;

import java.util.List;

public interface MissionService {
    MissionDto getMissionInfo(String characters);
    List<QuizDto> getQuizList(Long missionId);
    List<MissionDto> getMissionList();
    void changeMissionStatus(Long missionId, MissionStatus nowStatus);
    void completeMission(Long missionId);
}
