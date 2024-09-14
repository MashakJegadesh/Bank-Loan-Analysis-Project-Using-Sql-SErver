selecT * from [dbo].[financial_loan]

---Total loan application--

select count(id) as Total_loan_applications  from [dbo].[financial_loan]

---Mtd total loan application

select  count(id) as MTb_Total_loan_applications from [dbo].[financial_loan]
where month(issue_date)=12 and year(issue_date)=2021

---Pmtd Total loan application
select count(id) as PMTb_Total_loan_applications from [dbo].[financial_loan]
where month(issue_date)=11 and year(issue_date)=2021

---MOM Change percentage--
with cte_1 as
(select  count(id) as MTb_Total_loan_applications from [dbo].[financial_loan]
where month(issue_date)=12 and year(issue_date)=2021),
cte_2 as
(select count(id) as PMTb_Total_loan_applications from [dbo].[financial_loan]
where month(issue_date)=11 and year(issue_date)=2021)

select MTb_Total_loan_applications,PMTb_Total_loan_applications,(MTb_Total_loan_applications-PMTb_Total_loan_applications)*100.0/nullif(PMTb_Total_loan_applications,0)
from cte_1 ,cte_2

select * from [dbo].[financial_loan]
---total loan amonut--
select sum(loan_amount) as Total_loan_amount from [dbo].[financial_loan]

--mtd_loan_amount--
select sum(loan_amount) as mtd_loan_amt from [dbo].[financial_loan]
where month(issue_date)=12 and year(issue_date)=2021

---pmtd_loan_amomut---

select sum(loan_amount) as pmtd_loan_amt from [dbo].[financial_loan]
where month(issue_date)=11 and year(issue_date)=2021

with cte_1 as(
select sum(loan_amount) as mtd_loan_amt from [dbo].[financial_loan]
where month(issue_date)=12 and year(issue_date)=2021
),
cte_2 as(
select sum(loan_amount) as pmtd_loan_amt from [dbo].[financial_loan]
where month(issue_date)=11 and year(issue_date)=2021
)
select mtd_loan_amt,pmtd_loan_amt,(mtd_loan_amt-pmtd_loan_amt)*100.0/nullif(pmtd_loan_amt,0) from 
cte_1 , cte_2

---Total amount received---
select * from [dbo].[financial_loan]

select sum(total_payment) as Total_amount_received from [dbo].[financial_loan]
---MOM DIFFRENCE--
SELECT 
    MONTH(issue_date) AS month_of_issue,
    ROUND(SUM(total_payment), 0) AS Total_amount_received,
    CASE 
        WHEN LAG(SUM(total_payment), 1) OVER (ORDER BY MONTH(issue_date)) IS NULL THEN NULL
        ELSE ROUND(
            (SUM(total_payment) - LAG(SUM(total_payment), 1) 
                OVER (ORDER BY MONTH(issue_date))) * 100.0 / 
            LAG(SUM(total_payment), 1) OVER (ORDER BY MONTH(issue_date)), 
            2
        )
    END AS mom_percentage
FROM 
    [dbo].[financial_loan]
WHERE 
    MONTH(issue_date) IN (11, 12) 
    AND YEAR(issue_date) = 2021
GROUP BY 
    MONTH(issue_date)
ORDER BY 
    MONTH(issue_date);

---mtd_avg--intreset---

select * from [dbo].[financial_loan]

select round(avg(int_rate) *100 ,2)  as Mtd_avg_intrset from [dbo].[financial_loan] 
where month(issue_date)=12 and year(issue_date)=2021

--bti---mtd----
select round(avg(dti),4) *100 as mtd_dti from [dbo].[financial_loan] 
where month(issue_date)=12 and year(issue_date)=2021
--dtipmtd---
select round(avg(dti),4) *100 as pmtd_dti from [dbo].[financial_loan] 
where month(issue_date)=11 and year(issue_date)=2021

