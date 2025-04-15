* Importing crime data and generating indicators for missing values
import delimited "C:\Stata\Stata Project\Crime_Data_from_2020_to_Present.csv", clear

* Scatter plot of crimerateper100000people against avgage
scatter crimerateper100000people avgage

* Regression analysis with crimerateper100000people as the dependent variable and various independent variables
reg crimerateper100000people avgfemaleratio avgmaleration avgunknownration ratioasian ratioblack ratiochinese ratiocambodian ratiofilipino ratioguamanian ratiohispanic ratioamericanindian ratiojapanese ratiokorean ratioloation ratioother ratiopacificislander ratiosamoan ratiohawaiin ratiovietnamese ratiowhite ratioasianindian ratiounknowndescent avgage

* Generate a new variable "crime_rate" by dividing crimerateper100000people by 100,000
gen crime_rate = (crimerateper100000people/100000)

* Regression analysis with crime_rate as the dependent variable and the same independent variables
reg crime_rate avgfemaleratio avgmaleration avgunknownration ratioasian ratioblack ratiochinese ratiocambodian ratiofilipino ratioguamanian ratiohispanic ratioamericanindian ratiojapanese ratiokorean ratioloation ratioother ratiopacificislander ratiosamoan ratiohawaiin ratiovietnamese ratiowhite ratioasianindian ratiounknowndescent avgage

* Sort the dataset by Area_Name
sort areaname

* Create a unique identifier for each distinct value of Area Name
gen area_id = _n if areaname != areaname[_n-1]

* Replace missing values in area_id with the previous non-missing value
replace area_id = area_id[_n-1] if missing(area_id)

* Create dummy variables for each distinct value of Area Name
foreach area in Central 77th_Street Pacific Southeast Olympic Newton N_Hollywood Hollywood Devonshire Southwest Topanga West_LA Van_Nuys Mission Rampart Harbor Foothill Wilshire West_Valley Hollenbeck Northeast {
    gen dummy_`area' = (areaname == "`area'")
}

* Drop the identifier variable (not needed anymore)
drop area_id

* Sort the dataset by Area_Name
sort Area_Name

* Create a unique identifier for each distinct value of Area Name
gen area_id = _n if Area_Name != Area_Name[_n-1]

* Replace missing values in area_id with the previous non-missing value
replace area_id = area_id[_n-1] if missing(area_id)

* Create dummy variables for each distinct value of Area Name
foreach area in Central 77th_Street Pacific Southeast Olympic Newton N_Hollywood Hollywood Devonshire Southwest Topanga West_LA Van_Nuys Mission Rampart Harbor Foothill Wilshire West_Valley Hollenbeck Northeast {
    gen dummy_`area' = (Area_Name == "`area'")
}

* Regression analysis with new variables and dummy variables
reg crimerateper100000people avgfemaleratio avgmaleration avgunknownration ratioasian ratioblack ratiochinese ratiocambodian ratiofilipino ratioguamanian ratiohispanic ratioamericanindian ratiojapanese ratiokorean ratioloation ratioother ratiopacificislander ratiosamoan ratiohawaiin ratiovietnamese ratiowhite ratioasianindian ratiounknowndescent dummy_Central dummy_77th_Street dummy_Pacific dummy_Southeast dummy_Olympic dummy_Newton dummy_N_Hollywood dummy_Hollywood dummy_Devonshire dummy_Southwest dummy_West_LA dummy_Van_Nuys dummy_Mission dummy_Rampart dummy_Harbor dummy_Foothill dummy_Wilshire dummy_West_Valley dummy_Hollenbeck dummy_Northeast

