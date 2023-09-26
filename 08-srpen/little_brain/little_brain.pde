



ArrayList R,L;
int side = 3;
float offset = 10.0;
float AMP = 100.0;
ArrayList states;
int trailLen = 5000;
float ZOOM = 5.0;
float learnRate = 1200.0;
int harmonic = 8;
////

// angle correction
float correction = -180.0+360.0;
// mgnitude correction
float scalar = 150.0;

float base = 1.02;
////


void setup(){
	size(640,480,P2D);


	noiseSeed(2023);
	///////////////////////////
	R = new ArrayList();
	L = new ArrayList();
	

	
	for(int i = 0;i<side;i++){
	for(int ii = 0;ii<side;ii++){
	for(int iii = 0;iii<side;iii++){
		R.add(new Neuron(noise(i,ii,iii),noise(i+(offset),ii+(offset),iii+(offset))));
		L.add(new Neuron(noise(i+(offset*2),ii+(offset*2),iii+(offset*2)),noise(i+(offset*3),ii+(offset*3),iii+(offset*3))));
}
}		
	}

	states = new ArrayList();
}


void draw(){
	background(0);
	stroke(255);

	float X = 0;
	pushMatrix();
	translate(width/2+width/4,height/2);
	for(int i = 0 ; i< R.size();i++){
		Neuron tmp = (Neuron)R.get(i);
		Neuron pair = (Neuron)L.get(i);
		Neuron neigh = (Neuron)L.get( ((i+L.size())-1) % L.size());
		float amp = tmp.getSum() * AMP;


		tmp.harmonize();
		pair.harmonize();
		//tmp.align(pair);
		//tmp.align(neigh);
        //tmp.slowDown();

		point(i,amp);
		X+=amp;
	}
	X/=(R.size()+0.0);
	popMatrix();


	float Y = 0;
	pushMatrix();
		translate(width/2-width/4,height/2);

	for(int i = 0 ; i< L.size();i++){
		Neuron tmp = (Neuron)L.get(i);
		Neuron pair = (Neuron)R.get(i);
		Neuron neigh = (Neuron)L.get( ((i+L.size())-1) % L.size());
		float amp = tmp.getSum() * AMP;

		//tmp.harmonize();
		//tmp.align(pair);
		//tmp.align(neigh);
		//tmp.slowDown();

		point(i,amp);
		Y+=amp;
	}
	
	Y/=(L.size()+0.0);
	popMatrix();

	states.add(new PVector(Y*ZOOM,X*ZOOM));
	
	if(states.size()>trailLen)
	states.remove(0);

	noFill();
stroke(255,15);
	pushMatrix();
	translate(width/2,height/2);
	beginShape();
	for(int i = 0 ; i < states.size();i++){
		PVector tmp = (PVector)states.get(i);
		vertex(tmp.x,tmp.y);
	}
	endShape();
	popMatrix();

	if(frameCount%trailLen==0){
		background(255);
		savePoints();
	}
	
}

class Neuron{
	float mag,freq;
	Neuron(float _mag,float _freq){
		freq=_freq;
		mag=_mag;
	}

	float getSum(){
		return sin(millis()/1000.0*TAU*freq)*mag;
	}

	void slowDown(){
		mag *= 1.0;
		freq *= 0.9998;
	}

	// 1..12 is one octave, originals made here
	void harmonize(){
		freq += ((base*(2^((harmonic/12))+1)) - freq)/learnRate;
		freq += random(-100,100)/10000.0/learnRate;
	}

	void align(Neuron _n){
		mag += ((_n.mag-mag)/learnRate);
		freq += ((_n.freq-freq)/learnRate);
	}

	
	void delign(Neuron _n){
		mag -= ((_n.mag-mag)/learnRate);
		freq -= ((_n.freq-freq)/learnRate);
	}
	
}

void savePoints(){
   String output[] = new String[0];
   for(int i = 1;i<states.size();i++){
   PVector tmp1 = (PVector)states.get(i-1);
   //PVector tmp2 = (PVector)states.get(i);
   //float mag = dist(tmp1.x,(tmp1.y),tmp2.x,(tmp2.y));
   //float angle = atan2((tmp2.y)-(tmp1.y),(tmp2.x)-(tmp1.x));
   output = expand(output,output.length+1);
   output[output.length-1] = int(tmp1.x*scalar+width/2)+" "+int(tmp1.y*scalar+height/2);//int(degrees(angle)+correction)+" "+int(mag*scalar);
  }
  
  saveStrings("drawing.txt",output);
		

}

void keyPressed(){
 if(key=='s'){
 savePoints();
 }
}
