using DifferentialEquations

function f(du,u,p,t)
  du[1]=u[2]
  du[2]=-9.81
end

function condition(u,t,integrator) # Event when event_f(u,t) == 0
  u[1]
end

# add lambda as reset condition
function affect!(integrator)
  integrator.u[2] = -0.9*integrator.u[2]
end
cb = ContinuousCallback(condition,affect!)
u0 = [10.0,0.0]
tspan = (0.0,10.0)

prob = ODEProblem(f,u0,tspan)
sol = solve(prob,Tsit5(),callback=cb)
println(sol)
using Plots
u1 = [10.2,0.0]
plot(sol,vars=(1,2),xlabel="Height",ylabel="Velocity",legend=false,linecolor="blue")

for q = 10:0.001:10.5
  u2=[q,0]
  println(u2)
  prob3=ODEProblem(f,u2,tspan)
  sol3 = solve(prob3,Tsit5(),callback=cb)
  plot!(sol3,vars=(1,2),linecolor="lightblue")
  println(sol3)
end
savefig( "figure6")