* Regression analysis with crime_rate as the dependent variable and the same independent variables and dummy variables
reg crime_rate avgfemaleratio avgmaleration avgunknownration ratioasian ratioblack ratiochinese ratiocambodian ratiofilipino ratioguamanian ratiohispanic ratioamericanindian ratiojapanese ratiokorean ratioloation ratioother ratiopacificislander ratiosamoan ratiohawaiin ratiovietnamese ratiowhite ratioasianindian ratiounknowndescent dummy_Central dummy_77th_Street dummy_Pacific dummy_Southeast dummy_Olympic dummy_Newton dummy_N_Hollywood dummy_Hollywood dummy_Devonshire dummy_Southwest dummy_West_LA dummy_Van_Nuys dummy_Mission dummy_Rampart dummy_Harbor dummy_Foothill dummy_Wilshire dummy_West_Valley dummy_Hollenbeck dummy_Northeast

* Generate a new variable "ln_crimerate" by taking the natural logarithm of crimerateper100000people
gen ln_crimerate = ln(crimerateper100000people)

* Regression analysis with ln_crimerate as the dependent variable and various independent variables
reg ln_crimerate avgfemaleratio avgmaleration avgunknownration ratioasian ratioblack ratiochinese ratiocambodian ratiofilipino ratioguamanian ratiohispanic ratioamericanindian ratiojapanese ratiokorean ratioloation ratioother ratiopacificislander ratiosamoan ratiohawaiin ratiovietnamese ratiowhite ratioasianindian ratiounknowndescent dummy_Central dummy_77th_Street dummy_Pacific dummy_Southeast dummy_Olympic dummy_Newton dummy_N_Hollywood dummy_Hollywood dummy_Devonshire dummy_Southwest dummy_West_LA dummy_Van_Nuys dummy_Mission dummy_Rampart dummy_Harbor dummy_Foothill dummy_Wilshire dummy_West_Valley dummy_Hollenbeck dummy_Northeast

* Regression analysis with ln_crimerate as the dependent variable and only demographic variables (excluding dummy variables)
reg ln_crimerate avgfemaleratio avgmaleration avgunknownration ratioasian ratioblack ratiochinese ratiocambodian ratiofilipino ratioguamanian ratiohispanic ratioamericanindian ratiojapanese ratiokorean ratioloation ratioother ratiopacificislander ratiosamoan ratiohawaiin ratiovietnamese ratiowhite ratioasianindian ratiounknowndescent

* Calculate means and standard deviations for each variable and standardize them
foreach var in avgage avgfemaleratio avgmaleration avgunknownration ratioasian ratioblack ratiochinese ratiocambodian ratiofilipino ratioguamanian ratiohispanic ratioamericanindian ratiojapanese ratiokorean ratioloation ratioother ratiopacificislander ratiosamoan ratiohawaiin ratiovietnamese ratiowhite ratioasianindian ratiounknowndescent {
    sum `var', meanonly
    gen `var'_std = (`var' - r(mean)) / r(sd)
}

* Standardize the dependent variable ln_crimerate
sum ln_crimerate, meanonly
gen ln_crimerate_std = (ln_crimerate - r(mean)) / r(sd)

* Standardize the variable crimerate
sum crimerate, meanonly
gen crimerate_std = (crimerate - r(mean)) / r(sd)

* Calculate means and standard deviations for each variable and standardize them
foreach var in avgage avgfemaleratio avgmaleration avgunknownration ratioasian ratioblack ratiochinese ratiocambodian ratiofilipino ratioguamanian ratiohispanic ratioamericanindian ratiojapanese ratiokorean ratioloation ratioother ratiopacificislander ratiosamoan ratiohawaiin ratiovietnamese ratiowhite ratioasianindian ratiounknowndescent {
    sum `var', meanonly
    gen `var'_mean = r(mean)
    gen `var'_std = (`var' - r(mean)) / r(sd)
}

* Standardize the dependent variable ln_crimerate
summarize ln_crimerate
gen ln_crimerate_mean = r(mean)
gen ln_crimerate_std = (ln_crimerate - r(mean)) / r(sd)

* Drop unnecessary variables
drop crimerate_std _mean _std ln_crimerate_mean ln_crimerate_std

