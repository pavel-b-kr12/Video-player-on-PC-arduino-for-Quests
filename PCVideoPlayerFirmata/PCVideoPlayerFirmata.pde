 //TODO del unused, debug, ind



boolean bPlayVideoOnlyOnce=true;

int[] played={ 0, 0, 0, 1, 1, 1, 1, 1 };  //set 1 to skip video, e.g. if file missing

import processing.video.*;
import cc.arduino.*;

import processing.serial.*;
Arduino arduino;

Movie vNow;

boolean bDrawcontrol=false; //debug inf
//boolean bTestMode=true;
PFont fontInf;


String lang="e"; //settings from file
int E=2;
String[] fileStr;


void setup() {
	size(800, 600); // must be the first line
	//size(1200, 800);
	//fullScreen();
	//frameRate(60);

	
	fileStr= loadStrings(dataPath("PCVideoPlayerFirmata.txt"));
	if(fileStr!=null )
	{
		lang=fileStr[0];
		E=parseInt(fileStr[1]);
	}


	fontInf = createFont("mono", 46);

	

	if(MCU_connect())	
	{
		for(byte i=0;i<8;i++)
		{
			arduino.pinMode(i+14,Arduino.INPUT_PULLUP);delay(10);
			arduino.pinMode(i+2,Arduino.INPUT_PULLUP);delay(10);
		}
		delay(1000);
	}
}



void langSet(String s)
{
	if(lang==s)return;
	lang=s;
	ChangeSettingsV();
}
void ESet(int e)
{
	if(E==e) return;
	E=e;
	ChangeSettingsV();
}

void ChangeSettingsV()
{
	fileStr[0]=lang;
	fileStr[1]=str(E);
	saveStrings(dataPath("PCVideoPlayerFirmata.txt"), fileStr);
}


void afterEndVideo()
{
	MCU_set_p2(currentTaskN);
	currentTaskN=-1;
}


int currentTaskN=-1;
void RunTask(int n)
{															print("RunTask ");println(n);
	if(bPlayVideoOnlyOnce)
	{
		if(played[n]!=0) 
		{		
			println(" played before");	
			return;
		}
	}	else
	if(currentTaskN==n) 
	{		
		println(" played now");	
		return;
	}
	
	

	print("video now= ");println(vNow);
	if(currentTaskN!=-1) afterEndVideo(); //end old task
	played[n]=1;
	currentTaskN=n;
	
	if(vNow!=null)    vNow.stop();
	try {
		vNow=new Movie(this, dataPath(lang+str(n)+".avi")); //!! if file exist
		print("video now= ");println(vNow);
		//if(v!=null) 
		vNow.play();
	} 
	catch (Exception e)
	{
		print("can't load ");println(dataPath(lang+str(n)+".avi"));
		MCU_set_p2(n);
	} 


}

boolean MCU_connect()
{	
	//TODO  check port
	try
	{															
		if(arduino==null)  arduino = new Arduino(this, Arduino.list()[0], 57600);
		print("MCU_connect now");println(arduino);
		if(arduino!=null)	return true;		
	}
	catch (Exception e) //FileNotFoundException
	{
		println("can't connect MCU ");
		return false;
	}
	return false;
}

void MCU_set_p2(int p)
{
	// try
	// {
	
	p+=2;//start at D2 pin	

	if(!MCU_connect()) return;
	
	arduino.pinMode(p,Arduino.OUTPUT);
	arduino.digitalWrite(p,Arduino.LOW);
	delay(200);

	// }
	// catch (Exception e)
	// {
	// println("can't set MCU ");
	// }
}

void MCU_get()
{
	// try
	// {
	
	if(!MCU_connect()) return;

	for (int i = 0; i <8; i++)
	{
		if(bPlayVideoOnlyOnce && played[i]==1) continue;
		
		int a=arduino.digitalRead(14+i);									print(i);print(" dain = ");println(a);

		if(a==Arduino.LOW) 
		{
			RunTask(i);
			return;
		}
	}
	
	// }
	// catch (Exception e) //FileNotFoundException
	// {
	// println("can't get MCU ");
	// }
}

void movieEvent(Movie m)
{
	vNow.read();
}

void draw() {
	if(vNow!=null)
	{
		image(vNow, 0, 0, width, height); //play video
		if( (vNow.duration()- vNow.time())<0.1)  //video end //!opt profile
		{
			vNow=null;
			afterEndVideo();
		}
		return;
	}
	
	background(0);

	if (bDrawcontrol) 
	{
		textSize(33);
		fill(222,122, 77);
		textFont(fontInf);
		text(lang, 10, 500);       text("video file prefix: q w e r ...", 150, 500);
		text(E, 10, 550);          text("some custom settings: a s d f ...", 150, 550);
		text((int)key, 10, 600);   text("button press", 150, 600);
		text("F1 toggle this debug inf", 150, 650);
	}

	MCU_get();
}

void keyPressed()
{										print(key);
	switch(key)
	{
		case('q'): langSet("q"); break;
		case('w'): langSet("w"); break;
		case('e'): langSet("e"); break;
		case('r'): langSet("r"); break;
		case('t'): langSet("t"); break;
		case('y'): langSet("y"); break;
		case('u'): langSet("u"); break;
		case('i'): langSet("i"); break;
		case('o'): langSet("o"); break;
		case('p'): langSet("p"); break;

		case('a'): ESet(0); break;
		case('s'): ESet(1); break;
		case('d'): ESet(2); break;
		case('f'): ESet(3); break;
		case('g'): ESet(4); break;
		case('h'): ESet(5); break;
		case('j'): ESet(6); break;
		case('k'): ESet(7); break;
		case('l'): ESet(8); break;

		case '1': RunTask(0);  break;
		case '2': RunTask(1);  break;
		case '3': RunTask(2);  break;
		case '4': RunTask(3);  break;
		case '5': RunTask(4);  break;
		case '6': RunTask(5);  break;
		case '7': RunTask(6);  break;
		case '8': RunTask(7);  break;

		//case 'f': fullScreen();  break; //TODO2 implement
		// case 'w': size(800, 600);  break;
	}

	if (keyCode ==112) //F1
	{
		bDrawcontrol=!bDrawcontrol;
	}
	// if (keyCode ==113)
	// {
	// bTestMode=!bTestMode;
	// }
}
