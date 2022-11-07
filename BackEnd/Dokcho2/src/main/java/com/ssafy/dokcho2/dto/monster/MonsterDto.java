package com.ssafy.dokcho2.dto.monster;

import com.ssafy.dokcho2.domain.userMonster.UserMonster;
import io.swagger.annotations.ApiModel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@ApiModel(value = "풀깨비 정보")
public class MonsterDto {
    private Long userId;
    private Long monsterId;
    private String name;
    private String line;
    private String skill;
    private Integer hp;
    private Integer attack;
    private Integer level;
    private Integer exp;

    public static MonsterDto from(UserMonster userMonster){
        return MonsterDto.builder()
                .userId(userMonster.getUser().getUserId())
                .monsterId(userMonster.getMonster().getMonsterId())
                .name(userMonster.getMonster().getName())
                .line(userMonster.getMonster().getLine())
                .skill(userMonster.getMonster().getSkill())
                .hp(userMonster.getMonster().getHp() + userMonster.getLevel()*500)
                .attack(userMonster.getMonster().getAttack() + userMonster.getLevel()*80)
                .level(userMonster.getLevel())
                .exp(userMonster.getExp())
                .build();
    }

}