* Calculate means and standard deviations for each variable and standardize them
foreach var in avgage avgfemaleratio avgmaleration avgunknownration ratioasian ratioblack ratiochinese ratiocambodian ratiofilipino ratioguamanian ratiohispanic ratioamericanindian ratiojapanese ratiokorean ratioloation ratioother ratiopacificislander ratiosamoan ratiohawaiin ratiovietnamese ratiowhite ratioasianindian ratiounknowndescent {
    summarize `var'
    gen `var'_mean = r(mean)
    gen `var'_std = (`var' - r(mean)) / r(sd)
}

* Calculate means and standard deviations for ln_crimerate and standardize it
summarize ln_crimerate
gen ln_crimerate_std = (ln_crimerate - r(mean)) / r(sd)

* Regression analysis with standardized ln_crimerate as the dependent variable and standardized independent variables
regress ln_crimerate_std avgage_std avgfemaleratio_std avgmaleration_std avgunknownration_std ratioasian_std ratioblack_std ratiochinese_std ratiocambodian_std ratiofilipino_std ratioguamanian_std ratiohispanic_std ratioamericanindian_std ratiojapanese_std ratiokorean_std ratioloation_std ratioother_std ratiopacificislander_std ratiosamoan_std ratiohawaiin_std ratiovietnamese_std ratiowhite_std ratioasianindian_std ratiounknowndescent_std

* Calculate correlations between standardized independent variables
correlate avgage_std avgfemaleratio_std avgmaleration_std avgunknownration_std ratioasian_std ratioblack_std ratiochinese_std ratiocambodian_std ratiofilipino_std ratioguamanian_std ratiohispanic_std ratioamericanindian_std ratiojapanese_std ratiokorean_std ratioloation_std ratioother_std ratiopacificislander_std ratiosamoan_std ratiohawaiin_std ratiovietnamese_std ratiowhite_std ratioasianindian_std ratiounknowndescent_std

* Regression analysis with standardized ln_crimerate as the dependent variable and only selected independent variables
regress ln_crimerate_std avgage_std avgfemaleratio_std avgmaleration_std avgunknownration_std ratioasian_std ratioblack_std ratiochinese_std ratiocambodian_std ratiofilipino_std ratioguamanian_std ratiohispanic_std ratiojapanese_std ratiokorean_std ratioloation_std ratioother_std ratiopacificislander_std ratiosamoan_std ratiohawaiin_std ratiovietnamese_std ratiowhite_std ratioasianindian_std

* Regression analysis with standardized ln_crimerate as the dependent variable and only selected independent variables
regress ln_crimerate_std avgage_std avgfemaleratio_std avgunknownration_std ratioasian_std ratioblack_std ratiochinese_std ratiocambodian_std ratiofilipino_std ratioguamanian_std ratiohispanic_std ratiojapanese_std ratiokorean_std ratioloation_std ratioother_std ratiopacificislander_std ratiosamoan_std ratiohawaiin_std ratiovietnamese_std ratiowhite_std ratioasianindian_std

* Regression analysis with standardized ln_crimerate as the dependent variable and only selected independent variables
regress ln_crimerate_std avgage_std avgfemaleratio_std avgmaleration_std ratioasian_std ratioblack_std ratiochinese_std ratiocambodian_std ratiofilipino_std ratioguamanian_std ratiohispanic_std ratiojapanese_std ratiokorean_std ratioloation_std ratioother_std ratiopacificislander_std ratiosamoan_std ratiohawaiin_std ratiovietnamese_std ratiowhite_std ratioasianindian_std

* Scatter plot of avgage against crimerateper100000people
scatter avgage crimerateper100000people

* Scatter plot of demographic variables against crimerateper100000people
scatter avgfemaleratio avgmaleration avgunknownration crimerateper100000people

* Scatter plot of demographic variables against ln_crimerate
scatter avgfemaleratio avgmaleration avgunknownration ln_crimerate

