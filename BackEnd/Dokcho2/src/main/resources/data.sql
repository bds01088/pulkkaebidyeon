insert into monster (monster_id, name, line, skill, hp, attack) values (1, '풀깨비', '내가 바로 풀깨비다', '박치기', 500, 100);

insert into users(users_id, created_date, email, password, role, token, username, monster_id)
values (1, '2022-10-24 11:26:13.164186','string@naver.com','$2a$10$CWJ8P8VKbzbFFbqWrxy9Ge14nkZhgggUuRl4lBd5.PyYRMtBg4ZJe','ROLE_USER',null,'string', 1);

insert into mission (mission_id, line1, line2, line3, line4, characters, relic, item, exp)
values (1, '안녕', '맞췄네', '잡았네', '기본임', '단군', 1, 1, 10);

insert into users_mission(users_mission_id, status, users_id, mission_id)
values (1, 'NOT_YET', 1, 1);

insert into users_monster(users_monster_id, level, exp, users_id, monster_id)
values (1, 1, 0, 1, 1);

INSERT INTO item(item_id, name, description, type) VALUES (1, '체력회복', '5~10을 회복시킴', 'USE_ITEM');



insert into boss (mission_id, name, hp, attack)
values (1, '지현몬', 3000, 600);

insert into quiz (quiz_id, question, answer1, answer2, answer3, right_answer, mission_id)
values (1, '넌누구냐?', '나', '너', '우리', '허준제자', 1);
