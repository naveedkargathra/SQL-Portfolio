--SELECT *
--From portfolio_project..Covid_Deaths
where continent is not null
--Order by 3

--select * 
--from portfolio_project..Covid_Vaccinations
--order by 3,4


Select location, date, total_cases, new_cases, total_deaths, population
from portfolio_project..Covid_Deaths
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of deaths in India
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
from portfolio_project..Covid_Deaths
where location like '%India%'
order by 1,2

-- Total Cases vs Population
Select location, date, total_cases, population, (total_cases/population)*100 as Covid_Percentage
from portfolio_project..Covid_Deaths
where location like '%India%'
order by 1,2

-- Highest Infection Rates
Select location, max(total_cases) as highest_infection_count, population, max(total_cases/population)*100 as Max_Infection_Rate
from portfolio_project..Covid_Deaths
group by location, population
order by Max_Infection_Rate desc

-- Countries with highest death count per population
select location, max(cast(total_deaths as int)) as Total_Death_Count
from portfolio_project..Covid_Deaths
where continent is not null
group by location
order by Total_Death_Count desc

-- Highest Deaths by continent
select continent, MAX(cast(total_deaths as int)) as Total_Death_Count
from portfolio_project..Covid_Deaths
where continent is not null
group by continent
order by Total_Death_Count desc

-- Global Numbers

select  date, SUM(new_cases) as Cases, SUM(cast(new_deaths as int)) as Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from portfolio_project..Covid_Deaths
where continent is not null
group by date
order by 1,2


--Looking at total Population vs vaccination
With PopvsVax (continent, location, date, population, people_vaccinated, new_vaccinations)
as
(
Select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(cast(v.new_vaccinations as int)) OVER (Partition by d.location order by d.location, d.date) as People_Vaccinated
from portfolio_project..Covid_Deaths d
Join portfolio_project..Covid_Vaccinations v
On d.location = v.location
and d.date = v.date
where d.continent is not null
--order by 2,3
)
Select *, (people_vaccinated/population)*100
from PopvsVax


-- TEMP Table
Drop table #Percentpopulationvaccinated
Create Table #Percentpopulationvaccinated
(
continent nvarchar(255),
location  nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
People_Vaccinated numeric
)


Insert into #Percentpopulationvaccinated
Select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(cast(v.new_vaccinations as int)) OVER (Partition by d.location order by d.location, d.date) as People_Vaccinated
from portfolio_project..Covid_Deaths d
Join portfolio_project..Covid_Vaccinations v
On d.location = v.location
and d.date = v.date
--where d.continent is not null
--order by 2,3

Select *, (People_Vaccinated/population)*100
from #Percentpopulationvaccinated

--- create view to store data for later visualizations

CREATE VIEW Percentpopulationvaccinated as
Select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(cast(v.new_vaccinations as int)) OVER (Partition by d.location order by d.location, d.date) as People_Vaccinated
from portfolio_project..Covid_Deaths d
Join portfolio_project..Covid_Vaccinations v
On d.location = v.location
and d.date = v.date
where d.continent is not null
--order by 2,3

select * 
from Percentpopulationvaccinated
























































