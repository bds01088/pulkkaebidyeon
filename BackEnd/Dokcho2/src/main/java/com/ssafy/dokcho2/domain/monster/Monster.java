package com.ssafy.dokcho2.domain.monster;

import com.ssafy.dokcho2.domain.userMonster.UserMonster;
import lombok.*;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@NoArgsConstructor
@Getter
@Builder
@AllArgsConstructor
@Table(name = "monster")
public class Monster {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "monster_id")
    private Long monsterId;

    @Column(name = "name")
    private String name;

    @Column(name = "line")
    private String line;

    @Column(name = "skill")
    private String skill;

    @Column(name = "hp")
    private Integer hp;

    @Column(name = "attack")
    private Integer attack;

    @OneToMany(mappedBy = "monster", cascade = CascadeType.ALL)
    private List<UserMonster> userMonsterList = new ArrayList<>();

    public void setHp(Integer hp) { this.hp = hp; }

    public void setAttack(Integer attack) { this.attack = attack; }

    @PrePersist
    public void prePersist(){
        this.hp = 500;
        this.attack = 100;
    }
}
