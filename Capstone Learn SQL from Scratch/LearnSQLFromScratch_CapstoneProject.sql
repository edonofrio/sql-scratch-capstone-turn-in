 -- Quiz Funnel: Question #1
 select * from survey
 limit 10;
 
 -- Quiz Funnel: Question #2
 select question, count(distinct(user_id)) as 'num_users'
 from survey
 group by question;

-- Quiz Funnel: Question #3
-- Question 5 in the Style quiz has the lowest completion rate. 
                
-- Quiz Funnel: Question #4
select * from quiz
limit 5;
select * from home_try_on
limit 5;
select * from purchase
limit 5; 

-- Quiz Funnel: Question #5       
SELECT DISTINCT q.user_id, 
h.user_id IS NOT NULL as 'is_home_try_on', h.number_of_pairs,
p.user_id IS NOT NULL as 'is_purchase'           
FROM quiz as q
LEFT JOIN home_try_on as h
	ON q.user_id=h.user_id
LEFT JOIN purchase as p
 	ON p.user_id = q.user_id
LIMIT 10;                                 

                                 -- Quiz Funnel: Question #6 -- compare conversion rates from quiz--> home_try_on and home_try_on --> purchase   
WITH funnels as (SELECT DISTINCT q.user_id, 
h.user_id IS NOT NULL as 'is_home_try_on', h.number_of_pairs,
p.user_id IS NOT NULL as 'is_purchase'           
FROM quiz as q
LEFT JOIN home_try_on as h
	ON q.user_id=h.user_id
LEFT JOIN purchase as p
 	ON p.user_id = q.user_id
LIMIT 10)
select count(*) as  'num_quiz', 
sum(is_home_try_on) as 'num_home', 
sum(is_purchase) as 'num_purchase', 
1.0 * sum(is_home_try_on)/count(*) as 'quiz_to_home',
1.0 * sum(is_purchase)/sum(is_home_try_on) as 'home_to_purhcase'
from funnels ;

-- Quiz Funnel: Question #6 -- compare conversion rates and differences in purchase rates by number of pairs   
WITH funnels as (SELECT DISTINCT q.user_id, 
h.user_id IS NOT NULL as 'is_home_try_on', h.number_of_pairs,
p.user_id IS NOT NULL as 'is_purchase'           
FROM quiz as q
LEFT JOIN home_try_on as h
	ON q.user_id=h.user_id
LEFT JOIN purchase as p
 	ON p.user_id = q.user_id
LIMIT 10)
select number_of_pairs,  
1.0 * sum(is_purchase)/sum(is_home_try_on) as 'home_to_purhcase'
from funnels group by number_of_pairs;  

--Quiz Funnel: Question #6 - Most common results of style quiz
with surveyresponse as (select question, response, count(distinct(user_id)) as 'num_response'
 from survey
 group by response order by question)
select question, response, max(num_response)from surveyresponse group by question;        
--Quiz Funnel: Question #6 - Most common products purchased
SELECT product_id, style, model_name, color, count(*) as 'num_purchased' from purchase group by product_id, style, model_name, color order by num_purchased desc;

--Quiz Funnel: Question #6 - Most common style purchased          
SELECT style, count(*) as 'num_purchased' from purchase group by style order by num_purchased desc;

                                               --Quiz Funnel: Question #6 - Most common colors purchased by men and women style           
SELECT color, count(DISTINCT CASE when style like 'Women%' THEN user_id END) as 'WomenStyles', count(DISTINCT CASE when style like 'Men%' THEN user_id END) as 'MenStyles' from purchase group by color order by womenstyles desc, menstyles desc;

--Quiz Funnel: Question #6 - Most common color       
SELECT color, count(*) as 'num_purchased' from purchase group by color order by num_purchased desc;
                                                         
--Quiz Funnel: Question #6 - Most common model     
SELECT model_name, count(*) as 'num_purchased' from purchase group by model_name order by num_purchased desc;
                                               --Quiz Funnel: Question #6 - Most common models purchased by men and women style           
SELECT model_name, count(DISTINCT CASE when style like 'Women%' THEN user_id END) as 'WomenStyles', count(DISTINCT CASE when style like 'Men%' THEN user_id END) as 'MenStyles' from purchase group by model_name order by womenstyles desc, menstyles desc;
                                     