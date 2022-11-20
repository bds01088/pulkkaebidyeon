# [풀깨비뎐](https://k7e203.p.ssafy.io/ "풀깨비뎐 바로가기!") 🌿

![풀깨비뎐](./README.assets/독초도감.png)

## 목차

- [풀깨비뎐](#풀깨비뎐)
  - [목차](#목차)
  - [서비스 소개](#서비스-소개)
    - [📋 기술 스택 및 버전](#기술-스택-및-버전)
  - [프로젝트 파일 구조](#프로젝트-파일-구조)
  - [산출물](#산출물)
  - [결과물](#결과물)
  
- [📺 프로젝트 UCC]()

## 서비스 소개

1. 개발 기간 : 2022.10.11 ~ 2022.11.21 (총 6주)
2. 인원 (총 6인)

| [서상균](https://github.com/seosanggyun) | [김성빈](https://github.com/ksb0903) |  [김효근]()  | [박지현](https://github.com/petteloiv) | [오하민](https://github.com/ohhamin) |  [이근희]()   |
| :--------------------------------------: | :----------------------------------: | :----------: | :------------------------------------: | :----------------------------------: | :-----------: |
|      **팀장, Front-end, Back-end**       |         **Back-end, DevOps**         | **Back-end** |             **Front-end**              |      **Front-end, 3D Modeling**      | **Front-end** |



## 기술 스택 및 버전

1. 이슈 관리 : ![Jira](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\jira-%230A0FFF.svg+xml)
2. 형상 관리: ![GitLab](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\gitlab-%23181717.svg+xml)
3. 커뮤니케이션: ![Notion](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\Notion-%23000000.svg+xml) ![Discord](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\discord-5865F2.svg+xml) 
4. 개발 환경 
   - IDE : ![IntelliJ](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\IntelliJIDEA-000000.svg+xml)2022.1.2 ![Visual_Studio_Code](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\Visual Studio Code-0078d7.svg+xml)1.71.2
   - DB : ![MySQL](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\MySQL-003545.svg+xml) 8.0.30 ![MongoDB](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\MongoDB-47A248.svg+xml) 6.0.1 
   - UI & UX : ![Figma](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\Figma-F24E1E.svg+xml) 
   - Server : ![AWS](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\AWS-FF9900.svg+xml) ![S3](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\S3-569A31.svg+xml) ![Linux](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\Linux-FCC624.svg+xml) ![ubuntu](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\Ubuntu-E95420.svg+xml)![NGINX](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\nginx-009639.svg+xml) ???
5. 상세
   - Backend : ![JAVA](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\JAVA-FF0000.svg+xml) 1.8 ![Spring](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\Spring-boot-6DB33F.svg+xml)2.7.3 ![Gradle](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\Gradle-02303A.svg+xml)7.5 ![JWT](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\JWT-000000.svg+xml)0.11.2
   - Frontend : ![HTML5](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\HTML5-E34F26.svg+xml)![CSS3](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\css3-1572B6.svg+xml)![JAVASCRIPT](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\javascript-F7DF1E.svg+xml)![Vue.js](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\vue.js-4FC08Dstyle=for-the-badge&logo=vue.svg+xml) 3.2.39 ![Node.js](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\Node.js-339933style=for-the-badge&logo=node.svg+xml)16.16.0 ![TypeScript](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\TypeScript-3178C6.svg+xml) 4.5.5 ![bootstrap](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\BootStrap-7952B3.svg+xml) 5.2.1
   - CI/CD : ![docker](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\docker-2496ED.svg+xml)20.10.18 ![Vue.js](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\jenkins-D24939.svg+xml) 2.222.4
   - Data : ![python](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\python-3776AB.svg+xml)3.8.10 ![hadoop](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\hadoop-66CCFF.svg+xml)3.3.2 ![spark](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\spark-E25A1C.svg+xml) 3.2.1 ![kafka](C:\Users\SSAFY\Desktop\S07P31E203\README.assets\kafka-231F20.svg+xml) 7.0.1  

## 프로젝트 파일 구조

- **Backend**

  ```
  main
  ├─generated
  ├─java
  │  └─com
  │      └─ssafy
  │          └─dockcho2
  │             ├─config
  │             ├─controller
  │             ├─domain
  │             │  ├─basetime
  │             │  ├─enums
  │             │  ├─item
  │             │  ├─minigame
  │             │  ├─mission
  │             │  ├─monster
  │             │  ├─user
  │             │  ├─userItem
  │             │  └─userMonster
  │             ├─dto
  │             │  ├─exception
  │             │  │  ├─common
  │             │  │  ├─item
  │             │  │  ├─mission
  │             │  │  ├─monster
  │             │  │  └─user
  │             │  ├─item
  │             │  ├─jwt
  │             │  ├─minigame
  │             │  ├─mission
  │             │  ├─monster
  │             │  ├─oauth2
  │             │  └─user
  │             ├─jwt
  │             ├─service
  │             │  ├─item
  │             │  ├─jwt
  │             │  ├─minigame
  │             │  ├─mission
  │             │  ├─monster
  │             │  ├─oauth2
  │             │  └─user
  │             └─util
  └─resources
  ```

- **Frontend** 

  ```
  rc
  ├─assets
  │  ├─battle
  │  ├─item
  │  ├─loading
  │  ├─minigame
  │  ├─mission
  │  ├─monsters
  │  ├─mypage
  │  ├─navbar
  │  ├─quiz
  │  └─starting
  ├─components
  │  ├─accounts
  │  ├─battle
  │  ├─canvas
  │  ├─ending
  │  │  ├─arena
  │  │  ├─friend
  │  │  ├─gg
  │  │  └─shop
  │  ├─main
  │  ├─minigame
  │  ├─modules
  │  ├─monster
  │  ├─script
  │  └─start
  ├─constant
  ├─fonts
  ├─router
  ├─store
  │  └─modules
  └─views
     ├─canvas
     ├─error
     └─start
  
  ```

  <br><br>

  ## 산출물

- [프로젝트 메모 및 공유 : Notion](https://www.notion.so/faef428821b04f3ea6a4324aa6c8aed9)

- [프로젝트 회의록](https://www.notion.so/ea1a637672b244fd8a1240ab0d94e74c?v=9199099e636044a9b20ae53103f6cdd7)

  <br>

- [프로젝트 컨벤션 목록](https://www.notion.so/2ef6f198c0c74ae998c9646c8ef13654)

- [기획서](https://www.notion.so/54eab313652a4caea007b8397d0297e8)

- [API Docs](https://www.notion.so/API-Docs-38bc08bf6c9e43f99d0844ff5f3c91a4)

- [서비스 아키텍처](./docs/아키텍처.md) 

- [기능 명세서](https://www.notion.so/3a54b3a7161244d78facf5d56f31191c?v=9301e374c0fd4906925ce21200b995de)

- [데이터베이스:ERD](https://www.erdcloud.com/d/AhhMDN9Ez33s5uWC3) 

  <br><br>

  ## 결과물 

- [포팅메뉴얼](./exec/porting_manual.md)

- [시연시나리오](./exec/[시연시나리오]자율_PJT_부울경_2반_E203.pdf)

- [중간발표자료](./pt/[중간발표]자율_PJT_부울경_2반_E203.pdf)

- [최종발표자료](./pt/[최종발표]자율_PJT_부울경_2반_E203.pdf)
