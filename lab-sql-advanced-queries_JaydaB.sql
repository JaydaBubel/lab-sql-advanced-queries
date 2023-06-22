use sakila;

# List each pair of actors that have worked together.
# Interpretation: use CTE then joins, list all combinatinos of actzors featured together 
with cte_acting_partners as (select a1.actor_id as actor_id1, a2.actor_id as actor_id2 from sakila.film_actor as FA1 #aliases for actor_id, since doubled 
join sakila.film_actor as FA2 on FA1.film_id = FA2.film_id
join sakila.actor as a1 on FA1.actor_id = a1.actor_id 
join sakila.actor as a2 on FA2.actor_id = a2.actor_id
where a1.actor_id < a2.actor_id #filter for uniqiue combos, where a1 less than a2
)
select distinct actor_id1, actor_id2 from cte_acting_partners
order by actor_id1, actor_id2;

# For each film, list actor that has acted in more films.
# interpretation: list film IDs and actor IDs for those actors acting also in other films from list, use joins

with actors_films as (select fa.actor_id, f.film_id, count(*) as film_count from film as f
join film_actor as fa on f.film_id = fa.film_id
group by fa.actor_id, f.film_id),
max_film_count as (select film_id, max(film_count) as max_count from actors_films
group by film_id)
select f.film_id, af.actor_id from film as f
join actors_films as af on f.film_id = af.film_id
join max_film_count as m on af.film_id = m.film_id and af.film_count = m.max_count
order by f.film_id;
