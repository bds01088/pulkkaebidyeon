<template>
  <router-view />
</template>

<script>
export default {}
</script>

<style>
input {
  border-radius: 20px;
  padding: 0 1vw;
}

button {
  height: 4vh;
  border-radius: 50px;
  border: none;
  width: 5vw;
  margin: 0.5vh;
  cursor: url('@/assets/selector.cur'), pointer;
}

body {
  cursor: url(pointer.cur), auto;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
}

/* button {
  cursor: url(selector.cur), pointer;
} */

@font-face {
  font-family: 'DungGeunMo';
  src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_six@1.2/DungGeunMo.woff')
    format('woff');
  font-weight: normal;
  font-style: normal;
}

@font-face {
  font-family: 'IM_Hyemin-Bold';
  src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2106@1.1/IM_Hyemin-Bold.woff2')
    format('woff');
  font-weight: normal;
  font-style: normal;
}

@font-face {
  font-family: 'Mabinogi';
  src: url('fonts/Mabinogi_Classic_TTF.woff') format('woff');
  font-weight: normal;
  font-style: normal;
}

@font-face {
  font-family: 'Shilla_CultureB-Bold';
  src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2206-02@1.0/Shilla_CultureB-Bold.woff2%27')
    format('woff2');
  font-weight: 700;
  font-style: normal;
}

/*
* {
  font-family: 'IM_Hyemin-Bold';
} */

* {
  font-family: 'Mabinogi';
}

*::-webkit-scrollbar {
  width: 10px;
}
*::-webkit-scrollbar-thumb {
  background-color: #467302;
  border-radius: 10px;
  width: 8px;
  background-clip: padding-box;
  border: 2px solid transparent;
}
*::-webkit-scrollbar-track {
  background-color: #bcd497;
  opacity: 0.5;
  border-radius: 10px;
  box-shadow: inset 0px 0px 5px white;
}
</style>
