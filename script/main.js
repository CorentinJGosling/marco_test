const navbar = document.querySelector("nav");
const home = document.querySelector(".homepage");
const team = document.querySelector(".teampage");
const teamSection = document.querySelector("#sec_team");

// NAVIGATION bar tracker for the team section ============================
const observer = new IntersectionObserver((entries) => {
  console.log(entries); // log the entries array
  if (entries[0].isIntersecting) {
    // console.log("Visible");
    home.classList.remove("currentpage");
    team.classList.add("currentpage");
  } else {
    // console.log("Not visible");
    home.classList.add("currentpage");
    team.classList.remove("currentpage");
  }
});

observer.observe(teamSection);

// mother platform button  ================================================
// opening buttons
const closeBtn = document.querySelector(".close-btn");
const motherplat = document.querySelector(".motherplat");
closeBtn.addEventListener("click", (event) => {
  motherplat.style.display = "none";
  event.stopPropagation();
});

window.addEventListener("click", (event) => {
  if (event.target === motherplat) {
    motherplat.style.display = "none";
  }
});

// TEAM ===================================================================
// opening buttons
const readMoreButtonMS = document.getElementById("readmore_buttonMS");
const readMoreContentMS = document.getElementById("read_more_textMS");
const plusIconMS = document.getElementById("plusIconMS");
const readMoreButtonCG = document.getElementById("readmore_buttonCG");
const readMoreContentCG = document.getElementById("read_more_textCG");
const plusIconCG = document.getElementById("plusIconCG");
const readMoreButtonSC = document.getElementById("readmore_buttonSC");
const readMoreContentSC = document.getElementById("read_more_textSC");
const plusIconSC = document.getElementById("plusIconSC");
const readMoreButtonJF = document.getElementById("readmore_buttonJF");
const readMoreContentJF = document.getElementById("read_more_textJF");
const plusIconJF = document.getElementById("plusIconJF");

readMoreButtonMS.addEventListener("click", function () {
  readMoreButtonMS.classList.toggle("rmv_border");
  readMoreContentMS.classList.toggle("show-read-more");
  readMoreContentMS.classList.toggle("add_border");
  plusIconMS.classList.toggle("rotate-45");
});

readMoreButtonCG.addEventListener("click", function () {
  readMoreButtonCG.classList.toggle("rmv_border");
  readMoreContentCG.classList.toggle("show-read-more");
  readMoreContentCG.classList.toggle("add_border");
  plusIconCG.classList.toggle("rotate-45");
});

readMoreButtonSC.addEventListener("click", function () {
  readMoreButtonSC.classList.toggle("rmv_border");
  readMoreContentSC.classList.toggle("show-read-more");
  readMoreContentSC.classList.toggle("add_border");
  plusIconSC.classList.toggle("rotate-45");
});

readMoreButtonJF.addEventListener("click", function () {
  readMoreButtonJF.classList.toggle("rmv_border");
  readMoreContentJF.classList.toggle("show-read-more");
  readMoreContentJF.classList.toggle("add_border");
  plusIconJF.classList.toggle("rotate-45");
});

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

// window.onload = function () {
//   var loading = document.querySelector(".wave");
//   loading.style.display = "none";
// };
const navLinksli = document.querySelectorAll(".nav-links li");

navLinksli.forEach((link) => {
  link.addEventListener("click", () => {
    const href = link.querySelector("a").getAttribute("href");
    window.location.href = href;
  });
});

window.addEventListener("load", function () {
  var loading = document.querySelector(".wave");
  var delayInMilliseconds = 1500; // 1.5 seconds

  // Hide the loading animation after the minimum time has elapsed
  setTimeout(function () {
    loading.classList.add("fade");
  }, delayInMilliseconds);
});

// EMAIL sending ===============================================
function CheckMail() {
  var boxID = document.getElementById("form_id");
  var NameID = document.getElementById("fullName").value;
  var emailID = document.getElementById("email_id").value;
  var messID = document.getElementById("message").value;
  const fail = document.querySelector(".formFail");
  const succ = document.querySelector(".formSent");

  if (NameID == "" || emailID == "" || messID == "") {
    fail.style.display = "block";
  } else {
    SendMail();
    boxID.style.display = "none";
    succ.style.display = "block";
    fail.style.display = "none";
  }
}
function SendMail() {
  var params = {
    from_name: document.getElementById("fullName").value,
    email_id: document.getElementById("email_id").value,
    message: document.getElementById("message").value,
  };
  emailjs
    .send("service_arfxued", "template_195breu", params)
    .then(function (res) {
      if (res.status == 200) {
        // mess =
        //   "Your message has been sent! You will hear from us in the coming days.";
      } else {
        mess =
          "Your message has not been sent! Please send you inquiry directly by email at x@x.";
      }
      alert(mess);
    });
}
