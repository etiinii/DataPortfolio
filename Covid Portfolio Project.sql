Select *
From PortfolioProject..CovidDeaths
Order by 3,4



--Select *
--From CovidVaccinations
--Order by 3,4




-- Total cases vs Total death - Shows mortality rate with dates

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location = 'Nigeria'
Order by 1,2




--Shows total mortality rate per country (total people that got infected vs total people that died) 
Select location,  MAX(total_cases) as TotalCases, MAX(CONVERT(float, total_deaths)) as TotalDeaths, MAX(CONVERT(float, total_deaths))/MAX(total_cases)*100 as DPercent
From PortfolioProject..CovidDeaths 
Where continent is not null
Group by location
Order by DPercent DESC




--Shows total mortality rate per country (total people that got infected vs total people that died) Using CTE

WITH CTE_CovidDeaths as
(Select location,  MAX(total_cases) as TotalCases, MAX(CONVERT(float, total_deaths)) as TotalDeaths
From PortfolioProject..CovidDeaths Where continent is not null
Group by location)


Select location, TotalCases, TotalDeaths, (TotalDeaths/TotalCases)*100 as DeathPercentage
From CTE_CovidDeaths
Order by DeathPercentage DESC





--Shows total mortality rate per Continent (total people that got infected vs total people that died) 
Select continent,  MAX(total_cases) as TotalCases, MAX(CONVERT(float, total_deaths)) as TotalDeaths, MAX(CONVERT(float, total_deaths))/MAX(total_cases)*100 as DeathPercent
From PortfolioProject..CovidDeaths 
Where continent is not null
Group by continent
Order by DeathPercent DESC





--Shows total mortality rate per Continent (total people that got infected vs total people that died) with CTE

WITH CTE_CovidDeaths as
(Select continent,  MAX(total_cases) as TotalCases, MAX(CONVERT(float, total_deaths)) as TotalDeaths
From PortfolioProject..CovidDeaths Where continent is not null
Group by continent)


Select continent, TotalCases, TotalDeaths, (TotalDeaths/TotalCases)*100 as DeathPercentage
From CTE_CovidDeaths
Order by DeathPercentage DESC




-- Total cases vs Population - Shows percentage of population that got infected with dates

Select location, date, population, total_cases,  (total_cases/population)*100 as InfectedPopulationPercentage
From PortfolioProject..CovidDeaths
--Where location = 'Nigeria'
Order by 1,2


-- Countries with highest infection rates compared to the population

Select location, population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as InfectedPopulationPercentage
From PortfolioProject..CovidDeaths
--Where location = 'Nigeria'
Group by location, population
Order by InfectedPopulationPercentage DESC


--Showing highest death count per population (only countries)
Select location, population, MAX(CONVERT(float, total_deaths)) as Totaldeaths
From PortfolioProject..CovidDeaths
--Where location = 'Nigeria'
Where continent is not null
Group by location, population
Order by Totaldeaths DESC


--Showing highest death count per population (For Continents)
Select continent, MAX(CONVERT(float, total_deaths)) as Totaldeaths
From PortfolioProject..CovidDeaths
--Where location = 'Nigeria'
Where continent is not null
Group by continent
Order by Totaldeaths DESC



--GLOBAL NUMBERS
Select date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int)) / SUM(new_cases) *100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location = 'Nigeria'
Where continent is not null
Group by date
Order by 1,2


 -- Total population vs Vaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingVaccinated 
 From PortfolioProject..CovidVaccinations vac
 Join PortfolioProject..CovidDeaths dea on dea.location =vac.location AND dea.date = vac.date
 Where dea.continent is not null
 order by 2,3


 -- Using CTE
 With PopvsVac as
 (Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingVaccinated 
 From PortfolioProject..CovidVaccinations vac
 Join PortfolioProject..CovidDeaths dea on dea.location =vac.location AND dea.date = vac.date
 Where dea.continent is not null)

 Select continent, location, date, population, RollingVaccinated, (RollingVaccinated / population)* 100 as PercentageVaccinated
 From PopvsVac
 Order by 2,3


 -- Creating View

 Create View MortalityRatesCountry as
 Select location,  MAX(total_cases) as TotalCases, MAX(CONVERT(float, total_deaths)) as TotalDeaths, MAX(CONVERT(float, total_deaths))/MAX(total_cases)*100 as DPercent
From PortfolioProject..CovidDeaths 
Where continent is not null
Group by location
--Order by DPercent DESC

Select *
From MortalityRatesCountry
Order by 4 Desc