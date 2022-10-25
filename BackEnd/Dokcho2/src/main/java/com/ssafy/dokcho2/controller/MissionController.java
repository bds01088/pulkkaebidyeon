package com.ssafy.dokcho2.controller;

import com.ssafy.dokcho2.domain.enums.MissionStatus;
import com.ssafy.dokcho2.dto.mission.BossDto;
import com.ssafy.dokcho2.dto.mission.MissionDto;
import com.ssafy.dokcho2.dto.mission.QuizDto;
import com.ssafy.dokcho2.service.mission.MissionService;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/mission")
public class MissionController {
    private final MissionService missionService;

    @GetMapping("/{characters}")
    @ApiOperation(value = "캐릭터와 상호작용 시 미션 정보 주기")
    public ResponseEntity<MissionDto> getMissionInfo(@PathVariable String characters){
        return new ResponseEntity<>(missionService.getMissionInfo(characters), HttpStatus.OK);
    }

    @GetMapping("/quiz/{missionId}")
    @ApiOperation(value = "미션의 퀴즈 리스트 주기")
    public ResponseEntity<List<QuizDto>> getQuizList(@PathVariable Long missionId){
        return new ResponseEntity<>(missionService.getQuizList(missionId), HttpStatus.OK);
    }

    @GetMapping("/")
    @ApiOperation(value = "전체 미션 리스트")
    public ResponseEntity<List<MissionDto>> getMissionList(){
        return new ResponseEntity<>(missionService.getMissionList(), HttpStatus.OK);
    }

    @PutMapping("/{missionId}")
    @ApiOperation(value = "미션 상태 바꾸기")
    public ResponseEntity<List<MissionDto>> changeMissionStatus(@PathVariable Long missionId, @RequestParam MissionStatus nowStatus){
        missionService.changeMissionStatus(missionId, nowStatus);
        return new ResponseEntity<>(missionService.getMissionList(), HttpStatus.OK);
    }

    @PutMapping("/complete/{missionId}")
    @ApiOperation(value = "미션 완료")
    public ResponseEntity<List<MissionDto>> completeMission(@PathVariable Long missionId){
        missionService.completeMission(missionId);
        return new ResponseEntity<>(missionService.getMissionList(), HttpStatus.OK);
    }

    @GetMapping("/boss/{missionId}")
    @ApiOperation(value = "보스 정보")
    public ResponseEntity<BossDto> getBossInfo(@PathVariable Long missionId){
        return new ResponseEntity<>(missionService.getBossInfo(missionId), HttpStatus.OK);
    }
}
