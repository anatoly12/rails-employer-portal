history.scrollRestoration = 'manual';
let scrollPosition = null;
document.addEventListener('turbolinks:render', () => {
  if(scrollPosition!=null){
    window.scrollTo({left: 0, top: scrollPosition, behavior: "auto"});
    scrollPosition = null;
  }
});
document.addEventListener('turbolinks:load', () => {
  const elements = document.querySelectorAll(`[data-persist-scroll]`)
  for (let i = 0; i < elements.length; i++) {
    elements[i].addEventListener('click', () => {
      document.addEventListener("turbolinks:before-render", () => {
        scrollPosition = window.scrollY;
      }, {once: true});
    });
  }
});
