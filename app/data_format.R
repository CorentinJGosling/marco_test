res = readxl::read_excel("dat.xlsx")

res$Outcome = res$Outcome_new...50
res$TE = round(ifelse(res$`ES_type...51`=="SMD", res$ES_checked, log(res$ES_checked) * sqrt(3) / pi), 2)
res$invTE = -res$TE
res$TE_lo = round(ifelse(res$`ES_type...51`=="SMD", res$ES_lowCI_checked, log(res$ES_lowCI_checked) * sqrt(3) / pi), 2)
res$TE_up = round(ifelse(res$`ES_type...51`=="SMD", res$ES_upCI_checked, log(res$ES_upCI_checked) * sqrt(3) / pi), 2)
res$seTE = round(abs((res$TE_up - res$TE_lo)/3.92), 2)
res$NNT_transit = round(dmetar::NNT(res$TE), 2)
res$eNNT = ifelse(res$NNT_transit > 0,
                 paste0("eNNT=", res$NNT_transit),
                 ifelse(
                   res$NNT_transit == 0,
                   "N/A",
                   paste0("eNNH=", abs(res$NNT_transit))))
breaks <- c(-Inf, seq(-0.8, 0.8, length.out = 19), Inf)
TE_cat <- cut(res$TE, breaks, labels = 1:20)
res$Efficacy = paste0(
  "eSMD=", res$TE, " [", res$TE_lo, ", ", res$TE_up, "]", " <br> ",
  '<img src="https://www.linkpicture.com/q/Diapositive', TE_cat, '.png" height="30" width="60%" data-toggle="tooltip" data-placement="right"></img>'
)
res$Paper = paste0("<a href='https://doi.org/", res$`doi of PDF`, "' target=\"_blank\">", res$`First author`, " (", res$Year, ")", "</a>")
res$Meta_review = paste0(res$`First author`, " (", res$Year, ")")

res$'GRADE, certainty of evidence' =  with(res, ifelse(
  GRADEfinal == "HIGH", "I (High)", ifelse(
    GRADEfinal == "MODERATE", "II (Moderate)", ifelse(
      GRADEfinal == "LOW", "III (Low)", "IV (Very Low)"))))
res$Rank = res$'GRADE, certainty of evidence'
res$img_cert = with(res, ifelse(
  GRADEfinal == "HIGH", "High <br> <img src=\"https://www.linkpicture.com/q/Diapositive1_2.png", ifelse(
    GRADEfinal == "MODERATE", "Moderate <br> <img src=\"https://www.linkpicture.com/q/Diapositive2_1.png", ifelse(
      GRADEfinal == "LOW", "Low <br> <img src=\"https://www.linkpicture.com/q/Diapositive3_1.png",
      "Very Low <br> <img src=\"https://www.linkpicture.com/q/Diapositive4_1.png"))))

res$GRADE = paste0(
  res$img_cert,
  '\" height=\"30\" data-toggle=\"tooltip\" data-placement=\"right\"',
  "\"></img>")
res$AMSTAR <- res$`AMSTAR-2...59`
res$AMSTAR[res$AMSTAR == "CRITICALLY LOW"] <- "Critically Low"
res$AMSTAR[res$AMSTAR == "LOW"] <- "Low"
res$AMSTAR[res$AMSTAR == "HIGH"] <- "High"


res$Age <- res$age_group
res$Age[res$Age == "Mixed children/adolescents/adults"] <- "Mixed (Children-Adults)"
res$Age[res$Age == "Adults only"] <- "Adults"
res$Age[res$Age == "Children/adolescents"] <- "Children & Adolescents"
res$BD_stage <- res$BDstage

res$Outcome = stringr::str_trunc(res$Outcome, 20)
res$Design[res$Design =="MA"] <- "Pairwise meta-analysis"
res$Design[res$Design =="NMA"] <- "Network meta-analysis"
res$Comparison = res$Comparison


exp_dat = res[,c(
  "Paper", "Intervention", "Outcome", "Efficacy", "eNNT", "GRADE", "AMSTAR", "k", "Design",
  "Age", "BD_stage", "Comparison", "Comparison_type",  "TE", "seTE", "Rank", "Meta_review",
  "invTE", "TE_lo", "TE_up", "Intervention_acro", "Comparison_acro"
)]
rio::export(exp_dat, "dat.txt")

# source("plot_umb.R")

#
# # View the resulting categories
# categories
# res$img_eff = with(res, ifelse(
#   TE >= 0.80, paste0("SMD=", TE, " [", res$TE_lo, ", ", res$TE_up, "]", " <br> ", "<img src=\"https://www.linkpicture.com/q/eff9.png"), ifelse(
#     TE >= 0.50, paste0("SMD=", TE, " [", res$TE_lo, ", ", res$TE_up, "]", " <br> ", "<img src=\"https://www.linkpicture.com/q/eff8.png"), ifelse(
#       TE >= 0.20, paste0("SMD=", TE, " [", res$TE_lo, ", ", res$TE_up, "]", " <br> ", "<img src=\"https://www.linkpicture.com/q/eff7.png"), ifelse(
#         TE >= -0.20, paste0("SMD=", TE, " [", res$TE_lo, ", ", res$TE_up, "]", " <br> ", "<img src=\"https://www.linkpicture.com/q/eff5.png"), ifelse(
#           TE >= -0.50, paste0("SMD=", TE, " [", res$TE_lo, ", ", res$TE_up, "]", " <br> ", "<img src=\"https://www.linkpicture.com/q/eff3.png"), ifelse(
#             TE >= -0.80, paste0("SMD=", TE, " [", res$TE_lo, ", ", res$TE_up, "]", " <br> ", "<img src=\"https://www.linkpicture.com/q/eff2.png"),
#             paste0("SMD=", TE, " [", res$TE_lo, ", ", res$TE_up, "]", " <br> ", "<img src=\"https://www.linkpicture.com/q/eff1.png"))))))))
# res$Efficacy = paste0(
#   # "<img src=\"https://www.linkpicture.com/q/",
#   res$img_eff,
#   '\" height=\"30\" width=\"100%\" data-toggle=\"tooltip\" data-placement=\"right\"',
#   "\"></img>")
