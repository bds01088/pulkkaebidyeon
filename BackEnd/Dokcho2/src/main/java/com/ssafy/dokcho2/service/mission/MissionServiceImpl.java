package com.ssafy.dokcho2.service.mission;

import com.ssafy.dokcho2.domain.enums.MissionStatus;
import com.ssafy.dokcho2.domain.item.Item;
import com.ssafy.dokcho2.domain.item.ItemRepository;
import com.ssafy.dokcho2.domain.mission.*;
import com.ssafy.dokcho2.domain.monster.Monster;
import com.ssafy.dokcho2.domain.user.User;
import com.ssafy.dokcho2.domain.user.UserRepository;
import com.ssafy.dokcho2.domain.userItem.UserItem;
import com.ssafy.dokcho2.domain.userItem.UserItemRepository;
import com.ssafy.dokcho2.domain.userMonster.UserMonster;
import com.ssafy.dokcho2.domain.userMonster.UserMonsterRepository;
import com.ssafy.dokcho2.dto.exception.item.ItemNotFoundException;
import com.ssafy.dokcho2.dto.exception.mission.MissionNotFoundException;
import com.ssafy.dokcho2.dto.exception.monster.MonsterNotFoundException;
import com.ssafy.dokcho2.dto.exception.user.UserNotFoundException;
import com.ssafy.dokcho2.dto.mission.BossDto;
import com.ssafy.dokcho2.dto.mission.MissionDto;
import com.ssafy.dokcho2.dto.mission.QuizDto;
import com.ssafy.dokcho2.util.SecurityUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class MissionServiceImpl implements MissionService{

    private final UserRepository userRepository;
    private final MissionRepository missionRepository;
    private final UserMissionRepository userMissionRepository;
    private final ItemRepository itemRepository;
    private final UserItemRepository userItemRepository;
    private final UserMonsterRepository userMonsterRepository;
    private final BossRepository bossRepository;

    @Override
    public MissionDto getMissionInfo(Long missionId) {
        User user = SecurityUtil.getCurrentUsername().flatMap(userRepository::findByUsername).orElseThrow(UserNotFoundException::new);
        Mission mission = missionRepository.findById(missionId).orElseThrow(MissionNotFoundException::new);
        UserMission userMission = userMissionRepository.findUserMissionByUserAndMission(user, mission).orElseThrow(MissionNotFoundException::new);
        return MissionDto.from(mission, userMission.getStatus());
    }

    @Override
    public List<QuizDto> getQuizList(Long missionId) {
        Mission mission = missionRepository.findById(missionId).orElseThrow(MissionNotFoundException::new);
        return mission.getQuizList().stream().map(quiz -> QuizDto.from(quiz)).collect(Collectors.toList());
    }

    @Override
    public List<MissionDto> getMissionList() {
        User user = SecurityUtil.getCurrentUsername().flatMap(userRepository::findByUsername).orElseThrow(UserNotFoundException::new);
        List<MissionDto> list = new ArrayList<>();

        for(UserMission um : user.getUserMissionList()){
            Mission mission = um.getMission();
            list.add(MissionDto.from(mission, um.getStatus()));
        }

        return list;
    }

    @Override
    public void changeMissionStatus(Long missionId, MissionStatus nowStatus) {
        User user = SecurityUtil.getCurrentUsername().flatMap(userRepository::findByUsername).orElseThrow(UserNotFoundException::new);
        Mission mission = missionRepository.findById(missionId).orElseThrow(MissionNotFoundException::new);
        UserMission userMission = userMissionRepository.findUserMissionByUserAndMission(user, mission).orElseThrow(MissionNotFoundException::new);

        MissionStatus newStatus;

        if(nowStatus == MissionStatus.NOT_YET){
            newStatus = MissionStatus.READY;
        }else if(nowStatus == MissionStatus.READY) {
            newStatus = MissionStatus.STARTED;
        }else if(nowStatus == MissionStatus.STARTED){
            newStatus = MissionStatus.QUIZ_PASSED;
        }else if(nowStatus == MissionStatus.QUIZ_PASSED){
            newStatus = MissionStatus.BATTLE_WIN;
        }else if(nowStatus == MissionStatus.BATTLE_WIN){
            newStatus = MissionStatus.FINISHED;
        }else{
            newStatus = nowStatus;
        }

        userMission.changeStatus(newStatus);
        userMissionRepository.save(userMission);
    }

    @Override
    public void updateExp(Integer rewardExp){
        User user = SecurityUtil.getCurrentUsername().flatMap(userRepository::findByUsername).orElseThrow(UserNotFoundException::new);
        Monster monster = user.getRepresentMonster();

        updateExp(user, monster, rewardExp);
    }

    public void updateExp(User user, Monster monster, Integer rewardExp){
        UserMonster um = userMonsterRepository.findByUserAndMonster(user, monster).orElseThrow(MonsterNotFoundException::new);
        Integer newLevel = um.getLevel();
        Integer newExp = um.getExp()+rewardExp;
        while (newLevel*100 <= newExp) {
            newExp -= newLevel*100;
            newLevel += 1;
        }

        um.setExp(newExp);
        um.setLevel(newLevel);

        userMonsterRepository.save(um);
    }

    @Override
    public void completeMission(Long missionId) {
        User user = SecurityUtil.getCurrentUsername().flatMap(userRepository::findByUsername).orElseThrow(UserNotFoundException::new);
        Mission mission = missionRepository.findById(missionId).orElseThrow(MissionNotFoundException::new);
        UserMission userMission = userMissionRepository.findUserMissionByUserAndMission(user, mission).orElseThrow(MissionNotFoundException::new);

        Monster monster = user.getRepresentMonster();
        updateExp(user, monster, mission.getExp());

        Item relic = itemRepository.findById(mission.getRelic()).orElseThrow(ItemNotFoundException::new);
        Item item = itemRepository.findById(mission.getItem()).orElseThrow(ItemNotFoundException::new);
        userItemRepository.save(UserItem.builder().item(relic).user(user).count(1).build());
        userItemRepository.save(UserItem.builder().item(item).user(user).count(1).build());
        
        userMission.changeStatus(MissionStatus.FINISHED);
        userMissionRepository.save(userMission);
    }

    @Override
    public BossDto getBossInfo(Long missionId){
        return BossDto.from(bossRepository.findById(missionId).orElseThrow(MonsterNotFoundException::new));
    }
}
