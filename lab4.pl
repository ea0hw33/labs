%bank(name, approved_occupations, impact_of_occupation, borrower_reliability, impact_of_reliability, approved_citizenships, impact_of_citizenships).
%tariff(name, interest_rate, available_terms, available_production_years, down_payment_pct, min_loan_amount, max_loan_amount).

bank(sberbank, [businessman, driver, programmer, manager, military], 0.6, 0.85, 0.9, [russian], 0.8).
bank(vtb, [driver, programmer, manager], 0.7, 0.75, 0.85, [russian, european], 0.75).
bank(gazprombank, [programmer, manager], 0.8, 0.65, 0.88, [russian], 0.82).
bank(alfa_bank, [businessman, programmer, manager], 0.65, 0.9, 0.92, [russian, european, cIS_countries], 0.95).
bank(tinkoff_bank, [businessman, driver, programmer], 0.5, 0.7, 0.91, [russian, cIS_countries], 0.88).
bank(raiffeisen_bank, [businessman, programmer], 0.75, 0.8, 0.84, [european], 0.81).
bank(rosselkhozbank, [driver, programmer, manager, military], 0.55, 0.75, 0.86, [russian], 0.79).
bank(uralsib, [businessman, driver, programmer, manager], 0.65, 0.8, 0.87, [russian], 0.2).
bank(unicredit_bank, [businessman, programmer, manager], 0.5, 0.85, 0.89, [russian, european], 0.1).
bank(pochta_bank, [driver, programmer, manager, military], 0.45, 0.7, 0.83, [russian, dIS_countries], 0.76).

tariff(base_auto_loan, 0.1, [12, 24, 36, 48, 60, 72, 84, 96], [2018, 2019, 2020, 2021, 2022, 2023, 2024], 0.2, 100000, 2000000).
tariff(special_auto_loan, 0.095, [12, 24, 36, 48, 60, 72], [2019, 2020, 2021, 2022, 2023, 2024], 0.25, 150000, 2500000).
tariff(platinum_auto_loan, 0.09, [12, 24, 36, 48, 60], [2020, 2021, 2022, 2023, 2024], 0.3, 200000, 3000000).
tariff(gold_auto_loan, 0.085, [12, 24, 36, 48], [2021, 2022, 2023, 2024], 0.35, 250000, 3500000).
tariff(premium_auto_loan, 0.08, [12, 24, 36], [2022, 2023, 2024], 0.4, 300000, 4000000).
tariff(ultimate_auto_loan, 0.075, [12, 24], [2023, 2024], 0.45, 350000, 4500000).
tariff(elite_auto_loan, 0.07, [12], [2024], 0.5, 400000, 5000000).
tariff(standard_auto_loan, 0.11, [12, 24, 36, 48, 60, 72, 84, 96, 108], [2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024], 0.15, 50000, 1000000).
tariff(flexible_auto_loan, 0.105, [12, 24, 36, 48, 60, 72, 84, 96], [2018, 2019, 2020, 2021, 2022, 2023, 2024], 0.18, 75000, 1500000).
tariff(advanced_auto_loan, 0.1, [12, 24, 36, 48, 60, 72, 84], [2019, 2020, 2021, 2022, 2023, 2024], 0.22, 100000, 2000000).
tariff(economic_auto_loan, 0.095, [12, 24, 36, 48, 60, 72], [2020, 2021, 2022, 2023, 2024], 0.25, 125000, 2500000).
tariff(professional_auto_loan, 0.09, [12, 24, 36, 48, 60], [2021, 2022, 2023, 2024], 0.28, 150000, 3000000).

