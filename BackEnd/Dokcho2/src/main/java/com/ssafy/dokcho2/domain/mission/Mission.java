package com.ssafy.dokcho2.domain.mission;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@NoArgsConstructor
@Getter
@Builder
@AllArgsConstructor
@Table(name = "mission")
public class Mission {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "mission_id")
    private Long missionId;
    @Column(name = "line1")
    private String line1; // 처음 만났을 때
    @Column(name = "line2")
    private String line2; // 퀴즈 풀었을 때
    @Column(name = "line3")
    private String line3; // 보스 잡았을 때
    @Column(name = "line4")
    private String line4; // 기본 대사
    @Column(name = "characters")
    private String characters;
    @Column(name = "relic")
    private Long relic;
    @Column(name = "item")
    private Long item;
    @Column(name = "exp")
    private Integer exp;
    @OneToMany(mappedBy = "mission", cascade = CascadeType.ALL)
    private List<Quiz> quizList = new ArrayList<>();
    @OneToMany(mappedBy = "mission", cascade = CascadeType.ALL)
    private List<UserMission> userMissionList = new ArrayList<>();
    @OneToOne(mappedBy = "mission", cascade = CascadeType.ALL)
    private Boss boss;
}
