source(file="cmd/_star_lib.R")


cmd <- star_parse_stata_command("varlist")

model <- model(cmd$varlist)
HTML.title(paste ("OLS regression model of <span class='badge'><em>",model$outcome, "</em></span> by ",model$pretty_predictors), HR=2)

HTML(star.cmdline)


ols <- eval(parse(text=model$syntax))
HTML(summary(ols))


HTML.title("Diagnostic plots", HR=3)
opar <- par(mfrow = c(2,2), oma = c(0, 0, 1.1, 0))
plot(ols, las = 1)
HTMLplot() 
dev.off()


