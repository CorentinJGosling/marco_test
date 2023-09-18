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

// Themes begin
am4core.useTheme(am4themes_animated);
// Themes end

var chart = am4core.create("chartdiv", am4plugins_wordCloud.WordCloud);
var series = chart.series.push(new am4plugins_wordCloud.WordCloudSeries());
chart.logo.disabled = true;

series.accuracy = 4;
series.step = 15;
series.rotationThreshold = 0.7;
series.maxCount = 100;
series.minWordLength = 2;
series.labels.template.tooltipText = "{word} (n comparisons = {value})";
series.fontFamily = "Courier New";
series.maxFontSize = am4core.percent(30);

series.text =
  "acetyl-L-carnitine+alpha-lipoic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, acetylsalicylic acid, agomelatin, agomelatin, agomelatin, agomelatin, agomelatin, agomelatin, agomelatin, allopurinol, allopurinol, allopurinol, allopurinol, allopurinol, allopurinol, allopurinol, allopurinol, amitriptyline, amitriptyline, amitriptyline, amitriptyline, amitriptyline, amitriptyline, amitriptyline, amitriptyline, amitriptyline, amitriptyline, amitriptyline, amitriptyline, amitriptyline, amitriptyline, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole, aripiprazole LAI, aripiprazole LAI, aripiprazole LAI, aripiprazole LAI, aripiprazole LAI, aripiprazole LAI, aripiprazole LAI, aripiprazole LAI, aripiprazole LAI, aripiprazole LAI, aripiprazole LAI, aripiprazole LAI, aripiprazole+divalproate, aripiprazole+divalproate, aripiprazole+divalproate, aripiprazole+divalproate, aripiprazole+divalproate, aripiprazole+divalproate, aripiprazole+divalproate, aripiprazole+divalproate, aripiprazole+lamotrigine, aripiprazole+lamotrigine, aripiprazole+lamotrigine, aripiprazole+lamotrigine, aripiprazole+lamotrigine, aripiprazole+lamotrigine, aripiprazole+lamotrigine, aripiprazole+lamotrigine, aripiprazole+lamotrigine, aripiprazole+lamotrigine, aripiprazole+lamotrigine, aripiprazole+lithium/divalproate, aripiprazole+lithium/divalproate, aripiprazole+lithium/divalproate, aripiprazole+lithium/divalproate, aripiprazole+lithium/divalproate, aripiprazole+lithium/divalproate, aripiprazole+lithium/divalproate, aripiprazole+lithium/divalproate, armodafinil, armodafinil, armodafinil, armodafinil, armodafinil, armodafinil, armodafinil, armodafinil, armodafinil, armodafinil, armodafinil, armodafinil, armodafinil, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, asenapine, brexpiprazole, brexpiprazole, brexpiprazole, brexpiprazole, brexpiprazole, brexpiprazole, brexpiprazole, brexpiprazole, brexpiprazole, brexpiprazole, bright light therapy, bright light therapy, bright light therapy, bright light therapy, bright light therapy, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, bupropion, carbamazapine, carbamazapine, carbamazapine, carbamazapine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carbamazepine, carer focused intervention, carer focused intervention, carer focused intervention, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, cariprazine, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT, CBT+psychoeducation, CBT+psychoeducation, CBT+psychoeducation, celecoxib, celecoxib, celecoxib, celecoxib, celecoxib, celecoxib, celecoxib, celecoxib, chlorpromazine, chlorpromazine, chlorpromazine, chlorpromazine, choline, citalopram, citalopram, citalopram, citalopram, citalopram, citalopram, citalopram, citalopram, citalopram, citalopram, citalopram, citalopram, citalopram, citalopram, clonazepam, coenzyme Q10, coenzyme Q10, coenzyme Q10, coenzyme Q10, coenzyme Q10, coenzyme Q10, coenzyme Q10, creatine, creatine, creatine, creatine, creatine, creatine, creatine, creatine, creatine, creatine, dextromethorphan, dextromethorphan, dextromethorphan, dextromethorphan, dextromethorphan, dextromethorphan, dextromethorphan, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, divalproate, ECT, ECT, ECT, ECT, ECT, ECT, erythropoietin, erythropoietin, erythropoietin, erythropoietin, erythropoietin, escitalopram, escitalopram, escitalopram, escitalopram, escitalopram, escitalopram, escitalopram, eslicarbazepine, eslicarbazepine, eslicarbazepine, eslicarbazepine, family focused therapy, family focused therapy, family focused therapy, family/conjoint therapy, family/conjoint therapy, family/conjoint therapy, family/conjoint therapy, family/conjoint therapy, family/conjoint therapy, family/conjoint therapy, family/conjoint therapy, family/conjoint therapy, family/conjoint therapy, family/conjoint therapy, family/conjoint therapy, family/conjoint therapy, family/conjoint therapy, family/conjoint therapy, family/conjoint therapy, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, fluoxetine, flupentixol+lithium, folic acid, functional remediation, functional remediation, gabapentin, gabapentin, gabapentin, gabapentin, gabapentin, gabapentin, gabapentin, gabapentin, gabapentin, gabapentin, gabapentin, gabapentin, gabapentin, gabapentin, gabapentin, gabapentin, galantamine, galantamine, galantamine, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol, haloperidol+lithium/divalproate, haloperidol+lithium/divalproate, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, imipramine, infliximab, infliximab, infliximab, infliximab, infliximab, infliximab, infliximab, infliximab, inositol, inositol, inositol, inositol, inositol, inositol, inositol, inositol, inositol, inositol, inositol, inositol, inositol, inositol, inositol, inositol, inositol, inositol, inositol, inositol, inositol, insulin, insulin, insulin, IPSRT, IPSRT, IPSRT, IPSRT, IPSRT, IPSRT, IPSRT, ketamine, ketamine, ketamine, ketamine, ketamine, ketamine, ketamine, ketamine, ketamine, ketamine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, lamotrigine, levetiracetam, levetiracetam, levetiracetam, levetiracetam, levetiracetam, levetiracetam, levetiracetam, licarbazepine, licarbazepine, licarbazepine, lisdexamfetamine, lisdexamfetamine, lisdexamfetamine, lisdexamfetamine, lisdexamfetamine, lisdexamfetamine, lisdexamfetamine, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium, lithium+imipramine, lithium+imipramine, lithium+imipramine, lithium+imipramine, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone, lurasidone+lithium/divalproate, lurasidone+lithium/divalproate, lurasidone+lithium/divalproate, lurasidone+lithium/divalproate, lurasidone+lithium/divalproate, lurasidone+lithium/divalproate, lurasidone+lithium/divalproate, lurasidone+lithium/divalproate, melatonin, memantine, memantine, memantine, memantine, memantine, memantine, memantine, memantine, memantine, memantine, mifepristone, mifepristone, mifepristone, mifepristone, minocycline, minocycline, minocycline, minocycline, minocycline, minocycline, minocycline, minocycline, minocycline, minocycline, minocycline, minocycline, minocycline, minocycline, minocycline+acetylsalicylic acid, minocycline+acetylsalicylic acid, minocycline+acetylsalicylic acid, minocycline+acetylsalicylic acid, minocycline+acetylsalicylic acid, minocycline+acetylsalicylic acid, minocycline+acetylsalicylic acid, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine, n-acetyl cysteine+acetylsalicylic acid, n-acetyl cysteine+acetylsalicylic acid, n-acetyl cysteine+acetylsalicylic acid, n-acetyl cysteine+acetylsalicylic acid, n-acetyl cysteine+acetylsalicylic acid, n-acetyl cysteine+acetylsalicylic acid, n-acetyl cysteine+acetylsalicylic acid, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine, olanzapine+fluoxetine, olanzapine+fluoxetine, olanzapine+fluoxetine, olanzapine+fluoxetine, olanzapine+fluoxetine, olanzapine+fluoxetine, olanzapine+fluoxetine, olanzapine+fluoxetine, olanzapine+fluoxetine, olanzapine+fluoxetine, olanzapine+fluoxetine, olanzapine+lithium/divalproate, olanzapine+lithium/divalproate, olanzapine+lithium/divalproate, olanzapine+lithium/divalproate, olanzapine+lithium/divalproate, olanzapine+lithium/divalproate, olanzapine+lithium/divalproate, omega3, omega3, omega3, omega3, omega3, omega3, omega3, omega3, omega3, omega3, omega3, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paliperidone, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine, paroxetine+bupropion, paroxetine+bupropion, paroxetine+bupropion, paroxetine+bupropion, paroxetine+bupropion, paroxetine+bupropion, phenelzine, phenelzine, phenelzine, phenelzine, phenelzine, phenelzine, phenelzine, pindolol, pindolol, pindolol, pindolol, pindolol, pindolol, pindolol, pioglitazone, pioglitazone, pioglitazone, pioglitazone, pioglitazone, pioglitazone, pioglitazone, pramipexole, pramipexole, pramipexole, pramipexole, pramipexole, pramipexole, pramipexole, pregnenolone, pregnenolone, pregnenolone, pregnenolone, pregnenolone, pregnenolone, pregnenolone, psychoeducation, psychoeducation, psychoeducation, psychoeducation, psychoeducation, psychoeducation, psychoeducation, psychoeducation, psychoeducation, psychoeducation, psychoeducation, psychoeducation, psychoeducation, psychoeducation, psychoeducation, psychoeducation brief, psychoeducation brief, psychoeducation group, psychoeducation group, psychoeducation group, psychoeducation individual, psychoeducation individual, psychoeducation individual, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine, quetiapine+lithium/divalproate, quetiapine+lithium/divalproate, quetiapine+lithium/divalproate, quetiapine+lithium/divalproate, quetiapine+lithium/divalproate, quetiapine+lithium/divalproate, quetiapine+lithium/divalproate, quetiapine+lithium/divalproate, quetiapine+lithium/divalproate, ramelteon, ramelteon, ramelteon, ramelteon, ramelteon, ramelteon, ramelteon, ramelteon, ramelteon, ramelteon, ramelteon, ramelteon, ramelteon, ramelteon, ramelteon, ramelteon, ramelteon, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, risperidone LAI, rTMS, rTMS, rTMS, rTMS, rTMS, rTMS, rTMS, rTMS, rTMS bilateral, rTMS high, rTMS high, rTMS high, rTMS high, rTMS high, rTMS low, rTMS low, sAME, sAME, sAME, sAME, sAME, sAME, sAME, sertraline, sertraline, sertraline, sertraline, sertraline, sertraline, sertraline, t3 hormone, t3 hormone, t3 hormone, t3 hormone, t3 hormone, t3 hormone, t3 hormone, t4 hormone, t4 hormone, t4 hormone, t4 hormone, t4 hormone, t4 hormone, t4 hormone, tamoxifen, tamoxifen, tamoxifen, tamoxifen, tamoxifen, tamoxifen, tamoxifen, tamoxifen, tamoxifen, tamoxifen, tamoxifen, tamoxifen, tamoxifen, tamoxifen, tamoxifen, tamoxifen, tamoxifen, tDCS, tDCS, tianeptine, tianeptine, topiramate, topiramate, topiramate, topiramate, topiramate, topiramate, total sleep deprivation, valnoctamide, valnoctamide, valnoctamide, valnoctamide, valnoctamide, verapamil, verapamil, verapamil, verapamil, verapamil, vitD3, vitD3, vitD3, vitD3, vitD3, vitD3, vitD3, withania somnifer, withania somnifer, withania somnifer, withania somnifer, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone, ziprasidone+lithium/divalproate, ziprasidone+lithium/divalproate, ziprasidone+lithium/divalproate, ziprasidone+lithium/divalproate, ziprasidone+lithium/divalproate, ziprasidone+lithium/divalproate, ziprasidone+lithium/divalproate, ziprasidone+lithium/divalproate";
