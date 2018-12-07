using OrdinaryDiffEq, Plots

#Constants and setup
const m1, m2, L1, L2 = 1, 2, 1, 1
const g=9.81
initial = [0, π/2, 0, pi/1.6]
tspan = (0.,5.)

# Transform from polar to Cartesian coordinates
function polar2cart(sol;dt=0.02,l1=L1,l2=L1,vars=(2,4))
    u = sol.t[1]:dt:sol.t[end]
    p1 = l1*map(x->x[vars[1]], sol.(u))
    p2 = l2*map(y->y[vars[2]], sol.(u))
    x1 = l1*sin.(p1)
    y1 = l1*-cos.(p1)
    (u, ( l2*sin.(p2),-l2*cos.(p2)))
end
function polar2cart2(sol;dt=0.02,l1=L1,l2=L2,vars=(2,4))
    u = sol.t[1]:dt:sol.t[end]
    p1 = l1*map(x->x[vars[1]], sol.(u))
    p2 = l2*map(y->y[vars[2]], sol.(u))
    x1 = l1*sin.(p1)
    y1 = l1*-cos.(p1)
    (u, (x1 + l2*sin.(p2),y1 - l2*cos.(p2)))

end
# Define the Problem
function double_pendulum(du,u,p,t)
    c = cos(u[1]-u[3]);
    s = sin(u[1]-u[3]);
    du[1] = u[2];
    du[2] = ( m2*g*sin(u[3])*c - m2*s*(L1*c*u[2]^2 + L2*u[4]^2) - (m1+m2)*g*sin(u[1]) ) /( L1 *(m1+m2*s^2) );
    du[3] = u[4];
    du[4] = ((m1+m2)*(L1*u[2]^2*s - g*sin(u[3]) + g*sin(u[1])*c) + m2*L2*u[4]^2*s*c) / (L2 * (m1 + m2*s^2));

end

double_pendulum_problem = ODEProblem(double_pendulum, initial, tspan)
sol = solve(double_pendulum_problem, Tsit5(), abs_tol=1e-10, dt=0.05);

#Obtain coordinates in Cartesian Geometry
ts, ps = polar2cart(sol, l1=L1, l2=L2, dt=0.01)
ts2, ps2 = polar2cart2(sol, l1=L1, l2=L2, dt=0.01)
plot(ps...,label="joint 1",title="Pendulum trajectory in Cartesian coordinates")
plot!(ps2...,label="joint 2")
#savefig( "figure1")

plot(sol,vars=[1,2,3,4])
#savefig( "figure2")
