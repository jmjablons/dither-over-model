cppFunction('double modelC(double par1, double par2, NumericVector reward, NumericVector side){
double q[2];
            q[0] = q[1] = 0;
            double p[2];
            p[0] = p[1] = 0;
            double nll = 0;
            int n = side.size();
            for(int i = 0; i < n; i++){
            int s = side[i];
            p[s] = (exp(par2 * q[s])) / (exp(par2 * q[1]) + exp(par2 * q[2]));
            nll = -log(p[s]) + nll; 
            double pe = reward[i] - q[s];
            q[s] = q[s] + (par1 * pe);
            }
            return nll;
            }')

modelC(.1, 1, reward, side)