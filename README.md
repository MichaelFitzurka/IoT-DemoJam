# IoT-DemoJam
Internet of Things DemoJam

---
Based on the projects from [Patrick Steiner](https://github.com/PatrickSteiner) forked in my repositories here;  
- [IoT_Demo_AllInOne](https://github.com/MichaelFitzurka/IoT_Demo_AllInOne)  
- [IoT_Demo_Sensors](https://github.com/MichaelFitzurka/IoT_Demo_Sensors)  
- [IoT_Demo_Gateway](https://github.com/MichaelFitzurka/IoT_Demo_Gateway)  
- [IoT_Demo_Datacenter](https://github.com/MichaelFitzurka/IoT_Demo_Datacenter)  
- [IoT_Demo_BusinessRules](https://github.com/MichaelFitzurka/IoT_Demo_BusinessRules)

... I build a series of projects for a high-intensity "DemoJam" presentation.  
- [IoT-DemoJam](https://github.com/MichaelFitzurka/IoT-DemoJam)  
- [IoT-DemoJam_Sensor](https://github.com/MichaelFitzurka/IoT-DemoJam_Sensor)  
- [IoT-DemoJam_SmartGateway](https://github.com/MichaelFitzurka/IoT-DemoJam_SmartGateway)  
- [IoT-DemoJam_Datacenter-OCP_FIS](https://github.com/MichaelFitzurka/IoT-DemoJam_Datacenter-OCP_FIS)  
- [IoT-DemoJam_Datacenter-OCP_BRMSDS](https://github.com/MichaelFitzurka/IoT-DemoJam_Datacenter-OCP_BRMSDS)  
- [IoT-DemoJam_Datacenter-OCP_BusinessRules](https://github.com/MichaelFitzurka/IoT-DemoJam_Datacenter-OCP_BusinessRules)  
- [IoT-DemoJam_Datacenter_BPMS](https://github.com/MichaelFitzurka/IoT-DemoJam_Datacenter_BPMS)  
- [IoT-DemoJam_Alexa](https://github.com/MichaelFitzurka/IoT-DemoJam_Alexa)  
- [IoT-DemoJam_Drone](https://github.com/MichaelFitzurka/IoT-DemoJam_Drone)

There are a few key differences between the projects, although they share the same general structure and technologies.  
1) I moved the Datacenter components from [Docker](https://www.docker.com/) and [Red Hat JBoss Middleware](https://www.redhat.com/en/technologies/jboss-middleware) products, to [CDK/OpenShift](https://developers.redhat.com/products/cdk/overview/) and the corresponding [Red Hat JBoss Middleware products for OpenShift](https://www.openshift.com/container-platform/middleware-services.html).
2) Patrick Steiner's original set of projects had the Gateway running on a Raspberry Pi [here](http://www.opensourcerers.org/author/psteiner/), but designed his GitHub projects to run on a [Minnowboard Turbot](https://minnowboard.org/).  
I restored the [Raspberry Pi](https://www.raspberrypi.org/) configuration.  
FYI, Andrew Block [sabre1041](https://github.com/sabre1041) rebuilt the gateway to run on [OpenShift](https://www.openshift.com/) [here](https://github.com/sabre1041/iot-ocp).  
So you have choices.
3) I added [Alexa](https://developer.amazon.com/alexa), [Slack](https://slack.com/) and at the end fly in a [Bebop 2 drone](https://www.parrot.com/us/drones/parrot-bebop-2) with my hand using a [Leap Motion Controller](https://www.leapmotion.com/).  Conceptually like [nicknisi/leapcopter](https://github.com/nicknisi/leapcopter) but built with [Cylon.js](https://cylonjs.com/) like the [leap_ardrone](https://cylonjs.com/documentation/examples/cylon/js/leap_ardrone/).

As many of these changes/enhancements are for theatrics and impractical hardware configurations, I did not fork these from Mr. Steiner, but credit where credit is due, plus many thanks.

This repository will contain the cross-cutting elements and instructions on how to build the entire chain.

## Demo Video
Coming soon.

## Challenges
As demos go, the difficulty on this one is "very high", as there are lots of "moving" parts where things can go wrong, and a lot of bleeding-edge, experimental and temperamental technologies.  But when pulled off, it is an impressive and entertaining chain of events!

Cost is also a concern.  The whole setup will probably run around $900+, with about half going to the drone alone.  
Here is the equipment list (Links are only for explanation - I don't own stock and don't guarantee results):

| Demo Area | Qty | Item | Description |
| :---: | :---: | :---: | :--- |
| Sensor | 3 | [ESP8266 Weather Station Kit](http://www.diymalls.com/esp8266?product_id=73) | I didn't use the OLED display in the kit, but I did use everything else.  You could buy the items separately, but I think it was cheaper as a kit when I priced it.  Three may be excessive, but I would suggesting getting at least one spare.  Be warned, some soldering is involved! |
| Sensor | 1 | USB Hub | Used to power the sensors, although there are other power alternatives. |
| Sensor | 1 | Hair-dryer | To rapidly heat the sensor on stage.  Set on low and be careful. |
| Gateway | 1 | Raspberry Pi 3B Kit | I say kit, because a case and power plug are not included with the RPi itself, and they're kinda necessary. |
| Gateway | 1 | [Samsung 32GB EVO Plus Class 10 Micro SDHC](https://www.amazon.com/gp/product/B00WR4IJBE/ref=oh_aui_detailpage_o01_s02?ie=UTF8&psc=1) | [They have done studies](https://www.geek.com/chips/a-geek-tests-12-micro-sd-cards-with-a-raspberry-pi-to-find-the-fastest-1641182/) and this is the best Micro SDHC for the RPi. |
| Gateway | 1 | USB Thumb Drive | Optional.  Putting the swap file on the thumb drive saves wear and tear on the SDHC and is cheaper to replace. |
| Gateway | 1 | Power bank | Something like [this](http://www.microcenter.com/product/447878/10,400mAH_USB_Power_Bank) to independently power the Pi.  May not be absolutely necessary with a UPS, but the Pi gateway takes a long time to start up, and losing power at any point will kill your whole demo.  Visually it is impressive to the audience to pickup the Pi and battery and tell them everything that is running on it with nothing else attached. |
| Datacenter | 1 | Laptop (Linux based) | Hopefully you already have one.  I'm running Fedora 26, but most any Linux should do.  You'll need an ethernet connection to the router, WiFi capability to connect to the drone, 1 USB connection to the iPhone for internet, 1 USB connection to the Leap Motion Controller, and 1 USB connection to a mouse, because it is impossible (for me) to run a presentation with a touchpad. |
| Datacenter | 1 | Smartphone | Or some other means of creating a personal internet hotspot via USB. |
| Drone | 1 | Leap Motion Controller | To fly the drone. |
| Drone | 1 | Parrot Bebop 2 Drone | You need some version of the drone that Cylon.js can control.  If you pick a different drone, the controls will need to be adjusted. |
| Drone | 1 | Drone case | Optional.  The drone is expensive and delicate, and the Parrot case is perfectly molded to the drone.  Another $100, but worth it in my opinion. |
| Drone | 1 | Fishing net with large opening | Safety + Comedy = Good! |

Overall, you may also need:  
- Some power strips (Keep the hair dryer on a separate surge protector - we lost a UPS that way.)  
- A non-fried UPS power supply can be handy  
- A router, for consistent IP Addresses  
- A MiFi for consistent WiFi is nice  
- Network cables  
- Mouse  
- Speakers for the laptop and/or smartphone  
- A FitBit (or some fitness tracker) can be handy for one of the Alexa jokes, but is not necessary

Oddly, you actually don't need an Alexa device, if you can use an Alexa app, like [Reverb](https://itunes.apple.com/us/app/reverb-for-amazon-alexa/id1144695621?mt=8) for the iPhone.

## Connectivity (For my rig)
- The UPS powers the router, laptop and USB Hub (not plugged in at start).  
- The hair-dryer is plugged in, but off, on a separate outlet.  
- The router is land-line connected to the laptop, and wifi connected to the sensors and Raspberry Pi.  
- The yellow sensor is powered by AA batteries (turned off at start) and is otherwise disconnected (power at your discretion).  
- The USB hub is connected to the blue and green sensors by USB cables, but not powered at the start.  That happens during the demo itself.  
- The Raspberry Pi gateway has the thumb drive connected and is powered by the power bank.  
- The Datacenter laptop is connected thusly:  
> Power connected to the UPS
> Ethernet/landline connected to the router  
> WiFi connected to the drone  
> USB connected to the smartphone running a WiFi hotspot for internet connectivity  
> USB connected to the Leap Motion Controller  
> USB connected to a mouse  
> HDMI connected to the presentation screen  
> Speaker jack connected to ... a speaker  
- The Datacenter laptop is running:  
> CDK (in Terminal Window)  
> BPMS (in Terminal Window)  
> Firefox (Tabs: CDK/OpenShift, Datacenter's FIS Java Console, Gateway's Fuse Hawtio, BPMS)  
> Slack  
> NodeJS Drone Controller (in Terminal Window)  
> TigerVNC (connection to the Raspberry Pi Gateway)  
> Presentation  
- The smartphone:  
> has its WiFi hotspot turned on  
> is USB connected to the laptop  
> is connected to an external speaker  
> and is the running Reverb app for Alexa.  
- The drone is on with lens cap off.  
- Fishing/safety net is nearby.

## Setup
I included the full [Presentation Scripts](https://github.com/MichaelFitzurka/IoT-DemoJam/blob/master/PresentationScripts.txt) I prepared as a checklist to setup the event.

This is the cheat sheet, list of actions I created for the demo run itself:  
1) Slides
2) Show Tabs and Pi
3) Start data (Show tabs in reverse)
4) Heat 'em up (Count up temp on Pi logs)
5) Slack alert -> BPMS
6) "Alexa, ask the gateway to conduct pre-flight checks on the drone."
7) Drone page - Sensor button - Show hand
8) Fly -> 1 -> 2 -> Scare 3 -> Land
9) Complete BPMS - Light out
10) "Alexa, ask the gateway for a status report."

## Notes:
- A guiding principle to the demo design was to make sure that it did not need internet connectivity.  Unfortunately, that turned out to not be the case.  No matter what I did (skipping registration, importing docker images locally, etc.) CDK still wanted internet, at least at startup!  
- Alexa also needed internet connectivity, but since that part was non-essential, and since it was getting internet from the phone  anyway; that need was not really concerning.  
- A word about the audience:  We built this demo to entertain a technically savvy, and semi-inebriated crowd, at a DemoJam evening event within an 8 minute time slot.  Given a different context, the same setup can be used to be more informational vs. theatrical, but you will probably want to change some of the aspects of the presentation, Alexa jokes and the drone controls/conversation.
- Technically, you could probably do this demo solo, but the drone is dangerous, and I have the scars to prove it.  A second presenter helps with the drone, heating the sensors and other comedic elements.
- Alexa can take up to 15 seconds to respond, which is an eternity on stage.  Be prepared for a variable wait time with some explanations.  If you start the demo with: "Alexa, ask the gateway for a sound check" it is both funny and primes the AWS lambdas for quicker response times.

## Final Note:
If anyone is brave/foolish/rich enough to attempt this demo on their own, please do not hesitate to reach out to me on GitHub and I will do what I can.  As with any demo in front of a live audience, prepare for failures and practice *a lot*!  On a Friday (the 13th) test run (in front of my boss no less) things failed on all fronts!  Things that had never failed before.  For the DemoJam itself, I was ready to smoke and mirror my way through the whole thing, if that is what it came to, but the rig performed flawlessly.  I'm the only one who messed up, as I skipped over the "pre-flight" joke, and stomped all over my demo partner's lines.  In the end, we won 1st place, so those hiccups didn't matter.  But I can not stress enough the importance of practicing this demo, including the setup and tear down.  It is a complex beast, requiring a lot of time and a specific sequence of events to startup.  Practice, and let me know if I can help.