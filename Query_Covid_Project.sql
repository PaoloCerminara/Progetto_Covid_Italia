Use Covid_Project;
Select * from Morti_Covid


--1. Select per avere i dati maggiormente utilizzati ordinati per location

Select location, date, totalcase, newcases, totaldeaths, population
from Morti_Covid
order by location, date asc

--2. select per avere i decessi totali rispetto ai casi totali
Use Covid_Project;
Select location, date, totalcase, totaldeaths,
round(totaldeaths/nullif(totalcase, 0),4,2)*100 as Morti_su_casi
from Morti_Covid
order by location

--3. select per avere i decessi totali rispetto ai casi totali in Italia
Use Covid_Project;
Select location, date, totalcase, totaldeaths,
round(totaldeaths/nullif(totalcase, 0),4,2)*100 as Morti_su_Casi
from Morti_Covid
where location ='Italy'
-- where location like '%italy%'

--4. i casi totali rispetto alla popolazione in Italia

Select location, date, totalcase, population, (totalcase/population)*100 as Percentuale_Infettiva
from Morti_Covid
where location = 'italy'
-- where location like '%italy%'

--5. i casi totali rispetto alla popolazione in USA
Select location, date, totalcase, population, (totalcase/population)*100 as Percentuale_Infettiva
from Morti_Covid
where location like '%states%' 

--6. paesi con il più alto tasso di infettività rispetto alla popolazione

Select  location,
		population,
		MAX(totalcase) as Massimo_Infetti, 
		MAX(totalcase/nullif(population,0))*100 as Percentuale_pop_infetta
from Morti_Covid
group by location, population
order by 4 desc

--7. i 10 paesi con il più alto tasso di infettività rispetto alla popolazione

Select  location,
		population,
		MAX(totalcase) as Massimo_Infetti, 
		MAX(totalcase/nullif(population,0))*100 as Percentuale_pop_infetta
from Morti_Covid
group by location, population
order by 4 desc
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY

--8. paesi con il più alto numero di morti 

Select  location, 
		population, 
		MAX(cast(totaldeaths as int)) as Massimo_Morti
from Morti_Covid
group by location, population
order by 3 desc

--9. totale morti per giorno nel mondo

Select  date, 
		sum(cast(totaldeaths as int))as morti_per_giorno
from Morti_Covid
group by date
order by date asc

--10. totale morti per giorno in Italia

Select  date, 
		sum(cast(totaldeaths as int))as morti_per_giorno
from Morti_Covid
where location = 'Italy'
group by date
order by date asc

--11. dati raggruppati per data in Italia

Select  date, 
		sum(newcases) as nuovi_casi,
		sum(cast(newdeaths as int)) as Nuove_Morti,
		isnull(sum(cast(newdeaths as int))/nullif(sum(newcases),0),0)*100 as percentuale_morti_su_casi
from Morti_Covid
where location = 'Italy'
group by date
order by date asc

--12. dati totali in Italia
Select      population,
			sum(newcases) as casi_totali,
			 sum(cast(newdeaths as int)) as morti_totali,
			 sum(newcases)/Population*100 as percentuale_casi_su_popolazione,
			 sum(cast(newdeaths as int))/population*100 as morti_su_popolazione,
			 sum(cast(newdeaths as int))/nullif(sum(newcases),0)*100 as percentuale_mortalità
from Morti_Covid
where location = 'Italy'
group by Population

--13. dati totali nel per stato
Select      location,
			population,
			sum(newcases) as casi_totali,
			 sum(cast(newdeaths as int)) as morti_totali,
			 nullif(sum(newcases),0)/Population*100 as percentuale_casi_su_popolazione,
			 nullif(sum(cast(newdeaths as int)),0)/population*100 as morti_su_popolazione,
			nullif(sum(cast(newdeaths as int)),0)/nullif(sum(newcases),0)*100 as percentuale_mortalità
from Morti_Covid
group by location,Population
order by 1

--14. dati mondiali

Select      sum(distinct population) as popolazione_mondiale,
			sum(NewCases) as 'casi totali nel mondo',
			sum(cast(newdeaths as int)) as 'morti totali nel mondo',
			nullif(sum(newcases),0)/sum(distinct population)*100 as percentuale_casi_su_popolazione,
			nullif(sum(cast(newdeaths as int)),0)/sum(distinct population)*100 as morti_su_popolazione,
			nullif(sum(cast(newdeaths as int)),0)/nullif(sum(newcases),0)*100 as percentuale_mortalità
from Morti_Covid

--15 Join con la tabella delle vaccinazioni

Select *
from Morti_Covid Mor
Join Vaccinazioni_Covid Vac
on (Mor.date= Vac.date) and (Mor.location=Vac.location)
order by Mor.location asc

--16. popolazione totale rispetto alle vaccinazioni
Select mor.location, mor.date, mor.population, vac.new_vaccinations, vac.total_vaccinations
from Morti_Covid Mor
Join Vaccinazioni_Covid Vac
on (Mor.date= Vac.date) and (Mor.location=Vac.location)
order by Mor.location asc

--17. percentuale vaccinati su popolazione data per data
Select mor.location, 
	   mor.date, 
	   mor.population as Popolazione_Italiana,
	  convert(float, vac.people_vaccinated)/population*100 as percentuale_vaccinati_Italia
from Morti_Covid Mor
Join Vaccinazioni_Covid Vac
on (Mor.date= Vac.date) and (Mor.location=Vac.location)
where  mor.location = 'Italy'
-- order by Mor.location asc