* Scatter plot of race variables against crime_rate
scatter ratioasian ratioblack ratiochinese ratiocambodian ratiofilipino ratioguamanian ratiohispanic ratioamericanindian ratiojapanese ratiokorean ratioloation ratioother ratiopacificislander ratiosamoan ratiohawaiin ratiovietnamese ratiowhite ratioasianindian ratiounknowndescent crime_rate
* Linear regression to predict crime rate with various demographic variables
reg crimerateper100000people avgfemaleratio avgmaleration avgunknownration ratioasian ratioblack ratiochinese ratiocambodian ratiofilipino ratioguamanian ratiohispanic ratioamericanindian ratiojapanese ratiokorean ratioloation ratioother ratiopacificislander ratiosamoan ratiohawaiin ratiovietnamese ratiowhite ratioasianindian ratiounknowndescent avgage

* Check for multicollinearity using collinearity diagnostics
collin avgfemaleratio avgmaleration avgunknownration ratioasian ratioblack ratiochinese ratiocambodian ratiofilipino ratioguamanian ratiohispanic ratioamericanindian ratiojapanese ratiokorean ratioloation ratioother ratiopacificislander ratiosamoan ratiohawaiin ratiovietnamese ratiowhite ratioasianindian ratiounknowndescent avgage

* Calculate correlation coefficients between variables
correlate avgfemaleratio avgmaleration avgunknownration ratioasian ratioblack ratiochinese ratiocambodian ratiofilipino ratioguamanian ratiohispanic ratioamericanindian ratiojapanese ratiokorean ratioloation ratioother ratiopacificislander ratiosamoan ratiohawaiin ratiovietnamese ratiowhite ratioasianindian ratiounknowndescent avgage

* Linear regression to predict crime rate with selected demographic variables
reg crimerateper100000people avgfemaleratio avgmaleration avgunknownration ratiocambodian ratiofilipino ratioguamanian ratiohispanic ratioamericanindian ratiojapanese ratiokorean ratioloation ratioother ratiosamoan ratiohawaiin ratiovietnamese ratioasianindian ratiounknowndescent avgage

* Conduct an imtest for white heteroscedasticity test
imtest, white

* Save the residuals from the regression
predict residuals, residuals

* Perform the Shapiro-Wilk test on the residuals for normality
swilk residuals

* Scatter plot to visualize the relationship between demographic variables and crime rate
scatter avgfemaleratio avgmaleration avgunknownration ratiocambodian ratiofilipino ratioguamanian ratiohispanic ratioamericanindian ratiojapanese ratiokorean ratioloation ratioother ratiosamoan ratiohawaiin ratiovietnamese ratioasianindian ratiounknowndescent avgage crimerateper100000people

* Scatter plot to visualize the relationship between crime rate and demographic variables
scatter crimerateper100000people avgfemaleratio avgmaleration avgunknownration ratiocambodian ratiofilipino ratioguamanian ratiohispanic ratioamericanindian ratiojapanese ratiokorean ratioloation ratioother ratiosamoan ratiohawaiin ratiovietnamese ratioasianindian ratiounknowndescent avgage

* Scatter plot of residuals against fitted values for checking homoscedasticity
scatter residuals crimerateper100000people , yline(0) xtitle("Fitted Values") ytitle("Residuals") title("Residual Plot")

* Normal probability plot of residuals for checking normality
pnorm residuals
qnorm residuals

* Robust regression with a 90% confidence level
reg crimerateper100000people avgfemaleratio avgmaleration avgunknownration ratiocambodian ratiofilipino ratioguamanian ratiohispanic ratioamericanindian ratiojapanese ratiokorean ratioloation ratioother ratiosamoan ratiohawaiin ratiovietnamese ratioasianindian ratiounknowndescent avgage, vce(robust) level(90)

* Robust regression with a 98% confidence level
reg crimerateper100000people avgfemaleratio avgmaleration avgunknownration ratiocambodian ratiofilipino ratioguamanian ratiohispanic ratioamericanindian ratiojapanese ratiokorean ratioloation ratioother ratiosamoan ratiohawaiin ratiovietnamese ratioasianindian ratiounknowndescent avgage, vce(robust) level(98)