// var complementaryColor = "#43DA8A",
//   pharmaColor = "#DA8143",
//   psyColor = "#43ACDA";

// Highcharts.chart("container", {
//   chart: {
//     type: "networkgraph",
//     marginTop: 80,
//   },

//   title: {
//     text: "List of all interventions contained in the database",
//   },

//   subtitle: {
//     text: "Retrieve a description of the key interventions below",
//   },

//   plotOptions: {
//     networkgraph: {
//       keys: ["from", "to"],
//       layoutAlgorithm: {
//         enableSimulation: true,
//         integration: "verlet",
//         linkLength: 100,
//       },
//     },
//   },

//   series: [
//     {
//       marker: {
//         radius: 23,
//       },
//       dataLabels: {
//         enabled: true,
//         linkFormat: "",
//         allowOverlap: true,
//         style: {
//           fontSize: "0.8rem",
//         },
//       },
//       data: [
//         ["Complementary", "acetyl-L-carnitine+alpha-lipoic acid"],
//         ["Complementary", "acetylsalicylic acid"],
//         ["Complementary", "agomelatin"],
//         ["Complementary", "allopurinol"],
//         ["Pharmacological", "amitriptyline"],
//         ["Pharmacological", "armodafinil"],
//         ["Pharmacological", "asenapine"],
//         ["Pharmacological", "brexpiprazole"],

