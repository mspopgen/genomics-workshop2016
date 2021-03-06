library(GenABEL)

ruff.data <- load.gwaa.data(phe = "phe_RUFF.txt", gen = "gen_RUFF_qc.raw", force = T)

qc <- check.marker(ruff.data, callrate = 0.66, p.level = 1e-5, perid.call = 0, extr.perid.call = 0, ibs.mrk = -1)
ruff.clean <- ruff.data[qc$idok, qc$snpok]

descriptives.trait(ruff.clean)
descriptives.marker(ruff.clean)

fo.QT <- qtscore(fo ~ 1, data = ruff.clean, trait = "binomial")

summary(fo.QT)
summary(fo.QT, top = 30)
sum(fo.QT[, "P1df"] <= 0.0001)

png("fo-qt.png")
plot(fo.QT, col = c("black", "black"), ystart = 1)
dev.off()

fo.QT100 <- qtscore(fo ~ 1, data = ruff.clean, trait = "binomial", times = 100)
summary(fo.QT100)

lambda(fo.QT)
gkin <- ibs(ruff.clean)
mds <- cmdscale(as.dist(0.5 - gkin))
fo.QTibs <- qtscore(fo ~ mds[, 1] + mds[, 2], data = ruff.clean, trait.type = "binomial")
summary(fo.QTibs)

png("fo-qtibs.png")
plot(fo.QTibs, col = c("black", "black"), ystart = 1)
dev.off()
