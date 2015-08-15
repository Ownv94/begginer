#Funcion filtro

function filtra(b,a,v)
  c=0;
d=0;
dk=zeros(1,length(v));
ek=zeros(1,length(v));
ck=zeros(1,length(v));
for i=1:length(v)
    c=0;
    for j=0:length(b)-1
        if(i>j)
            c=c+b[j+1]*v[i-j];
        end
    end
  ck[i]=c;
   d=0;
    for k=1:length(a)-1
        if(i>k)
            d=d+a[k+1]*ek[i-k];
        end
    end
  dk[i]=d;
    ek[i]=ck[i]-dk[i];
end
  return ek
end

#Muestreo de señales
Np=40;
dut=1/2;
fs=200;
Npuertas=500;
pulso=[ones(1,int(dut*Np)) zeros(1,int((1-dut)*Np))];
t=linspace(0,Npuertas*(1/fs),Np*Npuertas)';
pul=zeros(1,length(t));
for i=1:500
  pul[int(Np*(i-1)+1):int(Np*i)]=pulso
end
using Winston
plot(pulso)
plot(t,pul)
Fs1=1/(t[2]-t[1])
t[2]
x=sin(2*pi*40*t);
sq=x.*pul;
pul
fe=linspace(-Fs1/2,Fs1/2-Fs1/length(t),length(t));
using DSP
response=Lowpass(1000,fs=Fs1);
designmet=Butterworth(20);
fi=convert(PolynomialRatio,digitalfilter(response,designmet))
b=coefb(fi);
a=coefa(fi);
eka=filtra(b,a,pul)
filtrada=fft(eka)/length(t);
FILTRADA=fftshift(filtrada);
fes=linspace(-Fs1/2,Fs1/2,length(filtrada));
xs=fft(pul)/length(t);
Xs=fftshift(xs);
ys=fft(sq)/length(sq);
Ys=fftshift(ys);
stem(fe,abs(Xs))
plot(fe,abs(Xs),"r",fe,abs(Ys),"b")
 p = FramedPlot(
          title="Grafica de frecuencias",
         xrange=(-3000,3000),
         xlabel="Frecuency",
         yrange=(0,0.7),
         ylabel="Magnitud")
add(p,Curve(fe,abs(Xs),color="red"))
add(p,Curve(fe,abs(Ys),color="blue"))
add(p,Curve(fes,abs(FILTRADA),color="yellow"))