----MOM diffrence for dti------
with cte_1 as
(select round(avg(dti),4) *100 as mtd_dti from [dbo].[financial_loan] 
where month(issue_date)=12 and year(issue_date)=2021),
cte_2 as
(select round(avg(dti),4) *100 as pmtd_dti from [dbo].[financial_loan] 
where month(issue_date)=11 and year(issue_date)=2021
)
select mtd_dti,pmtd_dti,(mtd_dti-pmtd_dti)/pmtd_dti *100 as mom_percentage diff from 
cte_1,cte_2

select * from [dbo].[financial_loan]
----loan Status---
---good loan percentage--
select
      (count(case when loan_status='Fully Paid' or loan_status = 'Current' then id end)*100)
	  /count(id) as good_loan_percentage
	  from [dbo].[financial_loan]

----good loan appliactions

select count(id) from [dbo].[financial_loan] as Good_loan_applications
where loan_status='Fully Paid' or loan_status = 'Current'

--goog loan funded- amount---

select sum(loan_amount) as good_loan_funded_amoun from  [dbo].[financial_loan]
where loan_status='Fully Paid' or loan_status = 'Current'

----good loan total receive amount--
select sum(total_payment) as good_loan_funded_amoun from  [dbo].[financial_loan]
where loan_status='Fully Paid' or loan_status = 'Current'

---Bad Loan Percentage---
select 
(count(case when loan_status='Charged Off' then id end)*100.0)/count(id) as bad_loan_percente
from  [dbo].[financial_loan]

---totl application bad loan---
select count(id) from  [dbo].[financial_loan] as Bad_loan_applications where loan_status='Charged Off'

---bad loan funded amount--
select sum(total_payment) as bad_loan_funded from   [dbo].[financial_loan]
where loan_status='Charged Off'

select * from [dbo].[financial_loan]

---overall bakprofir based on loan_status---
select loan_status ,
count(id) as toatl_applications ,
sum(total_payment) as total_amount_recevied,
sum(loan_amount) as total_amount_funded,
avg(dti) as DTi,
avg(int_rate) as intreset_rate
from [dbo].[financial_loan]
group by  loan_status 

---monthy tends--
select * from [dbo].[financial_loan]

Select 
datename(month,issue_date) as Month_name ,month(issue_date) as month_number,
count(id) as total_loan_applications,
sum(total_payment) as total_amount_received,
sum(loan_amount) as totat_amount_funded
from  [dbo].[financial_loan]
group by datename(month,issue_date),month(issue_date)
order by month(issue_date)

---Regional loan details--
select address_state,
count(id) as total_loan_applications,
sum(total_payment) as total_amount_received,
sum(loan_amount) as totat_amount_funded
from  [dbo].[financial_loan]
group by address_state
order by sum(total_payment) desc

---analysis by term 

select term,
count(id) as total_loan_applications,
sum(total_payment) as total_amount_received,
sum(loan_amount) as totat_amount_funded
from  [dbo].[financial_loan]
group by term
order by sum(total_payment) desc

---Analysis by employee length---
select emp_length,
count(id) as total_loan_applications,
sum(total_payment) as total_amount_received,
sum(loan_amount) as totat_amount_funded
from  [dbo].[financial_loan]
group by emp_length
order by sum(total_payment) desc

---analysis by purpose---
select purpose,
count(id) as total_loan_applications,
sum(total_payment) as total_amount_received,
sum(loan_amount) as totat_amount_funded
from  [dbo].[financial_loan]
group by purpose
order by sum(total_payment) desc

select * from [dbo].[financial_loan]

---analysis by home ownershp---

select home_ownership,
count(id) as total_loan_applications,
sum(total_payment) as total_amount_received,
sum(loan_amount) as totat_amount_funded
from  [dbo].[financial_loan]
group by home_ownership
order by sum(total_payment) desc

---grid overview
select home_ownership,
count(id) as total_loan_applications,
sum(total_payment) as total_amount_received,
sum(loan_amount) as totat_amount_funded
from  [dbo].[financial_loan]
where grade='A' and address_state='CA'
group by home_ownership
order by sum(total_payment) desc

