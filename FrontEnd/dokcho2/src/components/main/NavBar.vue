<template>
  <div>
    <nav class="navbar">
      <div class="navbar__logo">
        <a href="/main">
          <img src="" alt="" class="navbar__logoImg" />
        </a>
        <div class="navbar__toggleBtn" @click="menuOpen()">
          <font-awesome-icon icon="fa-solid fa-bars" size="xl" />
        </div>
      </div>
      <div class="navbar__centerMenu">
        <div>
          <ul class="navbar__centerIcons">
            <li>
              <a @click="popon('/camera')">
                <p class="TITLE">사 진</p>
              </a>
            </li>
            <li>
              <a @click="popon('/encyclopedia')">
                <p class="TITLE">도 감</p>
              </a>
            </li>
            <li>
              <a @click="popon('/game')">
                <p class="TITLE">게 임</p>
              </a>
            </li>
          </ul>
        </div>
      </div>
      <div class="navbar__sideMenu">
        <div>
          <ul class="navbar__sideIcons">
            <li>
              <a href="/mypage">
                <font-awesome-icon icon="fa-solid fa-user" size="xl" />
              </a>
            </li>
            <li>
              <a href="#" @click="logout()">
                <font-awesome-icon icon="fa-solid fa-door-open" size="xl" />
              </a>
            </li>
          </ul>
        </div>
      </div>
    </nav>
    <div class="sideBar" :class="this.showMenu ? 'open-menu' : 'closed-menu'">
      <div>
        &nbsp;<font-awesome-icon
          class="x__icon"
          icon="fa-solid fa-x"
          size="sm"
          @click="menuOpen()"
        />
      </div>
      <div class="sideBar__menu">
        <div class="sideBar__items">
          <ul class="sideBar__icons">
            <li>
              <a href="/camera">
                <font-awesome-icon icon="fa-solid fa-camera" size="xl" />
                <p class="TITLE">사진</p>
              </a>
            </li>
            <li>
              <a href="/encyclopedia">
                <font-awesome-icon icon="fa-solid fa-book" size="xl" />
                <p class="TITLE">도감</p>
              </a>
            </li>
          </ul>
          <ul class="sideBar__icons">
            <li>
              <a href="/game">
                <font-awesome-icon icon="fa-solid fa-gamepad" size="xl" />
                <p class="TITLE">게임</p>
              </a>
            </li>
            <li>
              <a href="/mypage">
                <font-awesome-icon icon="fa-solid fa-user" size="xl" />
                <p class="TITLE">내설정</p>
              </a>
            </li>
          </ul>
        </div>
        <div class="sideBar__logout" @click="logout()">
          <a href="#">
            <font-awesome-icon
              icon="fa-solid fa-door-open"
              class="sideBar__logoutIcon"
            />
            <span class="out__message TITLE">나가기</span>
          </a>
        </div>
      </div>
    </div>
    <div
      class="blur"
      :class="this.showMenu ? 'open-menu__blur' : ''"
      @click="menuOpen()"
    ></div>
  </div>
</template>

<script>
export default {}
</script>

<style lang="scss" scoped></style>
