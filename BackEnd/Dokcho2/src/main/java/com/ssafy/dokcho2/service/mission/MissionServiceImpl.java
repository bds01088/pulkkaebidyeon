package com.ssafy.dokcho2.service.mission;

import com.ssafy.dokcho2.domain.enums.MissionStatus;
import com.ssafy.dokcho2.dto.mission.MissionDto;
import com.ssafy.dokcho2.dto.mission.QuizDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class MissionServiceImpl implements MissionService{

    @Override
    public MissionDto getMissionInfo(String characters) {
        return null;
    }

    @Override
    public List<QuizDto> getQuizList(Long missionId) {
        return null;
    }

    @Override
    public List<MissionDto> getMissionList() {
        return null;
    }

    @Override
    public void changeMissionStatus(Long missionId, MissionStatus nowStatus) {

    }

    @Override
    public void completeMission(Long missionId) {

    }


}
