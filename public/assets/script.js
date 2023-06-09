document.addEventListener("DOMContentLoaded", function() {
  const slider = tns({
    container: ".my-slider",
    items: 1,
    slideBy: "page",
    autoplay: true,
    autoplayButtonOutput: false,
    controls: true,
    nav: false
  });
});