//         ["Psychosocial", "CBT"],
//         ["Psychosocial", "carer-focused"],
//         ["Psychosocial", "family focused"],
//         ["Psychosocial", "creatine"],

//         ["Pharmacological", "Complementary"],
//         ["Pharmacological", "Psychosocial"],
//         ["Complementary", "Psychosocial"],
//       ],
//       nodes: [
//         {
//           id: "Complementary",
//           color: complementaryColor,
//           marker: {
//             radius: 33,
//           },
//           dataLabels: {
//             style: {
//               fontSize: "1.2rem",
//             },
//           },
//         },

//         {
//           id: "Psychosocial",
//           color: psyColor,
//           marker: {
//             radius: 33,
//           },
//           dataLabels: {
//             style: {
//               fontSize: "1.2rem",
//             },
//           },
//         },
//         {
//           id: "Pharmacological",
//           color: pharmaColor,
//           marker: {
//             radius: 33,
//           },
//           dataLabels: {
//             style: {
//               fontSize: "1.2rem",
//             },
//           },
//         },

//         {
//           id: "acetyl-L-carnitine+alpha-lipoic acid",
//           color: complementaryColor,
//         },
//         {
//           id: "acetylsalicylic acid",
//           color: complementaryColor,
//         },
//         {
//           id: "agomelatin",
//           color: complementaryColor,
//         },
//         {
//           id: "allopurinol",
//           color: complementaryColor,
//         },
//         {
//           id: "amitriptyline",
//           color: pharmaColor,
//         },
//         {
//           id: "armodafinil",
//           color: pharmaColor,
//         },
//         {
//           id: "asenapine",
//           color: pharmaColor,
//         },
//         {
//           id: "brexpiprazole",
//           color: pharmaColor,
//         },
//         {
//           id: "CBT",
//           color: psyColor,
//         },
//         {
//           id: "carer-focused",
//           color: psyColor,
//         },
//         {
//           id: "family focused",
//           color: psyColor,
//         },
//         {
//           id: "creatine",
//           color: psyColor,
//         },
//       ],
//     },
//   ],
// });
