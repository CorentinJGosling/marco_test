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

const categoryButtons = document.querySelectorAll(".category-buttons button");
const cards = document.querySelectorAll(".card");

categoryButtons.forEach((button) => {
  button.addEventListener("click", () => {
    const category = button.getAttribute("data-category");
    cards.forEach((card) => {
      if (
        category === "all" ||
        card.getAttribute("data-category") === category
      ) {
        card.classList.add("show");
      } else {
        card.classList.remove("show");
      }
    });
    categoryButtons.forEach((btn) => {
      btn.classList.remove("active");
    });
    button.classList.add("active");
  });
});

// Show all cards by default
cards.forEach((card) => {
  card.classList.add("show");
});

// Activate the "All" button by default
categoryButtons[0].classList.add("active");

// MODALS --------------------
var modals = document.getElementsByClassName("modal");
var modalOpenBtn = document.getElementsByClassName("modalOpenBtn");
var currentModal = null;

// Function to open modal by id
function openModal(id) {
  for (i = 0; i < modals.length; i++) {
    if (modals[i].getAttribute("id") == id) {
      currentModal = modals[i];
      currentModal.style.display = "block";
      break;
    }
  }
}

// When the user clicks the button, open modal with the same id
modalOpenBtn.onclick = function () {
  let currentID = modalOpenBtn.getAttribute("id");
  openModal(currentID);
};

// When the user clicks anywhere outside of the modal or the X, close
window.onclick = function (event) {
  if (
    event.target == currentModal ||
    event.target.getAttribute("class") == "modalClose"
  ) {
    currentModal.style.display = "none";
  }
};

var complementaryColor = "#43DA8A",
  pharmaColor = "#DA8143",
  psyColor = "#43ACDA";

Highcharts.chart("container", {
  chart: {
    type: "networkgraph",
    marginTop: 80,
  },

  title: {
    text: "List of all interventions contained in the database",
  },

  subtitle: {
    text: "Retrieve a description of the key interventions below",
  },

  plotOptions: {
    networkgraph: {
      keys: ["from", "to"],
      layoutAlgorithm: {
        enableSimulation: true,
        integration: "verlet",
        linkLength: 100,
      },
    },
  },

  series: [
    {
      marker: {
        radius: 23,
      },
      dataLabels: {
        enabled: true,
        linkFormat: "",
        allowOverlap: true,
        style: {
          fontSize: "0.8rem",
        },
      },
      data: [
        ["Complementary", "acetyl-L-carnitine+alpha-lipoic acid"],
        ["Complementary", "acetylsalicylic acid"],
        ["Complementary", "agomelatin"],
        ["Complementary", "allopurinol"],
        ["Pharmacological", "amitriptyline"],
        ["Pharmacological", "armodafinil"],
        ["Pharmacological", "asenapine"],
        ["Pharmacological", "brexpiprazole"],

        ["Psychosocial", "CBT"],
        ["Psychosocial", "carer-focused"],
        ["Psychosocial", "family focused"],
        ["Psychosocial", "creatine"],

        ["Pharmacological", "Complementary"],
        ["Pharmacological", "Psychosocial"],
        ["Complementary", "Psychosocial"],
      ],
      nodes: [
        {
          id: "Complementary",
          color: complementaryColor,
          marker: {
            radius: 33,
          },
          dataLabels: {
            style: {
              fontSize: "1.2rem",
            },
          },
        },

        {
          id: "Psychosocial",
          color: psyColor,
          marker: {
            radius: 33,
          },
          dataLabels: {
            style: {
              fontSize: "1.2rem",
            },
          },
        },
        {
          id: "Pharmacological",
          color: pharmaColor,
          marker: {
            radius: 33,
          },
          dataLabels: {
            style: {
              fontSize: "1.2rem",
            },
          },
        },

        {
          id: "acetyl-L-carnitine+alpha-lipoic acid",
          color: complementaryColor,
        },
        {
          id: "acetylsalicylic acid",
          color: complementaryColor,
        },
        {
          id: "agomelatin",
          color: complementaryColor,
        },
        {
          id: "allopurinol",
          color: complementaryColor,
        },
        {
          id: "amitriptyline",
          color: pharmaColor,
        },
        {
          id: "armodafinil",
          color: pharmaColor,
        },
        {
          id: "asenapine",
          color: pharmaColor,
        },
        {
          id: "brexpiprazole",
          color: pharmaColor,
        },
        {
          id: "CBT",
          color: psyColor,
        },
        {
          id: "carer-focused",
          color: psyColor,
        },
        {
          id: "family focused",
          color: psyColor,
        },
        {
          id: "creatine",
          color: psyColor,
        },
      ],
    },
  ],
});
