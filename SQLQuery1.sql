Select *
from [Portfolio project].dbo.CovidDeaths
where continent is not null
order by 3,4

--Select *
--from [Portfolio project].dbo.CovidVaccinations
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
from [Portfolio project].dbo.CovidDeaths
where continent is not null
order by 1,2

--Looking at total cases vs Population
--Shows what percentage of population got covid

Select location, date, total_cases, new_cases, population, (total_deaths/population)*100 as PercentPopulationInfected
from [Portfolio project].dbo.CovidDeaths
where location like '%states%'
and continent is not null
order by 1,2

--Looking at countries with Highest Infection Rate compared to population

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from [Portfolio project].dbo.CovidDeaths
Group by location,population
order by PercentPopulationInfected desc


--LET'S BREAK DOWN BY CONTINENT

--showing countries with Hghest Death Count per Population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
from [Portfolio project].dbo.CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercenatge
from [Portfolio project].dbo.CovidDeaths
where continent is not null
--Group by date
Order by 1,2

Select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations) ) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population)*100
from [Portfolio project].dbo.CovidDeaths dea
Join [Portfolio project].dbo.CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Order by 2,3

--USE CTE

with Popvsvac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccianted)
as
(
Select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations) ) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population)*100
from [Portfolio project].dbo.CovidDeaths dea
Join [Portfolio project].dbo.CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3
)
Select *, (RollingPeopleVaccianted/Population)*100
from Popvsvac

--Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location  nvarchar(255),
Date datetime,
Population Numeric,
New_Vaccinations Numeric,
RollingPeopleVaccinated Numeric
)

Insert into  #PercentPopulationVaccinated
Select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations) ) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population)*100
from [Portfolio project].dbo.CovidDeaths dea
Join [Portfolio project].dbo.CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--Order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

--Creating view to store data for later visualizatons
USE [Portfolio project]
GO
Create View PercentPopulationVaccinated as
Select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations) ) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population)*100
from [Portfolio project].dbo.CovidDeaths dea
Join [Portfolio project].dbo.CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3

Select *
From PercentPopulationVaccinated















 
 




