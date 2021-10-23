#using BitstringEvolution

#This is an algorithm to spread an organism from an original location in a spatial grid to the whole thing
#=
There might be perhaps an interesting program that could be made by having organisms have two life phases:
during the juvenile phase, they float toward the top of the tank; during the adult phase, they sink to the bottom.
If organisms collect in the same cells at the bottom, then they'll start to die from overcrowding and consumption of
resources. The length of time spent as a juvenile is directly tied to the genotype. (Or genotype of parents, if you
wanna do something very maternal effecty). Then, I guess the question becomes, what set of parameters allow for a sustainable
population? What parameters lead to extinction?
=#



#Add phylogeny?
#Multiple orgs per cell?

gridSize = (9,9)
endTime = 3

mutable struct organism
    genotype
    position
end

function produceOffspring(org::organism)
    offSpring = organism(org.genotype,(rand(1:gridSize[1]), rand(1:gridSize[2])))
    
    return offSpring
end

function printGrid(population::Array)
    grid = zeros(gridSize)
    for org::organism in population
        grid[org.position[1],org.position[2]] = 1
    end
    for k=1:gridSize[1]
        println(grid[k,:])
    end
end

population = [organism([0,1],(2,2))]
printGrid(population)
for t=1:endTime
    println("== Time Step $t ==")
    append!(population, [produceOffspring(org) for org in population])
    printGrid(population)
end