main(SortedTariffs):- 
	write('How much do you need to borrow?(from 50.000 to 5.000.000)'), nl,
	read(Amount),
	write('What year car do you want to buy(from 2017 to 2024)?'), nl,
	read(Year),
	write('What is the desired loan term (12, 24, 36, 48, 60, 72, 84, 96, 108)?'), nl,
	read(Term),
	write('What country are you a citizen of (russian, european, cIS_countries)?'), nl,
	read(Citizen),
	write('What is your reliability as a borrower (between 0 and 1):'), nl, 
	write('0.3<unemployed, 0.5<have a family and unemployed, 0.7<have a family and job'), nl, 
	write('0.9<have job and good credit history, 1<have job and family and good credit history)?'), nl,
	read(Borrower_reliability),
	write('what is your profession (businessman, driver, programmer, manager, military)?'), nl,
	read(Profession),
	findall(tariff(BankName, TariffName, InterestRate, AvailableTerms, 
	DownPaymentPct, MinLoanAmount, MaxLoanAmount, TotalCost, Probability),
	find_tariffs(_, _, Profession, Borrower_reliability, Citizen, Amount, 
	Term, BankName, TariffName, InterestRate, AvailableTerms, _, _, _, TotalCost, Probability),
	Tariffs),
	beautify_output(Tariffs), nl,
	write('After sorting'), nl, nl,
	sort_tariffs(Tariffs, SortedTariffs),
	beautify_output(SortedTariffs).
	
	
	
probability_of_approval(X, Y, Z, Probability) :-
	Probability is (X+Y+Z)/3.
	
	
find_tariffs(MinLoanAmount, MaxLoanAmount, BorrowerOccupation, BorrowerReliability, 
BorrowerCitizenship, Amounts, Terms, BankName, TariffName, InterestRate, AvailableTerms, DownPaymentPct, 
MinLoanAmount, MaxLoanAmount, TotalCost, Probability) :-
    tariff(TariffName, InterestRate, AvailableTerms, AvailableProductionYears, 
	DownPaymentPct, MinLoanAmount, MaxLoanAmount),
    bank(BankName, ApprovedOccupations, ImpactOfOccupation, MinBorrowerReliability, 
	ImpactOfReliability, ApprovedCitizenships, ImpactOfCitizenships),
	member(Terms, AvailableTerms),
	MinLoanAmount =< Amounts,
	Amounts =< MaxLoanAmount,
    (member(BorrowerOccupation, ApprovedOccupations) -> X = 1; X = ImpactOfOccupation),
    (BorrowerReliability >= MinBorrowerReliability -> Y = 1; Y = BorrowerReliability * ImpactOfReliability),
    (member(BorrowerCitizenship, ApprovedCitizenships) -> Z = 1; Z = ImpactOfCitizenships),
    probability_of_approval(X, Y, Z, Probability),
    TotalCost is Amounts * InterestRate * (Terms/12) + Amounts.
	

sort_tariffs(Tariffs, SortedTariffs) :-
    predsort(compare_tariffs, Tariffs, SortedTariffs).
	


compare_tariffs(X, tariff(_, _, _, _, _, _, _, TotalCost1, Probability1), 
         tariff(_, _, _, _, _, _, _, TotalCost2, Probability2)) :- 
	
	  (TotalCost1 < TotalCost2, Probability1 > Probability2) -> X = '<';
	    (TotalCost1 > TotalCost2, Probability1 < Probability2) -> X = '>';
	      X = '='.

compare_tariffs(X, tariff(_, _, _, _, _, _, _, TotalCost1, Probability1), tariff(_, _, _, _, _, _, _, TotalCost2, Probability2)) :-
	compare(X, (TotalCost1, Probability1), (TotalCost2, Probability2)).


top_tariffs(N, SortedTariffs, TopTariffs) :-
    length(SortedTariffs, Len),
    (N >= Len -> TopTariffs = SortedTariffs;
    length(TopTariffs, N),
    append(TopTariffs, _, SortedTariffs)).


beautify_output([]).
	
beautify_output([tariff(BankName, TariffName, InterestRate, AvailableTerms, 
	DownPaymentPct, MinLoanAmount, MaxLoanAmount, TotalCost, Probability) |T]) :-
	nl, format('In bank ~a with tariff: ~a',[BankName,TariffName]), nl,
	P is Probability*100,
	I is InterestRate*100,
	format('with interest rate: ~2f',[I]),write('%'), nl,
	format('probability of approval: ~2f',[P]),write('%'), nl,
	format('with the total amount: ~2f',[TotalCost]), nl,
	write('-----------------------------------------'), nl,
	beautify_output(T).
	
