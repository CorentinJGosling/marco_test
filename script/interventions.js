const navbar = document.querySelector("nav");
window.addEventListener("scroll", () => {
  if (window.scrollY > 0) {
    navbar.classList.add("scrolled");
  } else {
    navbar.classList.remove("scrolled");
  }
});
const navLinks = document.querySelector(".nav-links");
var navIcons = document.querySelectorAll("#hamburger-menu");

navIcons.forEach(function (navIcon) {
  navIcon.addEventListener("click", function () {
    navIcon.classList.toggle("open");
    navLinks.classList.toggle("open");
  });
});
const navLinksli = document.querySelectorAll(".nav-links li");

navLinksli.forEach((link) => {
  link.addEventListener("click", () => {
    const href = link.querySelector("a").getAttribute("href");
    window.location.href = href;
  });
});

const categoryButtons = document.querySelectorAll('.category-buttons button');
const cards = document.querySelectorAll('.card');

categoryButtons.forEach(button => {
  button.addEventListener('click', () => {
    const category = button.getAttribute('data-category');
    cards.forEach(card => {
      if (category === 'all' || card.getAttribute('data-category') === category) {
        card.classList.add('show');
      } else {
        card.classList.remove('show');
      }
    });
    categoryButtons.forEach(btn => {
      btn.classList.remove('active');
    });
    button.classList.add('active');
  });
});

// Show all cards by default
cards.forEach(card => {
  card.classList.add('show');
});

// Activate the "All" button by default
categoryButtons[0].classList.add('active');
