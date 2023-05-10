
obj/user/tst_air:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 15 0b 00 00       	call   800b4b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>
int find(int* arr, int size, int val);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec fc 01 00 00    	sub    $0x1fc,%esp
	int envID = sys_getenvid();
  800044:	e8 13 25 00 00       	call   80255c <sys_getenvid>
  800049:	89 45 bc             	mov    %eax,-0x44(%ebp)

	// *************************************************************************************************
	/// Shared Variables Region ************************************************************************
	// *************************************************************************************************

	int numOfCustomers = 15;
  80004c:	c7 45 b8 0f 00 00 00 	movl   $0xf,-0x48(%ebp)
	int flight1Customers = 3;
  800053:	c7 45 b4 03 00 00 00 	movl   $0x3,-0x4c(%ebp)
	int flight2Customers = 8;
  80005a:	c7 45 b0 08 00 00 00 	movl   $0x8,-0x50(%ebp)
	int flight3Customers = 4;
  800061:	c7 45 ac 04 00 00 00 	movl   $0x4,-0x54(%ebp)

	int flight1NumOfTickets = 8;
  800068:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%ebp)
	int flight2NumOfTickets = 15;
  80006f:	c7 45 a4 0f 00 00 00 	movl   $0xf,-0x5c(%ebp)

	char _customers[] = "customers";
  800076:	8d 85 6a ff ff ff    	lea    -0x96(%ebp),%eax
  80007c:	bb 96 3f 80 00       	mov    $0x803f96,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800094:	bb a0 3f 80 00       	mov    $0x803fa0,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  8000ac:	bb ac 3f 80 00       	mov    $0x803fac,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  8000c4:	bb bb 3f 80 00       	mov    $0x803fbb,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8000dc:	bb ca 3f 80 00       	mov    $0x803fca,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8000f4:	bb df 3f 80 00       	mov    $0x803fdf,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  80010c:	bb f4 3f 80 00       	mov    $0x803ff4,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  800124:	bb 05 40 80 00       	mov    $0x804005,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80013c:	bb 16 40 80 00       	mov    $0x804016,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800154:	bb 27 40 80 00       	mov    $0x804027,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80016c:	bb 30 40 80 00       	mov    $0x804030,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800184:	bb 3a 40 80 00       	mov    $0x80403a,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  80019c:	bb 45 40 80 00       	mov    $0x804045,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8001b4:	bb 51 40 80 00       	mov    $0x804051,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8001cc:	bb 5b 40 80 00       	mov    $0x80405b,%ebx
  8001d1:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001d6:	89 c7                	mov    %eax,%edi
  8001d8:	89 de                	mov    %ebx,%esi
  8001da:	89 d1                	mov    %edx,%ecx
  8001dc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001de:	c7 85 9f fe ff ff 63 	movl   $0x72656c63,-0x161(%ebp)
  8001e5:	6c 65 72 
  8001e8:	66 c7 85 a3 fe ff ff 	movw   $0x6b,-0x15d(%ebp)
  8001ef:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001f1:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8001f7:	bb 65 40 80 00       	mov    $0x804065,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  80020f:	bb 73 40 80 00       	mov    $0x804073,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800227:	bb 82 40 80 00       	mov    $0x804082,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  80023f:	bb 89 40 80 00       	mov    $0x804089,%ebx
  800244:	ba 07 00 00 00       	mov    $0x7,%edx
  800249:	89 c7                	mov    %eax,%edi
  80024b:	89 de                	mov    %ebx,%esi
  80024d:	89 d1                	mov    %edx,%ecx
  80024f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * custs;
	custs = smalloc(_customers, sizeof(struct Customer)*numOfCustomers, 1);
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	c1 e0 03             	shl    $0x3,%eax
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	6a 01                	push   $0x1
  80025c:	50                   	push   %eax
  80025d:	8d 85 6a ff ff ff    	lea    -0x96(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	e8 4d 1d 00 00       	call   801fb6 <smalloc>
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
  80026f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for(;f1<flight1Customers; ++f1)
  800276:	eb 2e                	jmp    8002a6 <_main+0x26e>
		{
			custs[f1].booked = 0;
  800278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80027b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800282:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800285:	01 d0                	add    %edx,%eax
  800287:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f1].flightType = 1;
  80028e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800291:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800298:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80029b:	01 d0                	add    %edx,%eax
  80029d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  8002a3:	ff 45 e4             	incl   -0x1c(%ebp)
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  8002ac:	7c ca                	jl     800278 <_main+0x240>
		{
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
  8002ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  8002b4:	eb 2e                	jmp    8002e4 <_main+0x2ac>
		{
			custs[f2].booked = 0;
  8002b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f2].flightType = 2;
  8002cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  8002e1:	ff 45 e0             	incl   -0x20(%ebp)
  8002e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002ef:	7f c5                	jg     8002b6 <_main+0x27e>
		{
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
  8002f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  8002f7:	eb 2e                	jmp    800327 <_main+0x2ef>
		{
			custs[f3].booked = 0;
  8002f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800303:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f3].flightType = 3;
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  800324:	ff 45 dc             	incl   -0x24(%ebp)
  800327:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80032a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	7f c5                	jg     8002f9 <_main+0x2c1>
			custs[f3].booked = 0;
			custs[f3].flightType = 3;
		}
	}

	int* custCounter = smalloc(_custCounter, sizeof(int), 1);
  800334:	83 ec 04             	sub    $0x4,%esp
  800337:	6a 01                	push   $0x1
  800339:	6a 04                	push   $0x4
  80033b:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800341:	50                   	push   %eax
  800342:	e8 6f 1c 00 00       	call   801fb6 <smalloc>
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	89 45 9c             	mov    %eax,-0x64(%ebp)
	*custCounter = 0;
  80034d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1Counter = smalloc(_flight1Counter, sizeof(int), 1);
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	6a 01                	push   $0x1
  80035b:	6a 04                	push   $0x4
  80035d:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  800363:	50                   	push   %eax
  800364:	e8 4d 1c 00 00       	call   801fb6 <smalloc>
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	89 45 98             	mov    %eax,-0x68(%ebp)
	*flight1Counter = flight1NumOfTickets;
  80036f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800372:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800375:	89 10                	mov    %edx,(%eax)

	int* flight2Counter = smalloc(_flight2Counter, sizeof(int), 1);
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	6a 01                	push   $0x1
  80037c:	6a 04                	push   $0x4
  80037e:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  800384:	50                   	push   %eax
  800385:	e8 2c 1c 00 00       	call   801fb6 <smalloc>
  80038a:	83 c4 10             	add    $0x10,%esp
  80038d:	89 45 94             	mov    %eax,-0x6c(%ebp)
	*flight2Counter = flight2NumOfTickets;
  800390:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800393:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800396:	89 10                	mov    %edx,(%eax)

	int* flight1BookedCounter = smalloc(_flightBooked1Counter, sizeof(int), 1);
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	6a 01                	push   $0x1
  80039d:	6a 04                	push   $0x4
  80039f:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8003a5:	50                   	push   %eax
  8003a6:	e8 0b 1c 00 00       	call   801fb6 <smalloc>
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	89 45 90             	mov    %eax,-0x70(%ebp)
	*flight1BookedCounter = 0;
  8003b1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight2BookedCounter = smalloc(_flightBooked2Counter, sizeof(int), 1);
  8003ba:	83 ec 04             	sub    $0x4,%esp
  8003bd:	6a 01                	push   $0x1
  8003bf:	6a 04                	push   $0x4
  8003c1:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 e9 1b 00 00       	call   801fb6 <smalloc>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	89 45 8c             	mov    %eax,-0x74(%ebp)
	*flight2BookedCounter = 0;
  8003d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1BookedArr = smalloc(_flightBooked1Arr, sizeof(int)*flight1NumOfTickets, 1);
  8003dc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003df:	c1 e0 02             	shl    $0x2,%eax
  8003e2:	83 ec 04             	sub    $0x4,%esp
  8003e5:	6a 01                	push   $0x1
  8003e7:	50                   	push   %eax
  8003e8:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  8003ee:	50                   	push   %eax
  8003ef:	e8 c2 1b 00 00       	call   801fb6 <smalloc>
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	89 45 88             	mov    %eax,-0x78(%ebp)
	int* flight2BookedArr = smalloc(_flightBooked2Arr, sizeof(int)*flight2NumOfTickets, 1);
  8003fa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fd:	c1 e0 02             	shl    $0x2,%eax
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	6a 01                	push   $0x1
  800405:	50                   	push   %eax
  800406:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  80040c:	50                   	push   %eax
  80040d:	e8 a4 1b 00 00       	call   801fb6 <smalloc>
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	89 45 84             	mov    %eax,-0x7c(%ebp)

	int* cust_ready_queue = smalloc(_cust_ready_queue, sizeof(int)*numOfCustomers, 1);
  800418:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80041b:	c1 e0 02             	shl    $0x2,%eax
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	6a 01                	push   $0x1
  800423:	50                   	push   %eax
  800424:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80042a:	50                   	push   %eax
  80042b:	e8 86 1b 00 00       	call   801fb6 <smalloc>
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	89 45 80             	mov    %eax,-0x80(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	6a 01                	push   $0x1
  80043b:	6a 04                	push   $0x4
  80043d:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800443:	50                   	push   %eax
  800444:	e8 6d 1b 00 00       	call   801fb6 <smalloc>
  800449:	83 c4 10             	add    $0x10,%esp
  80044c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	*queue_in = 0;
  800452:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* queue_out = smalloc(_queue_out, sizeof(int), 1);
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	6a 01                	push   $0x1
  800463:	6a 04                	push   $0x4
  800465:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80046b:	50                   	push   %eax
  80046c:	e8 45 1b 00 00       	call   801fb6 <smalloc>
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	*queue_out = 0;
  80047a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// *************************************************************************************************
	/// Semaphores Region ******************************************************************************
	// *************************************************************************************************
	sys_createSemaphore(_flight1CS, 1);
  800486:	83 ec 08             	sub    $0x8,%esp
  800489:	6a 01                	push   $0x1
  80048b:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  800491:	50                   	push   %eax
  800492:	e8 5f 1f 00 00       	call   8023f6 <sys_createSemaphore>
  800497:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_flight2CS, 1);
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	6a 01                	push   $0x1
  80049f:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8004a5:	50                   	push   %eax
  8004a6:	e8 4b 1f 00 00       	call   8023f6 <sys_createSemaphore>
  8004ab:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custCounterCS, 1);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	6a 01                	push   $0x1
  8004b3:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8004b9:	50                   	push   %eax
  8004ba:	e8 37 1f 00 00       	call   8023f6 <sys_createSemaphore>
  8004bf:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_custQueueCS, 1);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 23 1f 00 00       	call   8023f6 <sys_createSemaphore>
  8004d3:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_clerk, 3);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	6a 03                	push   $0x3
  8004db:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8004e1:	50                   	push   %eax
  8004e2:	e8 0f 1f 00 00       	call   8023f6 <sys_createSemaphore>
  8004e7:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_cust_ready, 0);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	6a 00                	push   $0x0
  8004ef:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 fb 1e 00 00       	call   8023f6 <sys_createSemaphore>
  8004fb:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custTerminated, 0);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	6a 00                	push   $0x0
  800503:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800509:	50                   	push   %eax
  80050a:	e8 e7 1e 00 00       	call   8023f6 <sys_createSemaphore>
  80050f:	83 c4 10             	add    $0x10,%esp

	int s=0;
  800512:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  800519:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800520:	eb 78                	jmp    80059a <_main+0x562>
	{
		char prefix[30]="cust_finished";
  800522:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  800528:	bb 90 40 80 00       	mov    $0x804090,%ebx
  80052d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800532:	89 c7                	mov    %eax,%edi
  800534:	89 de                	mov    %ebx,%esi
  800536:	89 d1                	mov    %edx,%ecx
  800538:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80053a:	8d 95 64 fe ff ff    	lea    -0x19c(%ebp),%edx
  800540:	b9 04 00 00 00       	mov    $0x4,%ecx
  800545:	b8 00 00 00 00       	mov    $0x0,%eax
  80054a:	89 d7                	mov    %edx,%edi
  80054c:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(s, id);
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	8d 85 51 fe ff ff    	lea    -0x1af(%ebp),%eax
  800557:	50                   	push   %eax
  800558:	ff 75 d8             	pushl  -0x28(%ebp)
  80055b:	e8 03 15 00 00       	call   801a63 <ltostr>
  800560:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  800563:	83 ec 04             	sub    $0x4,%esp
  800566:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  80056c:	50                   	push   %eax
  80056d:	8d 85 51 fe ff ff    	lea    -0x1af(%ebp),%eax
  800573:	50                   	push   %eax
  800574:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  80057a:	50                   	push   %eax
  80057b:	e8 db 15 00 00       	call   801b5b <strcconcat>
  800580:	83 c4 10             	add    $0x10,%esp
		sys_createSemaphore(sname, 0);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	6a 00                	push   $0x0
  800588:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  80058e:	50                   	push   %eax
  80058f:	e8 62 1e 00 00       	call   8023f6 <sys_createSemaphore>
  800594:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_cust_ready, 0);

	sys_createSemaphore(_custTerminated, 0);

	int s=0;
	for(s=0; s<numOfCustomers; ++s)
  800597:	ff 45 d8             	incl   -0x28(%ebp)
  80059a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80059d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8005a0:	7c 80                	jl     800522 <_main+0x4ea>
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//3 clerks
	uint32 envId;
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8005a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8005a7:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8005ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8005b8:	89 c1                	mov    %eax,%ecx
  8005ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bf:	8b 40 74             	mov    0x74(%eax),%eax
  8005c2:	52                   	push   %edx
  8005c3:	51                   	push   %ecx
  8005c4:	50                   	push   %eax
  8005c5:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  8005cb:	50                   	push   %eax
  8005cc:	e8 36 1f 00 00       	call   802507 <sys_create_env>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  8005da:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 3c 1f 00 00       	call   802525 <sys_run_env>
  8005e9:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8005ec:	a1 20 50 80 00       	mov    0x805020,%eax
  8005f1:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8005f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8005fc:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800602:	89 c1                	mov    %eax,%ecx
  800604:	a1 20 50 80 00       	mov    0x805020,%eax
  800609:	8b 40 74             	mov    0x74(%eax),%eax
  80060c:	52                   	push   %edx
  80060d:	51                   	push   %ecx
  80060e:	50                   	push   %eax
  80060f:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800615:	50                   	push   %eax
  800616:	e8 ec 1e 00 00       	call   802507 <sys_create_env>
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  800624:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80062a:	83 ec 0c             	sub    $0xc,%esp
  80062d:	50                   	push   %eax
  80062e:	e8 f2 1e 00 00       	call   802525 <sys_run_env>
  800633:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800636:	a1 20 50 80 00       	mov    0x805020,%eax
  80063b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800641:	a1 20 50 80 00       	mov    0x805020,%eax
  800646:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80064c:	89 c1                	mov    %eax,%ecx
  80064e:	a1 20 50 80 00       	mov    0x805020,%eax
  800653:	8b 40 74             	mov    0x74(%eax),%eax
  800656:	52                   	push   %edx
  800657:	51                   	push   %ecx
  800658:	50                   	push   %eax
  800659:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  80065f:	50                   	push   %eax
  800660:	e8 a2 1e 00 00       	call   802507 <sys_create_env>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  80066e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800674:	83 ec 0c             	sub    $0xc,%esp
  800677:	50                   	push   %eax
  800678:	e8 a8 1e 00 00       	call   802525 <sys_run_env>
  80067d:	83 c4 10             	add    $0x10,%esp

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800680:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800687:	eb 6d                	jmp    8006f6 <_main+0x6be>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800689:	a1 20 50 80 00       	mov    0x805020,%eax
  80068e:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800694:	a1 20 50 80 00       	mov    0x805020,%eax
  800699:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80069f:	89 c1                	mov    %eax,%ecx
  8006a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a6:	8b 40 74             	mov    0x74(%eax),%eax
  8006a9:	52                   	push   %edx
  8006aa:	51                   	push   %ecx
  8006ab:	50                   	push   %eax
  8006ac:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  8006b2:	50                   	push   %eax
  8006b3:	e8 4f 1e 00 00       	call   802507 <sys_create_env>
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  8006c1:	83 bd 74 ff ff ff ef 	cmpl   $0xffffffef,-0x8c(%ebp)
  8006c8:	75 17                	jne    8006e1 <_main+0x6a9>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  8006ca:	83 ec 04             	sub    $0x4,%esp
  8006cd:	68 c0 3c 80 00       	push   $0x803cc0
  8006d2:	68 95 00 00 00       	push   $0x95
  8006d7:	68 06 3d 80 00       	push   $0x803d06
  8006dc:	e8 a6 05 00 00       	call   800c87 <_panic>

		sys_run_env(envId);
  8006e1:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	50                   	push   %eax
  8006eb:	e8 35 1e 00 00       	call   802525 <sys_run_env>
  8006f0:	83 c4 10             	add    $0x10,%esp
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
	sys_run_env(envId);

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  8006f3:	ff 45 d4             	incl   -0x2c(%ebp)
  8006f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8006fc:	7c 8b                	jl     800689 <_main+0x651>

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8006fe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800705:	eb 18                	jmp    80071f <_main+0x6e7>
	{
		sys_waitSemaphore(envID, _custTerminated);
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800710:	50                   	push   %eax
  800711:	ff 75 bc             	pushl  -0x44(%ebp)
  800714:	e8 16 1d 00 00       	call   80242f <sys_waitSemaphore>
  800719:	83 c4 10             	add    $0x10,%esp

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  80071c:	ff 45 d4             	incl   -0x2c(%ebp)
  80071f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800722:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800725:	7c e0                	jl     800707 <_main+0x6cf>
	{
		sys_waitSemaphore(envID, _custTerminated);
	}

	env_sleep(1500);
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	68 dc 05 00 00       	push   $0x5dc
  80072f:	e8 5b 32 00 00       	call   80398f <env_sleep>
  800734:	83 c4 10             	add    $0x10,%esp

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800737:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80073e:	eb 45                	jmp    800785 <_main+0x74d>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
  800740:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80074a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800758:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80075b:	01 d0                	add    %edx,%eax
  80075d:	8b 10                	mov    (%eax),%edx
  80075f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800762:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800769:	8b 45 88             	mov    -0x78(%ebp),%eax
  80076c:	01 c8                	add    %ecx,%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	83 ec 04             	sub    $0x4,%esp
  800773:	52                   	push   %edx
  800774:	50                   	push   %eax
  800775:	68 18 3d 80 00       	push   $0x803d18
  80077a:	e8 bc 07 00 00       	call   800f3b <cprintf>
  80077f:	83 c4 10             	add    $0x10,%esp

	env_sleep(1500);

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800782:	ff 45 d0             	incl   -0x30(%ebp)
  800785:	8b 45 90             	mov    -0x70(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80078d:	7f b1                	jg     800740 <_main+0x708>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  80078f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800796:	eb 45                	jmp    8007dd <_main+0x7a5>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
  800798:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80079b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007a2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007a5:	01 d0                	add    %edx,%eax
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007b0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8007b3:	01 d0                	add    %edx,%eax
  8007b5:	8b 10                	mov    (%eax),%edx
  8007b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007ba:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007c1:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007c4:	01 c8                	add    %ecx,%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 ec 04             	sub    $0x4,%esp
  8007cb:	52                   	push   %edx
  8007cc:	50                   	push   %eax
  8007cd:	68 48 3d 80 00       	push   $0x803d48
  8007d2:	e8 64 07 00 00       	call   800f3b <cprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
	for(b=0; b< (*flight1BookedCounter);++b)
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  8007da:	ff 45 d0             	incl   -0x30(%ebp)
  8007dd:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8007e5:	7f b1                	jg     800798 <_main+0x760>
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
  8007e7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		for(;f1<flight1Customers; ++f1)
  8007ee:	eb 33                	jmp    800823 <_main+0x7eb>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f1) != 1)
  8007f0:	83 ec 04             	sub    $0x4,%esp
  8007f3:	ff 75 cc             	pushl  -0x34(%ebp)
  8007f6:	ff 75 a8             	pushl  -0x58(%ebp)
  8007f9:	ff 75 88             	pushl  -0x78(%ebp)
  8007fc:	e8 05 03 00 00       	call   800b06 <find>
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	83 f8 01             	cmp    $0x1,%eax
  800807:	74 17                	je     800820 <_main+0x7e8>
			{
				panic("Error, wrong booking for user %d\n", f1);
  800809:	ff 75 cc             	pushl  -0x34(%ebp)
  80080c:	68 78 3d 80 00       	push   $0x803d78
  800811:	68 b5 00 00 00       	push   $0xb5
  800816:	68 06 3d 80 00       	push   $0x803d06
  80081b:	e8 67 04 00 00       	call   800c87 <_panic>
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  800820:	ff 45 cc             	incl   -0x34(%ebp)
  800823:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800826:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  800829:	7c c5                	jl     8007f0 <_main+0x7b8>
			{
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
  80082b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80082e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  800831:	eb 33                	jmp    800866 <_main+0x82e>
		{
			if(find(flight2BookedArr, flight2NumOfTickets, f2) != 1)
  800833:	83 ec 04             	sub    $0x4,%esp
  800836:	ff 75 c8             	pushl  -0x38(%ebp)
  800839:	ff 75 a4             	pushl  -0x5c(%ebp)
  80083c:	ff 75 84             	pushl  -0x7c(%ebp)
  80083f:	e8 c2 02 00 00       	call   800b06 <find>
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	83 f8 01             	cmp    $0x1,%eax
  80084a:	74 17                	je     800863 <_main+0x82b>
			{
				panic("Error, wrong booking for user %d\n", f2);
  80084c:	ff 75 c8             	pushl  -0x38(%ebp)
  80084f:	68 78 3d 80 00       	push   $0x803d78
  800854:	68 be 00 00 00       	push   $0xbe
  800859:	68 06 3d 80 00       	push   $0x803d06
  80085e:	e8 24 04 00 00       	call   800c87 <_panic>
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  800863:	ff 45 c8             	incl   -0x38(%ebp)
  800866:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800869:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80086c:	01 d0                	add    %edx,%eax
  80086e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800871:	7f c0                	jg     800833 <_main+0x7fb>
			{
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
  800873:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800876:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  800879:	eb 4c                	jmp    8008c7 <_main+0x88f>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f3) != 1 || find(flight2BookedArr, flight2NumOfTickets, f3) != 1)
  80087b:	83 ec 04             	sub    $0x4,%esp
  80087e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800881:	ff 75 a8             	pushl  -0x58(%ebp)
  800884:	ff 75 88             	pushl  -0x78(%ebp)
  800887:	e8 7a 02 00 00       	call   800b06 <find>
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	83 f8 01             	cmp    $0x1,%eax
  800892:	75 19                	jne    8008ad <_main+0x875>
  800894:	83 ec 04             	sub    $0x4,%esp
  800897:	ff 75 c4             	pushl  -0x3c(%ebp)
  80089a:	ff 75 a4             	pushl  -0x5c(%ebp)
  80089d:	ff 75 84             	pushl  -0x7c(%ebp)
  8008a0:	e8 61 02 00 00       	call   800b06 <find>
  8008a5:	83 c4 10             	add    $0x10,%esp
  8008a8:	83 f8 01             	cmp    $0x1,%eax
  8008ab:	74 17                	je     8008c4 <_main+0x88c>
			{
				panic("Error, wrong booking for user %d\n", f3);
  8008ad:	ff 75 c4             	pushl  -0x3c(%ebp)
  8008b0:	68 78 3d 80 00       	push   $0x803d78
  8008b5:	68 c7 00 00 00       	push   $0xc7
  8008ba:	68 06 3d 80 00       	push   $0x803d06
  8008bf:	e8 c3 03 00 00       	call   800c87 <_panic>
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  8008c4:	ff 45 c4             	incl   -0x3c(%ebp)
  8008c7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8008ca:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8008cd:	01 d0                	add    %edx,%eax
  8008cf:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8008d2:	7f a7                	jg     80087b <_main+0x843>
			{
				panic("Error, wrong booking for user %d\n", f3);
			}
		}

		assert(sys_getSemaphoreValue(envID, _flight1CS) == 1);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8008dd:	50                   	push   %eax
  8008de:	ff 75 bc             	pushl  -0x44(%ebp)
  8008e1:	e8 2c 1b 00 00       	call   802412 <sys_getSemaphoreValue>
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	83 f8 01             	cmp    $0x1,%eax
  8008ec:	74 19                	je     800907 <_main+0x8cf>
  8008ee:	68 9c 3d 80 00       	push   $0x803d9c
  8008f3:	68 ca 3d 80 00       	push   $0x803dca
  8008f8:	68 cb 00 00 00       	push   $0xcb
  8008fd:	68 06 3d 80 00       	push   $0x803d06
  800902:	e8 80 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _flight2CS) == 1);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  800910:	50                   	push   %eax
  800911:	ff 75 bc             	pushl  -0x44(%ebp)
  800914:	e8 f9 1a 00 00       	call   802412 <sys_getSemaphoreValue>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	83 f8 01             	cmp    $0x1,%eax
  80091f:	74 19                	je     80093a <_main+0x902>
  800921:	68 e0 3d 80 00       	push   $0x803de0
  800926:	68 ca 3d 80 00       	push   $0x803dca
  80092b:	68 cc 00 00 00       	push   $0xcc
  800930:	68 06 3d 80 00       	push   $0x803d06
  800935:	e8 4d 03 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custCounterCS) ==  1);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  800943:	50                   	push   %eax
  800944:	ff 75 bc             	pushl  -0x44(%ebp)
  800947:	e8 c6 1a 00 00       	call   802412 <sys_getSemaphoreValue>
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	83 f8 01             	cmp    $0x1,%eax
  800952:	74 19                	je     80096d <_main+0x935>
  800954:	68 10 3e 80 00       	push   $0x803e10
  800959:	68 ca 3d 80 00       	push   $0x803dca
  80095e:	68 ce 00 00 00       	push   $0xce
  800963:	68 06 3d 80 00       	push   $0x803d06
  800968:	e8 1a 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _custQueueCS) ==  1);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  800976:	50                   	push   %eax
  800977:	ff 75 bc             	pushl  -0x44(%ebp)
  80097a:	e8 93 1a 00 00       	call   802412 <sys_getSemaphoreValue>
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	83 f8 01             	cmp    $0x1,%eax
  800985:	74 19                	je     8009a0 <_main+0x968>
  800987:	68 44 3e 80 00       	push   $0x803e44
  80098c:	68 ca 3d 80 00       	push   $0x803dca
  800991:	68 cf 00 00 00       	push   $0xcf
  800996:	68 06 3d 80 00       	push   $0x803d06
  80099b:	e8 e7 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _clerk) == 3);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8009a9:	50                   	push   %eax
  8009aa:	ff 75 bc             	pushl  -0x44(%ebp)
  8009ad:	e8 60 1a 00 00       	call   802412 <sys_getSemaphoreValue>
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	83 f8 03             	cmp    $0x3,%eax
  8009b8:	74 19                	je     8009d3 <_main+0x99b>
  8009ba:	68 74 3e 80 00       	push   $0x803e74
  8009bf:	68 ca 3d 80 00       	push   $0x803dca
  8009c4:	68 d1 00 00 00       	push   $0xd1
  8009c9:	68 06 3d 80 00       	push   $0x803d06
  8009ce:	e8 b4 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8009dc:	50                   	push   %eax
  8009dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8009e0:	e8 2d 1a 00 00       	call   802412 <sys_getSemaphoreValue>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8009eb:	74 19                	je     800a06 <_main+0x9ce>
  8009ed:	68 a0 3e 80 00       	push   $0x803ea0
  8009f2:	68 ca 3d 80 00       	push   $0x803dca
  8009f7:	68 d3 00 00 00       	push   $0xd3
  8009fc:	68 06 3d 80 00       	push   $0x803d06
  800a01:	e8 81 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	ff 75 bc             	pushl  -0x44(%ebp)
  800a13:	e8 fa 19 00 00       	call   802412 <sys_getSemaphoreValue>
  800a18:	83 c4 10             	add    $0x10,%esp
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	74 19                	je     800a38 <_main+0xa00>
  800a1f:	68 d0 3e 80 00       	push   $0x803ed0
  800a24:	68 ca 3d 80 00       	push   $0x803dca
  800a29:	68 d5 00 00 00       	push   $0xd5
  800a2e:	68 06 3d 80 00       	push   $0x803d06
  800a33:	e8 4f 02 00 00       	call   800c87 <_panic>

		int s=0;
  800a38:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800a3f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  800a46:	e9 96 00 00 00       	jmp    800ae1 <_main+0xaa9>
		{
			char prefix[30]="cust_finished";
  800a4b:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800a51:	bb 90 40 80 00       	mov    $0x804090,%ebx
  800a56:	ba 0e 00 00 00       	mov    $0xe,%edx
  800a5b:	89 c7                	mov    %eax,%edi
  800a5d:	89 de                	mov    %ebx,%esi
  800a5f:	89 d1                	mov    %edx,%ecx
  800a61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800a63:	8d 95 41 fe ff ff    	lea    -0x1bf(%ebp),%edx
  800a69:	b9 04 00 00 00       	mov    $0x4,%ecx
  800a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a73:	89 d7                	mov    %edx,%edi
  800a75:	f3 ab                	rep stos %eax,%es:(%edi)
			char id[5]; char cust_finishedSemaphoreName[50];
			ltostr(s, id);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	8d 85 2e fe ff ff    	lea    -0x1d2(%ebp),%eax
  800a80:	50                   	push   %eax
  800a81:	ff 75 c0             	pushl  -0x40(%ebp)
  800a84:	e8 da 0f 00 00       	call   801a63 <ltostr>
  800a89:	83 c4 10             	add    $0x10,%esp
			strcconcat(prefix, id, cust_finishedSemaphoreName);
  800a8c:	83 ec 04             	sub    $0x4,%esp
  800a8f:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  800a95:	50                   	push   %eax
  800a96:	8d 85 2e fe ff ff    	lea    -0x1d2(%ebp),%eax
  800a9c:	50                   	push   %eax
  800a9d:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800aa3:	50                   	push   %eax
  800aa4:	e8 b2 10 00 00       	call   801b5b <strcconcat>
  800aa9:	83 c4 10             	add    $0x10,%esp
			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  800ab5:	50                   	push   %eax
  800ab6:	ff 75 bc             	pushl  -0x44(%ebp)
  800ab9:	e8 54 19 00 00       	call   802412 <sys_getSemaphoreValue>
  800abe:	83 c4 10             	add    $0x10,%esp
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	74 19                	je     800ade <_main+0xaa6>
  800ac5:	68 04 3f 80 00       	push   $0x803f04
  800aca:	68 ca 3d 80 00       	push   $0x803dca
  800acf:	68 de 00 00 00       	push   $0xde
  800ad4:	68 06 3d 80 00       	push   $0x803d06
  800ad9:	e8 a9 01 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);

		int s=0;
		for(s=0; s<numOfCustomers; ++s)
  800ade:	ff 45 c0             	incl   -0x40(%ebp)
  800ae1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800ae4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800ae7:	0f 8c 5e ff ff ff    	jl     800a4b <_main+0xa13>
			ltostr(s, id);
			strcconcat(prefix, id, cust_finishedSemaphoreName);
			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
		}

		cprintf("Congratulations, All reservations are successfully done... have a nice flight :)\n");
  800aed:	83 ec 0c             	sub    $0xc,%esp
  800af0:	68 44 3f 80 00       	push   $0x803f44
  800af5:	e8 41 04 00 00       	call   800f3b <cprintf>
  800afa:	83 c4 10             	add    $0x10,%esp
	}

}
  800afd:	90                   	nop
  800afe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5f                   	pop    %edi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <find>:


int find(int* arr, int size, int val)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	83 ec 10             	sub    $0x10,%esp

	int result = 0;
  800b0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int i;
	for(i=0; i<size;++i )
  800b13:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800b1a:	eb 22                	jmp    800b3e <find+0x38>
	{
		if(arr[i] == val)
  800b1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	01 d0                	add    %edx,%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b30:	75 09                	jne    800b3b <find+0x35>
		{
			result = 1;
  800b32:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
			break;
  800b39:	eb 0b                	jmp    800b46 <find+0x40>
{

	int result = 0;

	int i;
	for(i=0; i<size;++i )
  800b3b:	ff 45 f8             	incl   -0x8(%ebp)
  800b3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b41:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b44:	7c d6                	jl     800b1c <find+0x16>
			result = 1;
			break;
		}
	}

	return result;
  800b46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b51:	e8 1f 1a 00 00       	call   802575 <sys_getenvindex>
  800b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b5c:	89 d0                	mov    %edx,%eax
  800b5e:	c1 e0 03             	shl    $0x3,%eax
  800b61:	01 d0                	add    %edx,%eax
  800b63:	01 c0                	add    %eax,%eax
  800b65:	01 d0                	add    %edx,%eax
  800b67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b6e:	01 d0                	add    %edx,%eax
  800b70:	c1 e0 04             	shl    $0x4,%eax
  800b73:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b78:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b7d:	a1 20 50 80 00       	mov    0x805020,%eax
  800b82:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800b88:	84 c0                	test   %al,%al
  800b8a:	74 0f                	je     800b9b <libmain+0x50>
		binaryname = myEnv->prog_name;
  800b8c:	a1 20 50 80 00       	mov    0x805020,%eax
  800b91:	05 5c 05 00 00       	add    $0x55c,%eax
  800b96:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b9f:	7e 0a                	jle    800bab <libmain+0x60>
		binaryname = argv[0];
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	ff 75 0c             	pushl  0xc(%ebp)
  800bb1:	ff 75 08             	pushl  0x8(%ebp)
  800bb4:	e8 7f f4 ff ff       	call   800038 <_main>
  800bb9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800bbc:	e8 c1 17 00 00       	call   802382 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 c8 40 80 00       	push   $0x8040c8
  800bc9:	e8 6d 03 00 00       	call   800f3b <cprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bd1:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800bdc:	a1 20 50 80 00       	mov    0x805020,%eax
  800be1:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800be7:	83 ec 04             	sub    $0x4,%esp
  800bea:	52                   	push   %edx
  800beb:	50                   	push   %eax
  800bec:	68 f0 40 80 00       	push   $0x8040f0
  800bf1:	e8 45 03 00 00       	call   800f3b <cprintf>
  800bf6:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800bf9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bfe:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800c04:	a1 20 50 80 00       	mov    0x805020,%eax
  800c09:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800c0f:	a1 20 50 80 00       	mov    0x805020,%eax
  800c14:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800c1a:	51                   	push   %ecx
  800c1b:	52                   	push   %edx
  800c1c:	50                   	push   %eax
  800c1d:	68 18 41 80 00       	push   $0x804118
  800c22:	e8 14 03 00 00       	call   800f3b <cprintf>
  800c27:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c2a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c2f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	50                   	push   %eax
  800c39:	68 70 41 80 00       	push   $0x804170
  800c3e:	e8 f8 02 00 00       	call   800f3b <cprintf>
  800c43:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c46:	83 ec 0c             	sub    $0xc,%esp
  800c49:	68 c8 40 80 00       	push   $0x8040c8
  800c4e:	e8 e8 02 00 00       	call   800f3b <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c56:	e8 41 17 00 00       	call   80239c <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c5b:	e8 19 00 00 00       	call   800c79 <exit>
}
  800c60:	90                   	nop
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	6a 00                	push   $0x0
  800c6e:	e8 ce 18 00 00       	call   802541 <sys_destroy_env>
  800c73:	83 c4 10             	add    $0x10,%esp
}
  800c76:	90                   	nop
  800c77:	c9                   	leave  
  800c78:	c3                   	ret    

00800c79 <exit>:

void
exit(void)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c7f:	e8 23 19 00 00       	call   8025a7 <sys_exit_env>
}
  800c84:	90                   	nop
  800c85:	c9                   	leave  
  800c86:	c3                   	ret    

00800c87 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c8d:	8d 45 10             	lea    0x10(%ebp),%eax
  800c90:	83 c0 04             	add    $0x4,%eax
  800c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c96:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c9b:	85 c0                	test   %eax,%eax
  800c9d:	74 16                	je     800cb5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c9f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ca4:	83 ec 08             	sub    $0x8,%esp
  800ca7:	50                   	push   %eax
  800ca8:	68 84 41 80 00       	push   $0x804184
  800cad:	e8 89 02 00 00       	call   800f3b <cprintf>
  800cb2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cb5:	a1 00 50 80 00       	mov    0x805000,%eax
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	68 89 41 80 00       	push   $0x804189
  800cc6:	e8 70 02 00 00       	call   800f3b <cprintf>
  800ccb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cce:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd7:	50                   	push   %eax
  800cd8:	e8 f3 01 00 00       	call   800ed0 <vcprintf>
  800cdd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800ce0:	83 ec 08             	sub    $0x8,%esp
  800ce3:	6a 00                	push   $0x0
  800ce5:	68 a5 41 80 00       	push   $0x8041a5
  800cea:	e8 e1 01 00 00       	call   800ed0 <vcprintf>
  800cef:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800cf2:	e8 82 ff ff ff       	call   800c79 <exit>

	// should not return here
	while (1) ;
  800cf7:	eb fe                	jmp    800cf7 <_panic+0x70>

00800cf9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800cff:	a1 20 50 80 00       	mov    0x805020,%eax
  800d04:	8b 50 74             	mov    0x74(%eax),%edx
  800d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0a:	39 c2                	cmp    %eax,%edx
  800d0c:	74 14                	je     800d22 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d0e:	83 ec 04             	sub    $0x4,%esp
  800d11:	68 a8 41 80 00       	push   $0x8041a8
  800d16:	6a 26                	push   $0x26
  800d18:	68 f4 41 80 00       	push   $0x8041f4
  800d1d:	e8 65 ff ff ff       	call   800c87 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d30:	e9 c2 00 00 00       	jmp    800df7 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d38:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	01 d0                	add    %edx,%eax
  800d44:	8b 00                	mov    (%eax),%eax
  800d46:	85 c0                	test   %eax,%eax
  800d48:	75 08                	jne    800d52 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d4a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d4d:	e9 a2 00 00 00       	jmp    800df4 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d52:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d59:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d60:	eb 69                	jmp    800dcb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d62:	a1 20 50 80 00       	mov    0x805020,%eax
  800d67:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d70:	89 d0                	mov    %edx,%eax
  800d72:	01 c0                	add    %eax,%eax
  800d74:	01 d0                	add    %edx,%eax
  800d76:	c1 e0 03             	shl    $0x3,%eax
  800d79:	01 c8                	add    %ecx,%eax
  800d7b:	8a 40 04             	mov    0x4(%eax),%al
  800d7e:	84 c0                	test   %al,%al
  800d80:	75 46                	jne    800dc8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d82:	a1 20 50 80 00       	mov    0x805020,%eax
  800d87:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d8d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d90:	89 d0                	mov    %edx,%eax
  800d92:	01 c0                	add    %eax,%eax
  800d94:	01 d0                	add    %edx,%eax
  800d96:	c1 e0 03             	shl    $0x3,%eax
  800d99:	01 c8                	add    %ecx,%eax
  800d9b:	8b 00                	mov    (%eax),%eax
  800d9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800da0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800da3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800da8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dad:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	01 c8                	add    %ecx,%eax
  800db9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dbb:	39 c2                	cmp    %eax,%edx
  800dbd:	75 09                	jne    800dc8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800dbf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800dc6:	eb 12                	jmp    800dda <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dc8:	ff 45 e8             	incl   -0x18(%ebp)
  800dcb:	a1 20 50 80 00       	mov    0x805020,%eax
  800dd0:	8b 50 74             	mov    0x74(%eax),%edx
  800dd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800dd6:	39 c2                	cmp    %eax,%edx
  800dd8:	77 88                	ja     800d62 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dda:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800dde:	75 14                	jne    800df4 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	68 00 42 80 00       	push   $0x804200
  800de8:	6a 3a                	push   $0x3a
  800dea:	68 f4 41 80 00       	push   $0x8041f4
  800def:	e8 93 fe ff ff       	call   800c87 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800df4:	ff 45 f0             	incl   -0x10(%ebp)
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dfd:	0f 8c 32 ff ff ff    	jl     800d35 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e03:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e0a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e11:	eb 26                	jmp    800e39 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e13:	a1 20 50 80 00       	mov    0x805020,%eax
  800e18:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e21:	89 d0                	mov    %edx,%eax
  800e23:	01 c0                	add    %eax,%eax
  800e25:	01 d0                	add    %edx,%eax
  800e27:	c1 e0 03             	shl    $0x3,%eax
  800e2a:	01 c8                	add    %ecx,%eax
  800e2c:	8a 40 04             	mov    0x4(%eax),%al
  800e2f:	3c 01                	cmp    $0x1,%al
  800e31:	75 03                	jne    800e36 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800e33:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e36:	ff 45 e0             	incl   -0x20(%ebp)
  800e39:	a1 20 50 80 00       	mov    0x805020,%eax
  800e3e:	8b 50 74             	mov    0x74(%eax),%edx
  800e41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e44:	39 c2                	cmp    %eax,%edx
  800e46:	77 cb                	ja     800e13 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e4b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e4e:	74 14                	je     800e64 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e50:	83 ec 04             	sub    $0x4,%esp
  800e53:	68 54 42 80 00       	push   $0x804254
  800e58:	6a 44                	push   $0x44
  800e5a:	68 f4 41 80 00       	push   $0x8041f4
  800e5f:	e8 23 fe ff ff       	call   800c87 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e64:	90                   	nop
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e70:	8b 00                	mov    (%eax),%eax
  800e72:	8d 48 01             	lea    0x1(%eax),%ecx
  800e75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e78:	89 0a                	mov    %ecx,(%edx)
  800e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7d:	88 d1                	mov    %dl,%cl
  800e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e82:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	8b 00                	mov    (%eax),%eax
  800e8b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e90:	75 2c                	jne    800ebe <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e92:	a0 24 50 80 00       	mov    0x805024,%al
  800e97:	0f b6 c0             	movzbl %al,%eax
  800e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9d:	8b 12                	mov    (%edx),%edx
  800e9f:	89 d1                	mov    %edx,%ecx
  800ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea4:	83 c2 08             	add    $0x8,%edx
  800ea7:	83 ec 04             	sub    $0x4,%esp
  800eaa:	50                   	push   %eax
  800eab:	51                   	push   %ecx
  800eac:	52                   	push   %edx
  800ead:	e8 22 13 00 00       	call   8021d4 <sys_cputs>
  800eb2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	8b 40 04             	mov    0x4(%eax),%eax
  800ec4:	8d 50 01             	lea    0x1(%eax),%edx
  800ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eca:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ecd:	90                   	nop
  800ece:	c9                   	leave  
  800ecf:	c3                   	ret    

00800ed0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ed9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ee0:	00 00 00 
	b.cnt = 0;
  800ee3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800eea:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	ff 75 08             	pushl  0x8(%ebp)
  800ef3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ef9:	50                   	push   %eax
  800efa:	68 67 0e 80 00       	push   $0x800e67
  800eff:	e8 11 02 00 00       	call   801115 <vprintfmt>
  800f04:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f07:	a0 24 50 80 00       	mov    0x805024,%al
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f15:	83 ec 04             	sub    $0x4,%esp
  800f18:	50                   	push   %eax
  800f19:	52                   	push   %edx
  800f1a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f20:	83 c0 08             	add    $0x8,%eax
  800f23:	50                   	push   %eax
  800f24:	e8 ab 12 00 00       	call   8021d4 <sys_cputs>
  800f29:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f2c:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800f33:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <cprintf>:

int cprintf(const char *fmt, ...) {
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f41:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f48:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	83 ec 08             	sub    $0x8,%esp
  800f54:	ff 75 f4             	pushl  -0xc(%ebp)
  800f57:	50                   	push   %eax
  800f58:	e8 73 ff ff ff       	call   800ed0 <vcprintf>
  800f5d:	83 c4 10             	add    $0x10,%esp
  800f60:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f6e:	e8 0f 14 00 00       	call   802382 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f73:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	83 ec 08             	sub    $0x8,%esp
  800f7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f82:	50                   	push   %eax
  800f83:	e8 48 ff ff ff       	call   800ed0 <vcprintf>
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f8e:	e8 09 14 00 00       	call   80239c <sys_enable_interrupt>
	return cnt;
  800f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f96:	c9                   	leave  
  800f97:	c3                   	ret    

00800f98 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	53                   	push   %ebx
  800f9c:	83 ec 14             	sub    $0x14,%esp
  800f9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fab:	8b 45 18             	mov    0x18(%ebp),%eax
  800fae:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fb6:	77 55                	ja     80100d <printnum+0x75>
  800fb8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fbb:	72 05                	jb     800fc2 <printnum+0x2a>
  800fbd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fc0:	77 4b                	ja     80100d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fc2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fc5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800fc8:	8b 45 18             	mov    0x18(%ebp),%eax
  800fcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd0:	52                   	push   %edx
  800fd1:	50                   	push   %eax
  800fd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd5:	ff 75 f0             	pushl  -0x10(%ebp)
  800fd8:	e8 67 2a 00 00       	call   803a44 <__udivdi3>
  800fdd:	83 c4 10             	add    $0x10,%esp
  800fe0:	83 ec 04             	sub    $0x4,%esp
  800fe3:	ff 75 20             	pushl  0x20(%ebp)
  800fe6:	53                   	push   %ebx
  800fe7:	ff 75 18             	pushl  0x18(%ebp)
  800fea:	52                   	push   %edx
  800feb:	50                   	push   %eax
  800fec:	ff 75 0c             	pushl  0xc(%ebp)
  800fef:	ff 75 08             	pushl  0x8(%ebp)
  800ff2:	e8 a1 ff ff ff       	call   800f98 <printnum>
  800ff7:	83 c4 20             	add    $0x20,%esp
  800ffa:	eb 1a                	jmp    801016 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ffc:	83 ec 08             	sub    $0x8,%esp
  800fff:	ff 75 0c             	pushl  0xc(%ebp)
  801002:	ff 75 20             	pushl  0x20(%ebp)
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	ff d0                	call   *%eax
  80100a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80100d:	ff 4d 1c             	decl   0x1c(%ebp)
  801010:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801014:	7f e6                	jg     800ffc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801016:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801019:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801021:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801024:	53                   	push   %ebx
  801025:	51                   	push   %ecx
  801026:	52                   	push   %edx
  801027:	50                   	push   %eax
  801028:	e8 27 2b 00 00       	call   803b54 <__umoddi3>
  80102d:	83 c4 10             	add    $0x10,%esp
  801030:	05 b4 44 80 00       	add    $0x8044b4,%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f be c0             	movsbl %al,%eax
  80103a:	83 ec 08             	sub    $0x8,%esp
  80103d:	ff 75 0c             	pushl  0xc(%ebp)
  801040:	50                   	push   %eax
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	ff d0                	call   *%eax
  801046:	83 c4 10             	add    $0x10,%esp
}
  801049:	90                   	nop
  80104a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801052:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801056:	7e 1c                	jle    801074 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8b 00                	mov    (%eax),%eax
  80105d:	8d 50 08             	lea    0x8(%eax),%edx
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	89 10                	mov    %edx,(%eax)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8b 00                	mov    (%eax),%eax
  80106a:	83 e8 08             	sub    $0x8,%eax
  80106d:	8b 50 04             	mov    0x4(%eax),%edx
  801070:	8b 00                	mov    (%eax),%eax
  801072:	eb 40                	jmp    8010b4 <getuint+0x65>
	else if (lflag)
  801074:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801078:	74 1e                	je     801098 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8b 00                	mov    (%eax),%eax
  80107f:	8d 50 04             	lea    0x4(%eax),%edx
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	89 10                	mov    %edx,(%eax)
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8b 00                	mov    (%eax),%eax
  80108c:	83 e8 04             	sub    $0x4,%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	ba 00 00 00 00       	mov    $0x0,%edx
  801096:	eb 1c                	jmp    8010b4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8b 00                	mov    (%eax),%eax
  80109d:	8d 50 04             	lea    0x4(%eax),%edx
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	89 10                	mov    %edx,(%eax)
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8b 00                	mov    (%eax),%eax
  8010aa:	83 e8 04             	sub    $0x4,%eax
  8010ad:	8b 00                	mov    (%eax),%eax
  8010af:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    

008010b6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010b9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010bd:	7e 1c                	jle    8010db <getint+0x25>
		return va_arg(*ap, long long);
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	8b 00                	mov    (%eax),%eax
  8010c4:	8d 50 08             	lea    0x8(%eax),%edx
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	89 10                	mov    %edx,(%eax)
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	83 e8 08             	sub    $0x8,%eax
  8010d4:	8b 50 04             	mov    0x4(%eax),%edx
  8010d7:	8b 00                	mov    (%eax),%eax
  8010d9:	eb 38                	jmp    801113 <getint+0x5d>
	else if (lflag)
  8010db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010df:	74 1a                	je     8010fb <getint+0x45>
		return va_arg(*ap, long);
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8b 00                	mov    (%eax),%eax
  8010e6:	8d 50 04             	lea    0x4(%eax),%edx
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	89 10                	mov    %edx,(%eax)
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8b 00                	mov    (%eax),%eax
  8010f3:	83 e8 04             	sub    $0x4,%eax
  8010f6:	8b 00                	mov    (%eax),%eax
  8010f8:	99                   	cltd   
  8010f9:	eb 18                	jmp    801113 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8b 00                	mov    (%eax),%eax
  801100:	8d 50 04             	lea    0x4(%eax),%edx
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	89 10                	mov    %edx,(%eax)
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8b 00                	mov    (%eax),%eax
  80110d:	83 e8 04             	sub    $0x4,%eax
  801110:	8b 00                	mov    (%eax),%eax
  801112:	99                   	cltd   
}
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	56                   	push   %esi
  801119:	53                   	push   %ebx
  80111a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80111d:	eb 17                	jmp    801136 <vprintfmt+0x21>
			if (ch == '\0')
  80111f:	85 db                	test   %ebx,%ebx
  801121:	0f 84 af 03 00 00    	je     8014d6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801127:	83 ec 08             	sub    $0x8,%esp
  80112a:	ff 75 0c             	pushl  0xc(%ebp)
  80112d:	53                   	push   %ebx
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	ff d0                	call   *%eax
  801133:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801136:	8b 45 10             	mov    0x10(%ebp),%eax
  801139:	8d 50 01             	lea    0x1(%eax),%edx
  80113c:	89 55 10             	mov    %edx,0x10(%ebp)
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f b6 d8             	movzbl %al,%ebx
  801144:	83 fb 25             	cmp    $0x25,%ebx
  801147:	75 d6                	jne    80111f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801149:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80114d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801154:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80115b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801162:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801169:	8b 45 10             	mov    0x10(%ebp),%eax
  80116c:	8d 50 01             	lea    0x1(%eax),%edx
  80116f:	89 55 10             	mov    %edx,0x10(%ebp)
  801172:	8a 00                	mov    (%eax),%al
  801174:	0f b6 d8             	movzbl %al,%ebx
  801177:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80117a:	83 f8 55             	cmp    $0x55,%eax
  80117d:	0f 87 2b 03 00 00    	ja     8014ae <vprintfmt+0x399>
  801183:	8b 04 85 d8 44 80 00 	mov    0x8044d8(,%eax,4),%eax
  80118a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80118c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801190:	eb d7                	jmp    801169 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801192:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801196:	eb d1                	jmp    801169 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801198:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80119f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011a2:	89 d0                	mov    %edx,%eax
  8011a4:	c1 e0 02             	shl    $0x2,%eax
  8011a7:	01 d0                	add    %edx,%eax
  8011a9:	01 c0                	add    %eax,%eax
  8011ab:	01 d8                	add    %ebx,%eax
  8011ad:	83 e8 30             	sub    $0x30,%eax
  8011b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011bb:	83 fb 2f             	cmp    $0x2f,%ebx
  8011be:	7e 3e                	jle    8011fe <vprintfmt+0xe9>
  8011c0:	83 fb 39             	cmp    $0x39,%ebx
  8011c3:	7f 39                	jg     8011fe <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011c5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011c8:	eb d5                	jmp    80119f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cd:	83 c0 04             	add    $0x4,%eax
  8011d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8011d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d6:	83 e8 04             	sub    $0x4,%eax
  8011d9:	8b 00                	mov    (%eax),%eax
  8011db:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8011de:	eb 1f                	jmp    8011ff <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8011e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011e4:	79 83                	jns    801169 <vprintfmt+0x54>
				width = 0;
  8011e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011ed:	e9 77 ff ff ff       	jmp    801169 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011f2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011f9:	e9 6b ff ff ff       	jmp    801169 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011fe:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801203:	0f 89 60 ff ff ff    	jns    801169 <vprintfmt+0x54>
				width = precision, precision = -1;
  801209:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80120c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80120f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801216:	e9 4e ff ff ff       	jmp    801169 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80121b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80121e:	e9 46 ff ff ff       	jmp    801169 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	83 c0 04             	add    $0x4,%eax
  801229:	89 45 14             	mov    %eax,0x14(%ebp)
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	83 e8 04             	sub    $0x4,%eax
  801232:	8b 00                	mov    (%eax),%eax
  801234:	83 ec 08             	sub    $0x8,%esp
  801237:	ff 75 0c             	pushl  0xc(%ebp)
  80123a:	50                   	push   %eax
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	ff d0                	call   *%eax
  801240:	83 c4 10             	add    $0x10,%esp
			break;
  801243:	e9 89 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801248:	8b 45 14             	mov    0x14(%ebp),%eax
  80124b:	83 c0 04             	add    $0x4,%eax
  80124e:	89 45 14             	mov    %eax,0x14(%ebp)
  801251:	8b 45 14             	mov    0x14(%ebp),%eax
  801254:	83 e8 04             	sub    $0x4,%eax
  801257:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801259:	85 db                	test   %ebx,%ebx
  80125b:	79 02                	jns    80125f <vprintfmt+0x14a>
				err = -err;
  80125d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80125f:	83 fb 64             	cmp    $0x64,%ebx
  801262:	7f 0b                	jg     80126f <vprintfmt+0x15a>
  801264:	8b 34 9d 20 43 80 00 	mov    0x804320(,%ebx,4),%esi
  80126b:	85 f6                	test   %esi,%esi
  80126d:	75 19                	jne    801288 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80126f:	53                   	push   %ebx
  801270:	68 c5 44 80 00       	push   $0x8044c5
  801275:	ff 75 0c             	pushl  0xc(%ebp)
  801278:	ff 75 08             	pushl  0x8(%ebp)
  80127b:	e8 5e 02 00 00       	call   8014de <printfmt>
  801280:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801283:	e9 49 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801288:	56                   	push   %esi
  801289:	68 ce 44 80 00       	push   $0x8044ce
  80128e:	ff 75 0c             	pushl  0xc(%ebp)
  801291:	ff 75 08             	pushl  0x8(%ebp)
  801294:	e8 45 02 00 00       	call   8014de <printfmt>
  801299:	83 c4 10             	add    $0x10,%esp
			break;
  80129c:	e9 30 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a4:	83 c0 04             	add    $0x4,%eax
  8012a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8012aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ad:	83 e8 04             	sub    $0x4,%eax
  8012b0:	8b 30                	mov    (%eax),%esi
  8012b2:	85 f6                	test   %esi,%esi
  8012b4:	75 05                	jne    8012bb <vprintfmt+0x1a6>
				p = "(null)";
  8012b6:	be d1 44 80 00       	mov    $0x8044d1,%esi
			if (width > 0 && padc != '-')
  8012bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012bf:	7e 6d                	jle    80132e <vprintfmt+0x219>
  8012c1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012c5:	74 67                	je     80132e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ca:	83 ec 08             	sub    $0x8,%esp
  8012cd:	50                   	push   %eax
  8012ce:	56                   	push   %esi
  8012cf:	e8 0c 03 00 00       	call   8015e0 <strnlen>
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012da:	eb 16                	jmp    8012f2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012dc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8012e0:	83 ec 08             	sub    $0x8,%esp
  8012e3:	ff 75 0c             	pushl  0xc(%ebp)
  8012e6:	50                   	push   %eax
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	ff d0                	call   *%eax
  8012ec:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ef:	ff 4d e4             	decl   -0x1c(%ebp)
  8012f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012f6:	7f e4                	jg     8012dc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012f8:	eb 34                	jmp    80132e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012fe:	74 1c                	je     80131c <vprintfmt+0x207>
  801300:	83 fb 1f             	cmp    $0x1f,%ebx
  801303:	7e 05                	jle    80130a <vprintfmt+0x1f5>
  801305:	83 fb 7e             	cmp    $0x7e,%ebx
  801308:	7e 12                	jle    80131c <vprintfmt+0x207>
					putch('?', putdat);
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	ff 75 0c             	pushl  0xc(%ebp)
  801310:	6a 3f                	push   $0x3f
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	ff d0                	call   *%eax
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	eb 0f                	jmp    80132b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 0c             	pushl  0xc(%ebp)
  801322:	53                   	push   %ebx
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	ff d0                	call   *%eax
  801328:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80132b:	ff 4d e4             	decl   -0x1c(%ebp)
  80132e:	89 f0                	mov    %esi,%eax
  801330:	8d 70 01             	lea    0x1(%eax),%esi
  801333:	8a 00                	mov    (%eax),%al
  801335:	0f be d8             	movsbl %al,%ebx
  801338:	85 db                	test   %ebx,%ebx
  80133a:	74 24                	je     801360 <vprintfmt+0x24b>
  80133c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801340:	78 b8                	js     8012fa <vprintfmt+0x1e5>
  801342:	ff 4d e0             	decl   -0x20(%ebp)
  801345:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801349:	79 af                	jns    8012fa <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80134b:	eb 13                	jmp    801360 <vprintfmt+0x24b>
				putch(' ', putdat);
  80134d:	83 ec 08             	sub    $0x8,%esp
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	6a 20                	push   $0x20
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	ff d0                	call   *%eax
  80135a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80135d:	ff 4d e4             	decl   -0x1c(%ebp)
  801360:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801364:	7f e7                	jg     80134d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801366:	e9 66 01 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80136b:	83 ec 08             	sub    $0x8,%esp
  80136e:	ff 75 e8             	pushl  -0x18(%ebp)
  801371:	8d 45 14             	lea    0x14(%ebp),%eax
  801374:	50                   	push   %eax
  801375:	e8 3c fd ff ff       	call   8010b6 <getint>
  80137a:	83 c4 10             	add    $0x10,%esp
  80137d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801380:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801386:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801389:	85 d2                	test   %edx,%edx
  80138b:	79 23                	jns    8013b0 <vprintfmt+0x29b>
				putch('-', putdat);
  80138d:	83 ec 08             	sub    $0x8,%esp
  801390:	ff 75 0c             	pushl  0xc(%ebp)
  801393:	6a 2d                	push   $0x2d
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	ff d0                	call   *%eax
  80139a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80139d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a3:	f7 d8                	neg    %eax
  8013a5:	83 d2 00             	adc    $0x0,%edx
  8013a8:	f7 da                	neg    %edx
  8013aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013b0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013b7:	e9 bc 00 00 00       	jmp    801478 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013bc:	83 ec 08             	sub    $0x8,%esp
  8013bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8013c2:	8d 45 14             	lea    0x14(%ebp),%eax
  8013c5:	50                   	push   %eax
  8013c6:	e8 84 fc ff ff       	call   80104f <getuint>
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013d4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013db:	e9 98 00 00 00       	jmp    801478 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8013e0:	83 ec 08             	sub    $0x8,%esp
  8013e3:	ff 75 0c             	pushl  0xc(%ebp)
  8013e6:	6a 58                	push   $0x58
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	ff d0                	call   *%eax
  8013ed:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013f0:	83 ec 08             	sub    $0x8,%esp
  8013f3:	ff 75 0c             	pushl  0xc(%ebp)
  8013f6:	6a 58                	push   $0x58
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	ff d0                	call   *%eax
  8013fd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	ff 75 0c             	pushl  0xc(%ebp)
  801406:	6a 58                	push   $0x58
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	ff d0                	call   *%eax
  80140d:	83 c4 10             	add    $0x10,%esp
			break;
  801410:	e9 bc 00 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801415:	83 ec 08             	sub    $0x8,%esp
  801418:	ff 75 0c             	pushl  0xc(%ebp)
  80141b:	6a 30                	push   $0x30
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	ff d0                	call   *%eax
  801422:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801425:	83 ec 08             	sub    $0x8,%esp
  801428:	ff 75 0c             	pushl  0xc(%ebp)
  80142b:	6a 78                	push   $0x78
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	ff d0                	call   *%eax
  801432:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801435:	8b 45 14             	mov    0x14(%ebp),%eax
  801438:	83 c0 04             	add    $0x4,%eax
  80143b:	89 45 14             	mov    %eax,0x14(%ebp)
  80143e:	8b 45 14             	mov    0x14(%ebp),%eax
  801441:	83 e8 04             	sub    $0x4,%eax
  801444:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801446:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801449:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801450:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801457:	eb 1f                	jmp    801478 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	ff 75 e8             	pushl  -0x18(%ebp)
  80145f:	8d 45 14             	lea    0x14(%ebp),%eax
  801462:	50                   	push   %eax
  801463:	e8 e7 fb ff ff       	call   80104f <getuint>
  801468:	83 c4 10             	add    $0x10,%esp
  80146b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80146e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801471:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801478:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80147c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	52                   	push   %edx
  801483:	ff 75 e4             	pushl  -0x1c(%ebp)
  801486:	50                   	push   %eax
  801487:	ff 75 f4             	pushl  -0xc(%ebp)
  80148a:	ff 75 f0             	pushl  -0x10(%ebp)
  80148d:	ff 75 0c             	pushl  0xc(%ebp)
  801490:	ff 75 08             	pushl  0x8(%ebp)
  801493:	e8 00 fb ff ff       	call   800f98 <printnum>
  801498:	83 c4 20             	add    $0x20,%esp
			break;
  80149b:	eb 34                	jmp    8014d1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80149d:	83 ec 08             	sub    $0x8,%esp
  8014a0:	ff 75 0c             	pushl  0xc(%ebp)
  8014a3:	53                   	push   %ebx
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	ff d0                	call   *%eax
  8014a9:	83 c4 10             	add    $0x10,%esp
			break;
  8014ac:	eb 23                	jmp    8014d1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014ae:	83 ec 08             	sub    $0x8,%esp
  8014b1:	ff 75 0c             	pushl  0xc(%ebp)
  8014b4:	6a 25                	push   $0x25
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	ff d0                	call   *%eax
  8014bb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014be:	ff 4d 10             	decl   0x10(%ebp)
  8014c1:	eb 03                	jmp    8014c6 <vprintfmt+0x3b1>
  8014c3:	ff 4d 10             	decl   0x10(%ebp)
  8014c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c9:	48                   	dec    %eax
  8014ca:	8a 00                	mov    (%eax),%al
  8014cc:	3c 25                	cmp    $0x25,%al
  8014ce:	75 f3                	jne    8014c3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014d0:	90                   	nop
		}
	}
  8014d1:	e9 47 fc ff ff       	jmp    80111d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014d6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014da:	5b                   	pop    %ebx
  8014db:	5e                   	pop    %esi
  8014dc:	5d                   	pop    %ebp
  8014dd:	c3                   	ret    

008014de <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014e4:	8d 45 10             	lea    0x10(%ebp),%eax
  8014e7:	83 c0 04             	add    $0x4,%eax
  8014ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f3:	50                   	push   %eax
  8014f4:	ff 75 0c             	pushl  0xc(%ebp)
  8014f7:	ff 75 08             	pushl  0x8(%ebp)
  8014fa:	e8 16 fc ff ff       	call   801115 <vprintfmt>
  8014ff:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801502:	90                   	nop
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	8b 40 08             	mov    0x8(%eax),%eax
  80150e:	8d 50 01             	lea    0x1(%eax),%edx
  801511:	8b 45 0c             	mov    0xc(%ebp),%eax
  801514:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151a:	8b 10                	mov    (%eax),%edx
  80151c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151f:	8b 40 04             	mov    0x4(%eax),%eax
  801522:	39 c2                	cmp    %eax,%edx
  801524:	73 12                	jae    801538 <sprintputch+0x33>
		*b->buf++ = ch;
  801526:	8b 45 0c             	mov    0xc(%ebp),%eax
  801529:	8b 00                	mov    (%eax),%eax
  80152b:	8d 48 01             	lea    0x1(%eax),%ecx
  80152e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801531:	89 0a                	mov    %ecx,(%edx)
  801533:	8b 55 08             	mov    0x8(%ebp),%edx
  801536:	88 10                	mov    %dl,(%eax)
}
  801538:	90                   	nop
  801539:	5d                   	pop    %ebp
  80153a:	c3                   	ret    

0080153b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	01 d0                	add    %edx,%eax
  801552:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801555:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80155c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801560:	74 06                	je     801568 <vsnprintf+0x2d>
  801562:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801566:	7f 07                	jg     80156f <vsnprintf+0x34>
		return -E_INVAL;
  801568:	b8 03 00 00 00       	mov    $0x3,%eax
  80156d:	eb 20                	jmp    80158f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80156f:	ff 75 14             	pushl  0x14(%ebp)
  801572:	ff 75 10             	pushl  0x10(%ebp)
  801575:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801578:	50                   	push   %eax
  801579:	68 05 15 80 00       	push   $0x801505
  80157e:	e8 92 fb ff ff       	call   801115 <vprintfmt>
  801583:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801586:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801589:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80158c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801597:	8d 45 10             	lea    0x10(%ebp),%eax
  80159a:	83 c0 04             	add    $0x4,%eax
  80159d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a6:	50                   	push   %eax
  8015a7:	ff 75 0c             	pushl  0xc(%ebp)
  8015aa:	ff 75 08             	pushl  0x8(%ebp)
  8015ad:	e8 89 ff ff ff       	call   80153b <vsnprintf>
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ca:	eb 06                	jmp    8015d2 <strlen+0x15>
		n++;
  8015cc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015cf:	ff 45 08             	incl   0x8(%ebp)
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	8a 00                	mov    (%eax),%al
  8015d7:	84 c0                	test   %al,%al
  8015d9:	75 f1                	jne    8015cc <strlen+0xf>
		n++;
	return n;
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ed:	eb 09                	jmp    8015f8 <strnlen+0x18>
		n++;
  8015ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015f2:	ff 45 08             	incl   0x8(%ebp)
  8015f5:	ff 4d 0c             	decl   0xc(%ebp)
  8015f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015fc:	74 09                	je     801607 <strnlen+0x27>
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8a 00                	mov    (%eax),%al
  801603:	84 c0                	test   %al,%al
  801605:	75 e8                	jne    8015ef <strnlen+0xf>
		n++;
	return n;
  801607:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801618:	90                   	nop
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	8d 50 01             	lea    0x1(%eax),%edx
  80161f:	89 55 08             	mov    %edx,0x8(%ebp)
  801622:	8b 55 0c             	mov    0xc(%ebp),%edx
  801625:	8d 4a 01             	lea    0x1(%edx),%ecx
  801628:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80162b:	8a 12                	mov    (%edx),%dl
  80162d:	88 10                	mov    %dl,(%eax)
  80162f:	8a 00                	mov    (%eax),%al
  801631:	84 c0                	test   %al,%al
  801633:	75 e4                	jne    801619 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801635:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801646:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80164d:	eb 1f                	jmp    80166e <strncpy+0x34>
		*dst++ = *src;
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8d 50 01             	lea    0x1(%eax),%edx
  801655:	89 55 08             	mov    %edx,0x8(%ebp)
  801658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165b:	8a 12                	mov    (%edx),%dl
  80165d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80165f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801662:	8a 00                	mov    (%eax),%al
  801664:	84 c0                	test   %al,%al
  801666:	74 03                	je     80166b <strncpy+0x31>
			src++;
  801668:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80166b:	ff 45 fc             	incl   -0x4(%ebp)
  80166e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801671:	3b 45 10             	cmp    0x10(%ebp),%eax
  801674:	72 d9                	jb     80164f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801676:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801687:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80168b:	74 30                	je     8016bd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80168d:	eb 16                	jmp    8016a5 <strlcpy+0x2a>
			*dst++ = *src++;
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8d 50 01             	lea    0x1(%eax),%edx
  801695:	89 55 08             	mov    %edx,0x8(%ebp)
  801698:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80169e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016a1:	8a 12                	mov    (%edx),%dl
  8016a3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016a5:	ff 4d 10             	decl   0x10(%ebp)
  8016a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ac:	74 09                	je     8016b7 <strlcpy+0x3c>
  8016ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	84 c0                	test   %al,%al
  8016b5:	75 d8                	jne    80168f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c3:	29 c2                	sub    %eax,%edx
  8016c5:	89 d0                	mov    %edx,%eax
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016cc:	eb 06                	jmp    8016d4 <strcmp+0xb>
		p++, q++;
  8016ce:	ff 45 08             	incl   0x8(%ebp)
  8016d1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	8a 00                	mov    (%eax),%al
  8016d9:	84 c0                	test   %al,%al
  8016db:	74 0e                	je     8016eb <strcmp+0x22>
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	8a 10                	mov    (%eax),%dl
  8016e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e5:	8a 00                	mov    (%eax),%al
  8016e7:	38 c2                	cmp    %al,%dl
  8016e9:	74 e3                	je     8016ce <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	0f b6 d0             	movzbl %al,%edx
  8016f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f6:	8a 00                	mov    (%eax),%al
  8016f8:	0f b6 c0             	movzbl %al,%eax
  8016fb:	29 c2                	sub    %eax,%edx
  8016fd:	89 d0                	mov    %edx,%eax
}
  8016ff:	5d                   	pop    %ebp
  801700:	c3                   	ret    

00801701 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801704:	eb 09                	jmp    80170f <strncmp+0xe>
		n--, p++, q++;
  801706:	ff 4d 10             	decl   0x10(%ebp)
  801709:	ff 45 08             	incl   0x8(%ebp)
  80170c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80170f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801713:	74 17                	je     80172c <strncmp+0x2b>
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	84 c0                	test   %al,%al
  80171c:	74 0e                	je     80172c <strncmp+0x2b>
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8a 10                	mov    (%eax),%dl
  801723:	8b 45 0c             	mov    0xc(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	38 c2                	cmp    %al,%dl
  80172a:	74 da                	je     801706 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80172c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801730:	75 07                	jne    801739 <strncmp+0x38>
		return 0;
  801732:	b8 00 00 00 00       	mov    $0x0,%eax
  801737:	eb 14                	jmp    80174d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	8a 00                	mov    (%eax),%al
  80173e:	0f b6 d0             	movzbl %al,%edx
  801741:	8b 45 0c             	mov    0xc(%ebp),%eax
  801744:	8a 00                	mov    (%eax),%al
  801746:	0f b6 c0             	movzbl %al,%eax
  801749:	29 c2                	sub    %eax,%edx
  80174b:	89 d0                	mov    %edx,%eax
}
  80174d:	5d                   	pop    %ebp
  80174e:	c3                   	ret    

0080174f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	8b 45 0c             	mov    0xc(%ebp),%eax
  801758:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80175b:	eb 12                	jmp    80176f <strchr+0x20>
		if (*s == c)
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8a 00                	mov    (%eax),%al
  801762:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801765:	75 05                	jne    80176c <strchr+0x1d>
			return (char *) s;
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	eb 11                	jmp    80177d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80176c:	ff 45 08             	incl   0x8(%ebp)
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	84 c0                	test   %al,%al
  801776:	75 e5                	jne    80175d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801778:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	8b 45 0c             	mov    0xc(%ebp),%eax
  801788:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80178b:	eb 0d                	jmp    80179a <strfind+0x1b>
		if (*s == c)
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	8a 00                	mov    (%eax),%al
  801792:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801795:	74 0e                	je     8017a5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801797:	ff 45 08             	incl   0x8(%ebp)
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	8a 00                	mov    (%eax),%al
  80179f:	84 c0                	test   %al,%al
  8017a1:	75 ea                	jne    80178d <strfind+0xe>
  8017a3:	eb 01                	jmp    8017a6 <strfind+0x27>
		if (*s == c)
			break;
  8017a5:	90                   	nop
	return (char *) s;
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017bd:	eb 0e                	jmp    8017cd <memset+0x22>
		*p++ = c;
  8017bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017c2:	8d 50 01             	lea    0x1(%eax),%edx
  8017c5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017cd:	ff 4d f8             	decl   -0x8(%ebp)
  8017d0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017d4:	79 e9                	jns    8017bf <memset+0x14>
		*p++ = c;

	return v;
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017ed:	eb 16                	jmp    801805 <memcpy+0x2a>
		*d++ = *s++;
  8017ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f2:	8d 50 01             	lea    0x1(%eax),%edx
  8017f5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017fe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801801:	8a 12                	mov    (%edx),%dl
  801803:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801805:	8b 45 10             	mov    0x10(%ebp),%eax
  801808:	8d 50 ff             	lea    -0x1(%eax),%edx
  80180b:	89 55 10             	mov    %edx,0x10(%ebp)
  80180e:	85 c0                	test   %eax,%eax
  801810:	75 dd                	jne    8017ef <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80181d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801820:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801829:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80182f:	73 50                	jae    801881 <memmove+0x6a>
  801831:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801834:	8b 45 10             	mov    0x10(%ebp),%eax
  801837:	01 d0                	add    %edx,%eax
  801839:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80183c:	76 43                	jbe    801881 <memmove+0x6a>
		s += n;
  80183e:	8b 45 10             	mov    0x10(%ebp),%eax
  801841:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801844:	8b 45 10             	mov    0x10(%ebp),%eax
  801847:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80184a:	eb 10                	jmp    80185c <memmove+0x45>
			*--d = *--s;
  80184c:	ff 4d f8             	decl   -0x8(%ebp)
  80184f:	ff 4d fc             	decl   -0x4(%ebp)
  801852:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801855:	8a 10                	mov    (%eax),%dl
  801857:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80185c:	8b 45 10             	mov    0x10(%ebp),%eax
  80185f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801862:	89 55 10             	mov    %edx,0x10(%ebp)
  801865:	85 c0                	test   %eax,%eax
  801867:	75 e3                	jne    80184c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801869:	eb 23                	jmp    80188e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80186b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186e:	8d 50 01             	lea    0x1(%eax),%edx
  801871:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801874:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801877:	8d 4a 01             	lea    0x1(%edx),%ecx
  80187a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80187d:	8a 12                	mov    (%edx),%dl
  80187f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	8d 50 ff             	lea    -0x1(%eax),%edx
  801887:	89 55 10             	mov    %edx,0x10(%ebp)
  80188a:	85 c0                	test   %eax,%eax
  80188c:	75 dd                	jne    80186b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80189f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018a5:	eb 2a                	jmp    8018d1 <memcmp+0x3e>
		if (*s1 != *s2)
  8018a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018aa:	8a 10                	mov    (%eax),%dl
  8018ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018af:	8a 00                	mov    (%eax),%al
  8018b1:	38 c2                	cmp    %al,%dl
  8018b3:	74 16                	je     8018cb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	0f b6 d0             	movzbl %al,%edx
  8018bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c0:	8a 00                	mov    (%eax),%al
  8018c2:	0f b6 c0             	movzbl %al,%eax
  8018c5:	29 c2                	sub    %eax,%edx
  8018c7:	89 d0                	mov    %edx,%eax
  8018c9:	eb 18                	jmp    8018e3 <memcmp+0x50>
		s1++, s2++;
  8018cb:	ff 45 fc             	incl   -0x4(%ebp)
  8018ce:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	75 c9                	jne    8018a7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f1:	01 d0                	add    %edx,%eax
  8018f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018f6:	eb 15                	jmp    80190d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	8a 00                	mov    (%eax),%al
  8018fd:	0f b6 d0             	movzbl %al,%edx
  801900:	8b 45 0c             	mov    0xc(%ebp),%eax
  801903:	0f b6 c0             	movzbl %al,%eax
  801906:	39 c2                	cmp    %eax,%edx
  801908:	74 0d                	je     801917 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80190a:	ff 45 08             	incl   0x8(%ebp)
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801913:	72 e3                	jb     8018f8 <memfind+0x13>
  801915:	eb 01                	jmp    801918 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801917:	90                   	nop
	return (void *) s;
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801923:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80192a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801931:	eb 03                	jmp    801936 <strtol+0x19>
		s++;
  801933:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	8a 00                	mov    (%eax),%al
  80193b:	3c 20                	cmp    $0x20,%al
  80193d:	74 f4                	je     801933 <strtol+0x16>
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	8a 00                	mov    (%eax),%al
  801944:	3c 09                	cmp    $0x9,%al
  801946:	74 eb                	je     801933 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	8a 00                	mov    (%eax),%al
  80194d:	3c 2b                	cmp    $0x2b,%al
  80194f:	75 05                	jne    801956 <strtol+0x39>
		s++;
  801951:	ff 45 08             	incl   0x8(%ebp)
  801954:	eb 13                	jmp    801969 <strtol+0x4c>
	else if (*s == '-')
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	8a 00                	mov    (%eax),%al
  80195b:	3c 2d                	cmp    $0x2d,%al
  80195d:	75 0a                	jne    801969 <strtol+0x4c>
		s++, neg = 1;
  80195f:	ff 45 08             	incl   0x8(%ebp)
  801962:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801969:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196d:	74 06                	je     801975 <strtol+0x58>
  80196f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801973:	75 20                	jne    801995 <strtol+0x78>
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	8a 00                	mov    (%eax),%al
  80197a:	3c 30                	cmp    $0x30,%al
  80197c:	75 17                	jne    801995 <strtol+0x78>
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	40                   	inc    %eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	3c 78                	cmp    $0x78,%al
  801986:	75 0d                	jne    801995 <strtol+0x78>
		s += 2, base = 16;
  801988:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80198c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801993:	eb 28                	jmp    8019bd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801995:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801999:	75 15                	jne    8019b0 <strtol+0x93>
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	8a 00                	mov    (%eax),%al
  8019a0:	3c 30                	cmp    $0x30,%al
  8019a2:	75 0c                	jne    8019b0 <strtol+0x93>
		s++, base = 8;
  8019a4:	ff 45 08             	incl   0x8(%ebp)
  8019a7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019ae:	eb 0d                	jmp    8019bd <strtol+0xa0>
	else if (base == 0)
  8019b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019b4:	75 07                	jne    8019bd <strtol+0xa0>
		base = 10;
  8019b6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	8a 00                	mov    (%eax),%al
  8019c2:	3c 2f                	cmp    $0x2f,%al
  8019c4:	7e 19                	jle    8019df <strtol+0xc2>
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	8a 00                	mov    (%eax),%al
  8019cb:	3c 39                	cmp    $0x39,%al
  8019cd:	7f 10                	jg     8019df <strtol+0xc2>
			dig = *s - '0';
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	8a 00                	mov    (%eax),%al
  8019d4:	0f be c0             	movsbl %al,%eax
  8019d7:	83 e8 30             	sub    $0x30,%eax
  8019da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019dd:	eb 42                	jmp    801a21 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	8a 00                	mov    (%eax),%al
  8019e4:	3c 60                	cmp    $0x60,%al
  8019e6:	7e 19                	jle    801a01 <strtol+0xe4>
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	8a 00                	mov    (%eax),%al
  8019ed:	3c 7a                	cmp    $0x7a,%al
  8019ef:	7f 10                	jg     801a01 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	8a 00                	mov    (%eax),%al
  8019f6:	0f be c0             	movsbl %al,%eax
  8019f9:	83 e8 57             	sub    $0x57,%eax
  8019fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019ff:	eb 20                	jmp    801a21 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8a 00                	mov    (%eax),%al
  801a06:	3c 40                	cmp    $0x40,%al
  801a08:	7e 39                	jle    801a43 <strtol+0x126>
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8a 00                	mov    (%eax),%al
  801a0f:	3c 5a                	cmp    $0x5a,%al
  801a11:	7f 30                	jg     801a43 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	8a 00                	mov    (%eax),%al
  801a18:	0f be c0             	movsbl %al,%eax
  801a1b:	83 e8 37             	sub    $0x37,%eax
  801a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a24:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a27:	7d 19                	jge    801a42 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a29:	ff 45 08             	incl   0x8(%ebp)
  801a2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a33:	89 c2                	mov    %eax,%edx
  801a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a38:	01 d0                	add    %edx,%eax
  801a3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a3d:	e9 7b ff ff ff       	jmp    8019bd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a42:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a47:	74 08                	je     801a51 <strtol+0x134>
		*endptr = (char *) s;
  801a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4c:	8b 55 08             	mov    0x8(%ebp),%edx
  801a4f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a51:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a55:	74 07                	je     801a5e <strtol+0x141>
  801a57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5a:	f7 d8                	neg    %eax
  801a5c:	eb 03                	jmp    801a61 <strtol+0x144>
  801a5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <ltostr>:

void
ltostr(long value, char *str)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a70:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a7b:	79 13                	jns    801a90 <ltostr+0x2d>
	{
		neg = 1;
  801a7d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a87:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a8a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a8d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a98:	99                   	cltd   
  801a99:	f7 f9                	idiv   %ecx
  801a9b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa1:	8d 50 01             	lea    0x1(%eax),%edx
  801aa4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aa7:	89 c2                	mov    %eax,%edx
  801aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aac:	01 d0                	add    %edx,%eax
  801aae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ab1:	83 c2 30             	add    $0x30,%edx
  801ab4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ab6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801abe:	f7 e9                	imul   %ecx
  801ac0:	c1 fa 02             	sar    $0x2,%edx
  801ac3:	89 c8                	mov    %ecx,%eax
  801ac5:	c1 f8 1f             	sar    $0x1f,%eax
  801ac8:	29 c2                	sub    %eax,%edx
  801aca:	89 d0                	mov    %edx,%eax
  801acc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ad2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ad7:	f7 e9                	imul   %ecx
  801ad9:	c1 fa 02             	sar    $0x2,%edx
  801adc:	89 c8                	mov    %ecx,%eax
  801ade:	c1 f8 1f             	sar    $0x1f,%eax
  801ae1:	29 c2                	sub    %eax,%edx
  801ae3:	89 d0                	mov    %edx,%eax
  801ae5:	c1 e0 02             	shl    $0x2,%eax
  801ae8:	01 d0                	add    %edx,%eax
  801aea:	01 c0                	add    %eax,%eax
  801aec:	29 c1                	sub    %eax,%ecx
  801aee:	89 ca                	mov    %ecx,%edx
  801af0:	85 d2                	test   %edx,%edx
  801af2:	75 9c                	jne    801a90 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801af4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801afb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afe:	48                   	dec    %eax
  801aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b02:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b06:	74 3d                	je     801b45 <ltostr+0xe2>
		start = 1 ;
  801b08:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b0f:	eb 34                	jmp    801b45 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b17:	01 d0                	add    %edx,%eax
  801b19:	8a 00                	mov    (%eax),%al
  801b1b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b24:	01 c2                	add    %eax,%edx
  801b26:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2c:	01 c8                	add    %ecx,%eax
  801b2e:	8a 00                	mov    (%eax),%al
  801b30:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b38:	01 c2                	add    %eax,%edx
  801b3a:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b3d:	88 02                	mov    %al,(%edx)
		start++ ;
  801b3f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b42:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b48:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b4b:	7c c4                	jl     801b11 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b4d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b53:	01 d0                	add    %edx,%eax
  801b55:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b58:	90                   	nop
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b61:	ff 75 08             	pushl  0x8(%ebp)
  801b64:	e8 54 fa ff ff       	call   8015bd <strlen>
  801b69:	83 c4 04             	add    $0x4,%esp
  801b6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	e8 46 fa ff ff       	call   8015bd <strlen>
  801b77:	83 c4 04             	add    $0x4,%esp
  801b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b8b:	eb 17                	jmp    801ba4 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b8d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b90:	8b 45 10             	mov    0x10(%ebp),%eax
  801b93:	01 c2                	add    %eax,%edx
  801b95:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	01 c8                	add    %ecx,%eax
  801b9d:	8a 00                	mov    (%eax),%al
  801b9f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ba1:	ff 45 fc             	incl   -0x4(%ebp)
  801ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ba7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801baa:	7c e1                	jl     801b8d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bb3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bba:	eb 1f                	jmp    801bdb <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bbf:	8d 50 01             	lea    0x1(%eax),%edx
  801bc2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bc5:	89 c2                	mov    %eax,%edx
  801bc7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bca:	01 c2                	add    %eax,%edx
  801bcc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd2:	01 c8                	add    %ecx,%eax
  801bd4:	8a 00                	mov    (%eax),%al
  801bd6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bd8:	ff 45 f8             	incl   -0x8(%ebp)
  801bdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bde:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801be1:	7c d9                	jl     801bbc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801be3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be6:	8b 45 10             	mov    0x10(%ebp),%eax
  801be9:	01 d0                	add    %edx,%eax
  801beb:	c6 00 00             	movb   $0x0,(%eax)
}
  801bee:	90                   	nop
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bf4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bfd:	8b 45 14             	mov    0x14(%ebp),%eax
  801c00:	8b 00                	mov    (%eax),%eax
  801c02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c09:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c14:	eb 0c                	jmp    801c22 <strsplit+0x31>
			*string++ = 0;
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	8d 50 01             	lea    0x1(%eax),%edx
  801c1c:	89 55 08             	mov    %edx,0x8(%ebp)
  801c1f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	8a 00                	mov    (%eax),%al
  801c27:	84 c0                	test   %al,%al
  801c29:	74 18                	je     801c43 <strsplit+0x52>
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	8a 00                	mov    (%eax),%al
  801c30:	0f be c0             	movsbl %al,%eax
  801c33:	50                   	push   %eax
  801c34:	ff 75 0c             	pushl  0xc(%ebp)
  801c37:	e8 13 fb ff ff       	call   80174f <strchr>
  801c3c:	83 c4 08             	add    $0x8,%esp
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	75 d3                	jne    801c16 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	8a 00                	mov    (%eax),%al
  801c48:	84 c0                	test   %al,%al
  801c4a:	74 5a                	je     801ca6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4f:	8b 00                	mov    (%eax),%eax
  801c51:	83 f8 0f             	cmp    $0xf,%eax
  801c54:	75 07                	jne    801c5d <strsplit+0x6c>
		{
			return 0;
  801c56:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5b:	eb 66                	jmp    801cc3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c60:	8b 00                	mov    (%eax),%eax
  801c62:	8d 48 01             	lea    0x1(%eax),%ecx
  801c65:	8b 55 14             	mov    0x14(%ebp),%edx
  801c68:	89 0a                	mov    %ecx,(%edx)
  801c6a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c71:	8b 45 10             	mov    0x10(%ebp),%eax
  801c74:	01 c2                	add    %eax,%edx
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c7b:	eb 03                	jmp    801c80 <strsplit+0x8f>
			string++;
  801c7d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	8a 00                	mov    (%eax),%al
  801c85:	84 c0                	test   %al,%al
  801c87:	74 8b                	je     801c14 <strsplit+0x23>
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	8a 00                	mov    (%eax),%al
  801c8e:	0f be c0             	movsbl %al,%eax
  801c91:	50                   	push   %eax
  801c92:	ff 75 0c             	pushl  0xc(%ebp)
  801c95:	e8 b5 fa ff ff       	call   80174f <strchr>
  801c9a:	83 c4 08             	add    $0x8,%esp
  801c9d:	85 c0                	test   %eax,%eax
  801c9f:	74 dc                	je     801c7d <strsplit+0x8c>
			string++;
	}
  801ca1:	e9 6e ff ff ff       	jmp    801c14 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ca6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  801caa:	8b 00                	mov    (%eax),%eax
  801cac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb6:	01 d0                	add    %edx,%eax
  801cb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801cbe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801ccb:	a1 04 50 80 00       	mov    0x805004,%eax
  801cd0:	85 c0                	test   %eax,%eax
  801cd2:	74 1f                	je     801cf3 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801cd4:	e8 1d 00 00 00       	call   801cf6 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801cd9:	83 ec 0c             	sub    $0xc,%esp
  801cdc:	68 30 46 80 00       	push   $0x804630
  801ce1:	e8 55 f2 ff ff       	call   800f3b <cprintf>
  801ce6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801ce9:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801cf0:	00 00 00 
	}
}
  801cf3:	90                   	nop
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801cfc:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801d03:	00 00 00 
  801d06:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801d0d:	00 00 00 
  801d10:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801d17:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801d1a:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801d21:	00 00 00 
  801d24:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801d2b:	00 00 00 
  801d2e:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801d35:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801d38:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801d3f:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801d42:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d51:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d56:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801d5b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d62:	a1 20 51 80 00       	mov    0x805120,%eax
  801d67:	c1 e0 04             	shl    $0x4,%eax
  801d6a:	89 c2                	mov    %eax,%edx
  801d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d6f:	01 d0                	add    %edx,%eax
  801d71:	48                   	dec    %eax
  801d72:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d78:	ba 00 00 00 00       	mov    $0x0,%edx
  801d7d:	f7 75 f0             	divl   -0x10(%ebp)
  801d80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d83:	29 d0                	sub    %edx,%eax
  801d85:	89 c2                	mov    %eax,%edx
  801d87:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801d8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d91:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d96:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d9b:	83 ec 04             	sub    $0x4,%esp
  801d9e:	6a 06                	push   $0x6
  801da0:	52                   	push   %edx
  801da1:	50                   	push   %eax
  801da2:	e8 71 05 00 00       	call   802318 <sys_allocate_chunk>
  801da7:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801daa:	a1 20 51 80 00       	mov    0x805120,%eax
  801daf:	83 ec 0c             	sub    $0xc,%esp
  801db2:	50                   	push   %eax
  801db3:	e8 e6 0b 00 00       	call   80299e <initialize_MemBlocksList>
  801db8:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801dbb:	a1 48 51 80 00       	mov    0x805148,%eax
  801dc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801dc3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801dc7:	75 14                	jne    801ddd <initialize_dyn_block_system+0xe7>
  801dc9:	83 ec 04             	sub    $0x4,%esp
  801dcc:	68 55 46 80 00       	push   $0x804655
  801dd1:	6a 2b                	push   $0x2b
  801dd3:	68 73 46 80 00       	push   $0x804673
  801dd8:	e8 aa ee ff ff       	call   800c87 <_panic>
  801ddd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801de0:	8b 00                	mov    (%eax),%eax
  801de2:	85 c0                	test   %eax,%eax
  801de4:	74 10                	je     801df6 <initialize_dyn_block_system+0x100>
  801de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801de9:	8b 00                	mov    (%eax),%eax
  801deb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801dee:	8b 52 04             	mov    0x4(%edx),%edx
  801df1:	89 50 04             	mov    %edx,0x4(%eax)
  801df4:	eb 0b                	jmp    801e01 <initialize_dyn_block_system+0x10b>
  801df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801df9:	8b 40 04             	mov    0x4(%eax),%eax
  801dfc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801e01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e04:	8b 40 04             	mov    0x4(%eax),%eax
  801e07:	85 c0                	test   %eax,%eax
  801e09:	74 0f                	je     801e1a <initialize_dyn_block_system+0x124>
  801e0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e0e:	8b 40 04             	mov    0x4(%eax),%eax
  801e11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e14:	8b 12                	mov    (%edx),%edx
  801e16:	89 10                	mov    %edx,(%eax)
  801e18:	eb 0a                	jmp    801e24 <initialize_dyn_block_system+0x12e>
  801e1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e1d:	8b 00                	mov    (%eax),%eax
  801e1f:	a3 48 51 80 00       	mov    %eax,0x805148
  801e24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e37:	a1 54 51 80 00       	mov    0x805154,%eax
  801e3c:	48                   	dec    %eax
  801e3d:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801e42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e45:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801e4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e4f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801e56:	83 ec 0c             	sub    $0xc,%esp
  801e59:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e5c:	e8 d2 13 00 00       	call   803233 <insert_sorted_with_merge_freeList>
  801e61:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801e64:	90                   	nop
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    

00801e67 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
  801e6a:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e6d:	e8 53 fe ff ff       	call   801cc5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e76:	75 07                	jne    801e7f <malloc+0x18>
  801e78:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7d:	eb 61                	jmp    801ee0 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801e7f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e86:	8b 55 08             	mov    0x8(%ebp),%edx
  801e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8c:	01 d0                	add    %edx,%eax
  801e8e:	48                   	dec    %eax
  801e8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e95:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9a:	f7 75 f4             	divl   -0xc(%ebp)
  801e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea0:	29 d0                	sub    %edx,%eax
  801ea2:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ea5:	e8 3c 08 00 00       	call   8026e6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801eaa:	85 c0                	test   %eax,%eax
  801eac:	74 2d                	je     801edb <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801eae:	83 ec 0c             	sub    $0xc,%esp
  801eb1:	ff 75 08             	pushl  0x8(%ebp)
  801eb4:	e8 3e 0f 00 00       	call   802df7 <alloc_block_FF>
  801eb9:	83 c4 10             	add    $0x10,%esp
  801ebc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801ebf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ec3:	74 16                	je     801edb <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801ec5:	83 ec 0c             	sub    $0xc,%esp
  801ec8:	ff 75 ec             	pushl  -0x14(%ebp)
  801ecb:	e8 48 0c 00 00       	call   802b18 <insert_sorted_allocList>
  801ed0:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801ed3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed6:	8b 40 08             	mov    0x8(%eax),%eax
  801ed9:	eb 05                	jmp    801ee0 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801edb:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ef6:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	83 ec 08             	sub    $0x8,%esp
  801eff:	50                   	push   %eax
  801f00:	68 40 50 80 00       	push   $0x805040
  801f05:	e8 71 0b 00 00       	call   802a7b <find_block>
  801f0a:	83 c4 10             	add    $0x10,%esp
  801f0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f13:	8b 50 0c             	mov    0xc(%eax),%edx
  801f16:	8b 45 08             	mov    0x8(%ebp),%eax
  801f19:	83 ec 08             	sub    $0x8,%esp
  801f1c:	52                   	push   %edx
  801f1d:	50                   	push   %eax
  801f1e:	e8 bd 03 00 00       	call   8022e0 <sys_free_user_mem>
  801f23:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801f26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f2a:	75 14                	jne    801f40 <free+0x5e>
  801f2c:	83 ec 04             	sub    $0x4,%esp
  801f2f:	68 55 46 80 00       	push   $0x804655
  801f34:	6a 71                	push   $0x71
  801f36:	68 73 46 80 00       	push   $0x804673
  801f3b:	e8 47 ed ff ff       	call   800c87 <_panic>
  801f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f43:	8b 00                	mov    (%eax),%eax
  801f45:	85 c0                	test   %eax,%eax
  801f47:	74 10                	je     801f59 <free+0x77>
  801f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4c:	8b 00                	mov    (%eax),%eax
  801f4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f51:	8b 52 04             	mov    0x4(%edx),%edx
  801f54:	89 50 04             	mov    %edx,0x4(%eax)
  801f57:	eb 0b                	jmp    801f64 <free+0x82>
  801f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5c:	8b 40 04             	mov    0x4(%eax),%eax
  801f5f:	a3 44 50 80 00       	mov    %eax,0x805044
  801f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f67:	8b 40 04             	mov    0x4(%eax),%eax
  801f6a:	85 c0                	test   %eax,%eax
  801f6c:	74 0f                	je     801f7d <free+0x9b>
  801f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f71:	8b 40 04             	mov    0x4(%eax),%eax
  801f74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f77:	8b 12                	mov    (%edx),%edx
  801f79:	89 10                	mov    %edx,(%eax)
  801f7b:	eb 0a                	jmp    801f87 <free+0xa5>
  801f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f80:	8b 00                	mov    (%eax),%eax
  801f82:	a3 40 50 80 00       	mov    %eax,0x805040
  801f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f9a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801f9f:	48                   	dec    %eax
  801fa0:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801fa5:	83 ec 0c             	sub    $0xc,%esp
  801fa8:	ff 75 f0             	pushl  -0x10(%ebp)
  801fab:	e8 83 12 00 00       	call   803233 <insert_sorted_with_merge_freeList>
  801fb0:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801fb3:	90                   	nop
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 28             	sub    $0x28,%esp
  801fbc:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbf:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fc2:	e8 fe fc ff ff       	call   801cc5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801fc7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fcb:	75 0a                	jne    801fd7 <smalloc+0x21>
  801fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd2:	e9 86 00 00 00       	jmp    80205d <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801fd7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801fde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe4:	01 d0                	add    %edx,%eax
  801fe6:	48                   	dec    %eax
  801fe7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fed:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff2:	f7 75 f4             	divl   -0xc(%ebp)
  801ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff8:	29 d0                	sub    %edx,%eax
  801ffa:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ffd:	e8 e4 06 00 00       	call   8026e6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802002:	85 c0                	test   %eax,%eax
  802004:	74 52                	je     802058 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  802006:	83 ec 0c             	sub    $0xc,%esp
  802009:	ff 75 0c             	pushl  0xc(%ebp)
  80200c:	e8 e6 0d 00 00       	call   802df7 <alloc_block_FF>
  802011:	83 c4 10             	add    $0x10,%esp
  802014:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  802017:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80201b:	75 07                	jne    802024 <smalloc+0x6e>
			return NULL ;
  80201d:	b8 00 00 00 00       	mov    $0x0,%eax
  802022:	eb 39                	jmp    80205d <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  802024:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802027:	8b 40 08             	mov    0x8(%eax),%eax
  80202a:	89 c2                	mov    %eax,%edx
  80202c:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802030:	52                   	push   %edx
  802031:	50                   	push   %eax
  802032:	ff 75 0c             	pushl  0xc(%ebp)
  802035:	ff 75 08             	pushl  0x8(%ebp)
  802038:	e8 2e 04 00 00       	call   80246b <sys_createSharedObject>
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  802043:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802047:	79 07                	jns    802050 <smalloc+0x9a>
			return (void*)NULL ;
  802049:	b8 00 00 00 00       	mov    $0x0,%eax
  80204e:	eb 0d                	jmp    80205d <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  802050:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802053:	8b 40 08             	mov    0x8(%eax),%eax
  802056:	eb 05                	jmp    80205d <smalloc+0xa7>
		}
		return (void*)NULL ;
  802058:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802065:	e8 5b fc ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80206a:	83 ec 08             	sub    $0x8,%esp
  80206d:	ff 75 0c             	pushl  0xc(%ebp)
  802070:	ff 75 08             	pushl  0x8(%ebp)
  802073:	e8 1d 04 00 00       	call   802495 <sys_getSizeOfSharedObject>
  802078:	83 c4 10             	add    $0x10,%esp
  80207b:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  80207e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802082:	75 0a                	jne    80208e <sget+0x2f>
			return NULL ;
  802084:	b8 00 00 00 00       	mov    $0x0,%eax
  802089:	e9 83 00 00 00       	jmp    802111 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  80208e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802095:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802098:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209b:	01 d0                	add    %edx,%eax
  80209d:	48                   	dec    %eax
  80209e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8020a9:	f7 75 f0             	divl   -0x10(%ebp)
  8020ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020af:	29 d0                	sub    %edx,%eax
  8020b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8020b4:	e8 2d 06 00 00       	call   8026e6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020b9:	85 c0                	test   %eax,%eax
  8020bb:	74 4f                	je     80210c <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8020bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c0:	83 ec 0c             	sub    $0xc,%esp
  8020c3:	50                   	push   %eax
  8020c4:	e8 2e 0d 00 00       	call   802df7 <alloc_block_FF>
  8020c9:	83 c4 10             	add    $0x10,%esp
  8020cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8020cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8020d3:	75 07                	jne    8020dc <sget+0x7d>
					return (void*)NULL ;
  8020d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020da:	eb 35                	jmp    802111 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8020dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020df:	8b 40 08             	mov    0x8(%eax),%eax
  8020e2:	83 ec 04             	sub    $0x4,%esp
  8020e5:	50                   	push   %eax
  8020e6:	ff 75 0c             	pushl  0xc(%ebp)
  8020e9:	ff 75 08             	pushl  0x8(%ebp)
  8020ec:	e8 c1 03 00 00       	call   8024b2 <sys_getSharedObject>
  8020f1:	83 c4 10             	add    $0x10,%esp
  8020f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  8020f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8020fb:	79 07                	jns    802104 <sget+0xa5>
				return (void*)NULL ;
  8020fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802102:	eb 0d                	jmp    802111 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  802104:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802107:	8b 40 08             	mov    0x8(%eax),%eax
  80210a:	eb 05                	jmp    802111 <sget+0xb2>


		}
	return (void*)NULL ;
  80210c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802119:	e8 a7 fb ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80211e:	83 ec 04             	sub    $0x4,%esp
  802121:	68 80 46 80 00       	push   $0x804680
  802126:	68 f9 00 00 00       	push   $0xf9
  80212b:	68 73 46 80 00       	push   $0x804673
  802130:	e8 52 eb ff ff       	call   800c87 <_panic>

00802135 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80213b:	83 ec 04             	sub    $0x4,%esp
  80213e:	68 a8 46 80 00       	push   $0x8046a8
  802143:	68 0d 01 00 00       	push   $0x10d
  802148:	68 73 46 80 00       	push   $0x804673
  80214d:	e8 35 eb ff ff       	call   800c87 <_panic>

00802152 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
  802155:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802158:	83 ec 04             	sub    $0x4,%esp
  80215b:	68 cc 46 80 00       	push   $0x8046cc
  802160:	68 18 01 00 00       	push   $0x118
  802165:	68 73 46 80 00       	push   $0x804673
  80216a:	e8 18 eb ff ff       	call   800c87 <_panic>

0080216f <shrink>:

}
void shrink(uint32 newSize)
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
  802172:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802175:	83 ec 04             	sub    $0x4,%esp
  802178:	68 cc 46 80 00       	push   $0x8046cc
  80217d:	68 1d 01 00 00       	push   $0x11d
  802182:	68 73 46 80 00       	push   $0x804673
  802187:	e8 fb ea ff ff       	call   800c87 <_panic>

0080218c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802192:	83 ec 04             	sub    $0x4,%esp
  802195:	68 cc 46 80 00       	push   $0x8046cc
  80219a:	68 22 01 00 00       	push   $0x122
  80219f:	68 73 46 80 00       	push   $0x804673
  8021a4:	e8 de ea ff ff       	call   800c87 <_panic>

008021a9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	57                   	push   %edi
  8021ad:	56                   	push   %esi
  8021ae:	53                   	push   %ebx
  8021af:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021be:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021c1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021c4:	cd 30                	int    $0x30
  8021c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8021c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021cc:	83 c4 10             	add    $0x10,%esp
  8021cf:	5b                   	pop    %ebx
  8021d0:	5e                   	pop    %esi
  8021d1:	5f                   	pop    %edi
  8021d2:	5d                   	pop    %ebp
  8021d3:	c3                   	ret    

008021d4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
  8021d7:	83 ec 04             	sub    $0x4,%esp
  8021da:	8b 45 10             	mov    0x10(%ebp),%eax
  8021dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8021e0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	52                   	push   %edx
  8021ec:	ff 75 0c             	pushl  0xc(%ebp)
  8021ef:	50                   	push   %eax
  8021f0:	6a 00                	push   $0x0
  8021f2:	e8 b2 ff ff ff       	call   8021a9 <syscall>
  8021f7:	83 c4 18             	add    $0x18,%esp
}
  8021fa:	90                   	nop
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <sys_cgetc>:

int
sys_cgetc(void)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 01                	push   $0x1
  80220c:	e8 98 ff ff ff       	call   8021a9 <syscall>
  802211:	83 c4 18             	add    $0x18,%esp
}
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802219:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	52                   	push   %edx
  802226:	50                   	push   %eax
  802227:	6a 05                	push   $0x5
  802229:	e8 7b ff ff ff       	call   8021a9 <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	56                   	push   %esi
  802237:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802238:	8b 75 18             	mov    0x18(%ebp),%esi
  80223b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80223e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802241:	8b 55 0c             	mov    0xc(%ebp),%edx
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	56                   	push   %esi
  802248:	53                   	push   %ebx
  802249:	51                   	push   %ecx
  80224a:	52                   	push   %edx
  80224b:	50                   	push   %eax
  80224c:	6a 06                	push   $0x6
  80224e:	e8 56 ff ff ff       	call   8021a9 <syscall>
  802253:	83 c4 18             	add    $0x18,%esp
}
  802256:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802259:	5b                   	pop    %ebx
  80225a:	5e                   	pop    %esi
  80225b:	5d                   	pop    %ebp
  80225c:	c3                   	ret    

0080225d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802260:	8b 55 0c             	mov    0xc(%ebp),%edx
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	52                   	push   %edx
  80226d:	50                   	push   %eax
  80226e:	6a 07                	push   $0x7
  802270:	e8 34 ff ff ff       	call   8021a9 <syscall>
  802275:	83 c4 18             	add    $0x18,%esp
}
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	ff 75 0c             	pushl  0xc(%ebp)
  802286:	ff 75 08             	pushl  0x8(%ebp)
  802289:	6a 08                	push   $0x8
  80228b:	e8 19 ff ff ff       	call   8021a9 <syscall>
  802290:	83 c4 18             	add    $0x18,%esp
}
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 09                	push   $0x9
  8022a4:	e8 00 ff ff ff       	call   8021a9 <syscall>
  8022a9:	83 c4 18             	add    $0x18,%esp
}
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

008022ae <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 0a                	push   $0xa
  8022bd:	e8 e7 fe ff ff       	call   8021a9 <syscall>
  8022c2:	83 c4 18             	add    $0x18,%esp
}
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 0b                	push   $0xb
  8022d6:	e8 ce fe ff ff       	call   8021a9 <syscall>
  8022db:	83 c4 18             	add    $0x18,%esp
}
  8022de:	c9                   	leave  
  8022df:	c3                   	ret    

008022e0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	ff 75 0c             	pushl  0xc(%ebp)
  8022ec:	ff 75 08             	pushl  0x8(%ebp)
  8022ef:	6a 0f                	push   $0xf
  8022f1:	e8 b3 fe ff ff       	call   8021a9 <syscall>
  8022f6:	83 c4 18             	add    $0x18,%esp
	return;
  8022f9:	90                   	nop
}
  8022fa:	c9                   	leave  
  8022fb:	c3                   	ret    

008022fc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	ff 75 0c             	pushl  0xc(%ebp)
  802308:	ff 75 08             	pushl  0x8(%ebp)
  80230b:	6a 10                	push   $0x10
  80230d:	e8 97 fe ff ff       	call   8021a9 <syscall>
  802312:	83 c4 18             	add    $0x18,%esp
	return ;
  802315:	90                   	nop
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	ff 75 10             	pushl  0x10(%ebp)
  802322:	ff 75 0c             	pushl  0xc(%ebp)
  802325:	ff 75 08             	pushl  0x8(%ebp)
  802328:	6a 11                	push   $0x11
  80232a:	e8 7a fe ff ff       	call   8021a9 <syscall>
  80232f:	83 c4 18             	add    $0x18,%esp
	return ;
  802332:	90                   	nop
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 0c                	push   $0xc
  802344:	e8 60 fe ff ff       	call   8021a9 <syscall>
  802349:	83 c4 18             	add    $0x18,%esp
}
  80234c:	c9                   	leave  
  80234d:	c3                   	ret    

0080234e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	ff 75 08             	pushl  0x8(%ebp)
  80235c:	6a 0d                	push   $0xd
  80235e:	e8 46 fe ff ff       	call   8021a9 <syscall>
  802363:	83 c4 18             	add    $0x18,%esp
}
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 0e                	push   $0xe
  802377:	e8 2d fe ff ff       	call   8021a9 <syscall>
  80237c:	83 c4 18             	add    $0x18,%esp
}
  80237f:	90                   	nop
  802380:	c9                   	leave  
  802381:	c3                   	ret    

00802382 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802382:	55                   	push   %ebp
  802383:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 13                	push   $0x13
  802391:	e8 13 fe ff ff       	call   8021a9 <syscall>
  802396:	83 c4 18             	add    $0x18,%esp
}
  802399:	90                   	nop
  80239a:	c9                   	leave  
  80239b:	c3                   	ret    

0080239c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80239c:	55                   	push   %ebp
  80239d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 14                	push   $0x14
  8023ab:	e8 f9 fd ff ff       	call   8021a9 <syscall>
  8023b0:	83 c4 18             	add    $0x18,%esp
}
  8023b3:	90                   	nop
  8023b4:	c9                   	leave  
  8023b5:	c3                   	ret    

008023b6 <sys_cputc>:


void
sys_cputc(const char c)
{
  8023b6:	55                   	push   %ebp
  8023b7:	89 e5                	mov    %esp,%ebp
  8023b9:	83 ec 04             	sub    $0x4,%esp
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023c2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	50                   	push   %eax
  8023cf:	6a 15                	push   $0x15
  8023d1:	e8 d3 fd ff ff       	call   8021a9 <syscall>
  8023d6:	83 c4 18             	add    $0x18,%esp
}
  8023d9:	90                   	nop
  8023da:	c9                   	leave  
  8023db:	c3                   	ret    

008023dc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 16                	push   $0x16
  8023eb:	e8 b9 fd ff ff       	call   8021a9 <syscall>
  8023f0:	83 c4 18             	add    $0x18,%esp
}
  8023f3:	90                   	nop
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	ff 75 0c             	pushl  0xc(%ebp)
  802405:	50                   	push   %eax
  802406:	6a 17                	push   $0x17
  802408:	e8 9c fd ff ff       	call   8021a9 <syscall>
  80240d:	83 c4 18             	add    $0x18,%esp
}
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802415:	8b 55 0c             	mov    0xc(%ebp),%edx
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	52                   	push   %edx
  802422:	50                   	push   %eax
  802423:	6a 1a                	push   $0x1a
  802425:	e8 7f fd ff ff       	call   8021a9 <syscall>
  80242a:	83 c4 18             	add    $0x18,%esp
}
  80242d:	c9                   	leave  
  80242e:	c3                   	ret    

0080242f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802432:	8b 55 0c             	mov    0xc(%ebp),%edx
  802435:	8b 45 08             	mov    0x8(%ebp),%eax
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	52                   	push   %edx
  80243f:	50                   	push   %eax
  802440:	6a 18                	push   $0x18
  802442:	e8 62 fd ff ff       	call   8021a9 <syscall>
  802447:	83 c4 18             	add    $0x18,%esp
}
  80244a:	90                   	nop
  80244b:	c9                   	leave  
  80244c:	c3                   	ret    

0080244d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802450:	8b 55 0c             	mov    0xc(%ebp),%edx
  802453:	8b 45 08             	mov    0x8(%ebp),%eax
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	52                   	push   %edx
  80245d:	50                   	push   %eax
  80245e:	6a 19                	push   $0x19
  802460:	e8 44 fd ff ff       	call   8021a9 <syscall>
  802465:	83 c4 18             	add    $0x18,%esp
}
  802468:	90                   	nop
  802469:	c9                   	leave  
  80246a:	c3                   	ret    

0080246b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80246b:	55                   	push   %ebp
  80246c:	89 e5                	mov    %esp,%ebp
  80246e:	83 ec 04             	sub    $0x4,%esp
  802471:	8b 45 10             	mov    0x10(%ebp),%eax
  802474:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802477:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80247a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80247e:	8b 45 08             	mov    0x8(%ebp),%eax
  802481:	6a 00                	push   $0x0
  802483:	51                   	push   %ecx
  802484:	52                   	push   %edx
  802485:	ff 75 0c             	pushl  0xc(%ebp)
  802488:	50                   	push   %eax
  802489:	6a 1b                	push   $0x1b
  80248b:	e8 19 fd ff ff       	call   8021a9 <syscall>
  802490:	83 c4 18             	add    $0x18,%esp
}
  802493:	c9                   	leave  
  802494:	c3                   	ret    

00802495 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802495:	55                   	push   %ebp
  802496:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	52                   	push   %edx
  8024a5:	50                   	push   %eax
  8024a6:	6a 1c                	push   $0x1c
  8024a8:	e8 fc fc ff ff       	call   8021a9 <syscall>
  8024ad:	83 c4 18             	add    $0x18,%esp
}
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8024b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	51                   	push   %ecx
  8024c3:	52                   	push   %edx
  8024c4:	50                   	push   %eax
  8024c5:	6a 1d                	push   $0x1d
  8024c7:	e8 dd fc ff ff       	call   8021a9 <syscall>
  8024cc:	83 c4 18             	add    $0x18,%esp
}
  8024cf:	c9                   	leave  
  8024d0:	c3                   	ret    

008024d1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8024d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	52                   	push   %edx
  8024e1:	50                   	push   %eax
  8024e2:	6a 1e                	push   $0x1e
  8024e4:	e8 c0 fc ff ff       	call   8021a9 <syscall>
  8024e9:	83 c4 18             	add    $0x18,%esp
}
  8024ec:	c9                   	leave  
  8024ed:	c3                   	ret    

008024ee <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 1f                	push   $0x1f
  8024fd:	e8 a7 fc ff ff       	call   8021a9 <syscall>
  802502:	83 c4 18             	add    $0x18,%esp
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80250a:	8b 45 08             	mov    0x8(%ebp),%eax
  80250d:	6a 00                	push   $0x0
  80250f:	ff 75 14             	pushl  0x14(%ebp)
  802512:	ff 75 10             	pushl  0x10(%ebp)
  802515:	ff 75 0c             	pushl  0xc(%ebp)
  802518:	50                   	push   %eax
  802519:	6a 20                	push   $0x20
  80251b:	e8 89 fc ff ff       	call   8021a9 <syscall>
  802520:	83 c4 18             	add    $0x18,%esp
}
  802523:	c9                   	leave  
  802524:	c3                   	ret    

00802525 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802525:	55                   	push   %ebp
  802526:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802528:	8b 45 08             	mov    0x8(%ebp),%eax
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	50                   	push   %eax
  802534:	6a 21                	push   $0x21
  802536:	e8 6e fc ff ff       	call   8021a9 <syscall>
  80253b:	83 c4 18             	add    $0x18,%esp
}
  80253e:	90                   	nop
  80253f:	c9                   	leave  
  802540:	c3                   	ret    

00802541 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802541:	55                   	push   %ebp
  802542:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	50                   	push   %eax
  802550:	6a 22                	push   $0x22
  802552:	e8 52 fc ff ff       	call   8021a9 <syscall>
  802557:	83 c4 18             	add    $0x18,%esp
}
  80255a:	c9                   	leave  
  80255b:	c3                   	ret    

0080255c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 02                	push   $0x2
  80256b:	e8 39 fc ff ff       	call   8021a9 <syscall>
  802570:	83 c4 18             	add    $0x18,%esp
}
  802573:	c9                   	leave  
  802574:	c3                   	ret    

00802575 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802575:	55                   	push   %ebp
  802576:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 03                	push   $0x3
  802584:	e8 20 fc ff ff       	call   8021a9 <syscall>
  802589:	83 c4 18             	add    $0x18,%esp
}
  80258c:	c9                   	leave  
  80258d:	c3                   	ret    

0080258e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80258e:	55                   	push   %ebp
  80258f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 04                	push   $0x4
  80259d:	e8 07 fc ff ff       	call   8021a9 <syscall>
  8025a2:	83 c4 18             	add    $0x18,%esp
}
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    

008025a7 <sys_exit_env>:


void sys_exit_env(void)
{
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 23                	push   $0x23
  8025b6:	e8 ee fb ff ff       	call   8021a9 <syscall>
  8025bb:	83 c4 18             	add    $0x18,%esp
}
  8025be:	90                   	nop
  8025bf:	c9                   	leave  
  8025c0:	c3                   	ret    

008025c1 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8025c1:	55                   	push   %ebp
  8025c2:	89 e5                	mov    %esp,%ebp
  8025c4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8025c7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025ca:	8d 50 04             	lea    0x4(%eax),%edx
  8025cd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	52                   	push   %edx
  8025d7:	50                   	push   %eax
  8025d8:	6a 24                	push   $0x24
  8025da:	e8 ca fb ff ff       	call   8021a9 <syscall>
  8025df:	83 c4 18             	add    $0x18,%esp
	return result;
  8025e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025eb:	89 01                	mov    %eax,(%ecx)
  8025ed:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8025f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f3:	c9                   	leave  
  8025f4:	c2 04 00             	ret    $0x4

008025f7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8025f7:	55                   	push   %ebp
  8025f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 00                	push   $0x0
  8025fe:	ff 75 10             	pushl  0x10(%ebp)
  802601:	ff 75 0c             	pushl  0xc(%ebp)
  802604:	ff 75 08             	pushl  0x8(%ebp)
  802607:	6a 12                	push   $0x12
  802609:	e8 9b fb ff ff       	call   8021a9 <syscall>
  80260e:	83 c4 18             	add    $0x18,%esp
	return ;
  802611:	90                   	nop
}
  802612:	c9                   	leave  
  802613:	c3                   	ret    

00802614 <sys_rcr2>:
uint32 sys_rcr2()
{
  802614:	55                   	push   %ebp
  802615:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802617:	6a 00                	push   $0x0
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 25                	push   $0x25
  802623:	e8 81 fb ff ff       	call   8021a9 <syscall>
  802628:	83 c4 18             	add    $0x18,%esp
}
  80262b:	c9                   	leave  
  80262c:	c3                   	ret    

0080262d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80262d:	55                   	push   %ebp
  80262e:	89 e5                	mov    %esp,%ebp
  802630:	83 ec 04             	sub    $0x4,%esp
  802633:	8b 45 08             	mov    0x8(%ebp),%eax
  802636:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802639:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80263d:	6a 00                	push   $0x0
  80263f:	6a 00                	push   $0x0
  802641:	6a 00                	push   $0x0
  802643:	6a 00                	push   $0x0
  802645:	50                   	push   %eax
  802646:	6a 26                	push   $0x26
  802648:	e8 5c fb ff ff       	call   8021a9 <syscall>
  80264d:	83 c4 18             	add    $0x18,%esp
	return ;
  802650:	90                   	nop
}
  802651:	c9                   	leave  
  802652:	c3                   	ret    

00802653 <rsttst>:
void rsttst()
{
  802653:	55                   	push   %ebp
  802654:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802656:	6a 00                	push   $0x0
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 28                	push   $0x28
  802662:	e8 42 fb ff ff       	call   8021a9 <syscall>
  802667:	83 c4 18             	add    $0x18,%esp
	return ;
  80266a:	90                   	nop
}
  80266b:	c9                   	leave  
  80266c:	c3                   	ret    

0080266d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80266d:	55                   	push   %ebp
  80266e:	89 e5                	mov    %esp,%ebp
  802670:	83 ec 04             	sub    $0x4,%esp
  802673:	8b 45 14             	mov    0x14(%ebp),%eax
  802676:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802679:	8b 55 18             	mov    0x18(%ebp),%edx
  80267c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802680:	52                   	push   %edx
  802681:	50                   	push   %eax
  802682:	ff 75 10             	pushl  0x10(%ebp)
  802685:	ff 75 0c             	pushl  0xc(%ebp)
  802688:	ff 75 08             	pushl  0x8(%ebp)
  80268b:	6a 27                	push   $0x27
  80268d:	e8 17 fb ff ff       	call   8021a9 <syscall>
  802692:	83 c4 18             	add    $0x18,%esp
	return ;
  802695:	90                   	nop
}
  802696:	c9                   	leave  
  802697:	c3                   	ret    

00802698 <chktst>:
void chktst(uint32 n)
{
  802698:	55                   	push   %ebp
  802699:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80269b:	6a 00                	push   $0x0
  80269d:	6a 00                	push   $0x0
  80269f:	6a 00                	push   $0x0
  8026a1:	6a 00                	push   $0x0
  8026a3:	ff 75 08             	pushl  0x8(%ebp)
  8026a6:	6a 29                	push   $0x29
  8026a8:	e8 fc fa ff ff       	call   8021a9 <syscall>
  8026ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b0:	90                   	nop
}
  8026b1:	c9                   	leave  
  8026b2:	c3                   	ret    

008026b3 <inctst>:

void inctst()
{
  8026b3:	55                   	push   %ebp
  8026b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 2a                	push   $0x2a
  8026c2:	e8 e2 fa ff ff       	call   8021a9 <syscall>
  8026c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8026ca:	90                   	nop
}
  8026cb:	c9                   	leave  
  8026cc:	c3                   	ret    

008026cd <gettst>:
uint32 gettst()
{
  8026cd:	55                   	push   %ebp
  8026ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8026d0:	6a 00                	push   $0x0
  8026d2:	6a 00                	push   $0x0
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 2b                	push   $0x2b
  8026dc:	e8 c8 fa ff ff       	call   8021a9 <syscall>
  8026e1:	83 c4 18             	add    $0x18,%esp
}
  8026e4:	c9                   	leave  
  8026e5:	c3                   	ret    

008026e6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8026e6:	55                   	push   %ebp
  8026e7:	89 e5                	mov    %esp,%ebp
  8026e9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026ec:	6a 00                	push   $0x0
  8026ee:	6a 00                	push   $0x0
  8026f0:	6a 00                	push   $0x0
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 2c                	push   $0x2c
  8026f8:	e8 ac fa ff ff       	call   8021a9 <syscall>
  8026fd:	83 c4 18             	add    $0x18,%esp
  802700:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802703:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802707:	75 07                	jne    802710 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802709:	b8 01 00 00 00       	mov    $0x1,%eax
  80270e:	eb 05                	jmp    802715 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802710:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802715:	c9                   	leave  
  802716:	c3                   	ret    

00802717 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802717:	55                   	push   %ebp
  802718:	89 e5                	mov    %esp,%ebp
  80271a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80271d:	6a 00                	push   $0x0
  80271f:	6a 00                	push   $0x0
  802721:	6a 00                	push   $0x0
  802723:	6a 00                	push   $0x0
  802725:	6a 00                	push   $0x0
  802727:	6a 2c                	push   $0x2c
  802729:	e8 7b fa ff ff       	call   8021a9 <syscall>
  80272e:	83 c4 18             	add    $0x18,%esp
  802731:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802734:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802738:	75 07                	jne    802741 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80273a:	b8 01 00 00 00       	mov    $0x1,%eax
  80273f:	eb 05                	jmp    802746 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802741:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802746:	c9                   	leave  
  802747:	c3                   	ret    

00802748 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802748:	55                   	push   %ebp
  802749:	89 e5                	mov    %esp,%ebp
  80274b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80274e:	6a 00                	push   $0x0
  802750:	6a 00                	push   $0x0
  802752:	6a 00                	push   $0x0
  802754:	6a 00                	push   $0x0
  802756:	6a 00                	push   $0x0
  802758:	6a 2c                	push   $0x2c
  80275a:	e8 4a fa ff ff       	call   8021a9 <syscall>
  80275f:	83 c4 18             	add    $0x18,%esp
  802762:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802765:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802769:	75 07                	jne    802772 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80276b:	b8 01 00 00 00       	mov    $0x1,%eax
  802770:	eb 05                	jmp    802777 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802772:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802777:	c9                   	leave  
  802778:	c3                   	ret    

00802779 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802779:	55                   	push   %ebp
  80277a:	89 e5                	mov    %esp,%ebp
  80277c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80277f:	6a 00                	push   $0x0
  802781:	6a 00                	push   $0x0
  802783:	6a 00                	push   $0x0
  802785:	6a 00                	push   $0x0
  802787:	6a 00                	push   $0x0
  802789:	6a 2c                	push   $0x2c
  80278b:	e8 19 fa ff ff       	call   8021a9 <syscall>
  802790:	83 c4 18             	add    $0x18,%esp
  802793:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802796:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80279a:	75 07                	jne    8027a3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80279c:	b8 01 00 00 00       	mov    $0x1,%eax
  8027a1:	eb 05                	jmp    8027a8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8027a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027a8:	c9                   	leave  
  8027a9:	c3                   	ret    

008027aa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027aa:	55                   	push   %ebp
  8027ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027ad:	6a 00                	push   $0x0
  8027af:	6a 00                	push   $0x0
  8027b1:	6a 00                	push   $0x0
  8027b3:	6a 00                	push   $0x0
  8027b5:	ff 75 08             	pushl  0x8(%ebp)
  8027b8:	6a 2d                	push   $0x2d
  8027ba:	e8 ea f9 ff ff       	call   8021a9 <syscall>
  8027bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8027c2:	90                   	nop
}
  8027c3:	c9                   	leave  
  8027c4:	c3                   	ret    

008027c5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8027c5:	55                   	push   %ebp
  8027c6:	89 e5                	mov    %esp,%ebp
  8027c8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8027c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d5:	6a 00                	push   $0x0
  8027d7:	53                   	push   %ebx
  8027d8:	51                   	push   %ecx
  8027d9:	52                   	push   %edx
  8027da:	50                   	push   %eax
  8027db:	6a 2e                	push   $0x2e
  8027dd:	e8 c7 f9 ff ff       	call   8021a9 <syscall>
  8027e2:	83 c4 18             	add    $0x18,%esp
}
  8027e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027e8:	c9                   	leave  
  8027e9:	c3                   	ret    

008027ea <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8027ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f3:	6a 00                	push   $0x0
  8027f5:	6a 00                	push   $0x0
  8027f7:	6a 00                	push   $0x0
  8027f9:	52                   	push   %edx
  8027fa:	50                   	push   %eax
  8027fb:	6a 2f                	push   $0x2f
  8027fd:	e8 a7 f9 ff ff       	call   8021a9 <syscall>
  802802:	83 c4 18             	add    $0x18,%esp
}
  802805:	c9                   	leave  
  802806:	c3                   	ret    

00802807 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802807:	55                   	push   %ebp
  802808:	89 e5                	mov    %esp,%ebp
  80280a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80280d:	83 ec 0c             	sub    $0xc,%esp
  802810:	68 dc 46 80 00       	push   $0x8046dc
  802815:	e8 21 e7 ff ff       	call   800f3b <cprintf>
  80281a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80281d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802824:	83 ec 0c             	sub    $0xc,%esp
  802827:	68 08 47 80 00       	push   $0x804708
  80282c:	e8 0a e7 ff ff       	call   800f3b <cprintf>
  802831:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802834:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802838:	a1 38 51 80 00       	mov    0x805138,%eax
  80283d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802840:	eb 56                	jmp    802898 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802842:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802846:	74 1c                	je     802864 <print_mem_block_lists+0x5d>
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	8b 50 08             	mov    0x8(%eax),%edx
  80284e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802851:	8b 48 08             	mov    0x8(%eax),%ecx
  802854:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802857:	8b 40 0c             	mov    0xc(%eax),%eax
  80285a:	01 c8                	add    %ecx,%eax
  80285c:	39 c2                	cmp    %eax,%edx
  80285e:	73 04                	jae    802864 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802860:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	8b 50 08             	mov    0x8(%eax),%edx
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 40 0c             	mov    0xc(%eax),%eax
  802870:	01 c2                	add    %eax,%edx
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	8b 40 08             	mov    0x8(%eax),%eax
  802878:	83 ec 04             	sub    $0x4,%esp
  80287b:	52                   	push   %edx
  80287c:	50                   	push   %eax
  80287d:	68 1d 47 80 00       	push   $0x80471d
  802882:	e8 b4 e6 ff ff       	call   800f3b <cprintf>
  802887:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802890:	a1 40 51 80 00       	mov    0x805140,%eax
  802895:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802898:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289c:	74 07                	je     8028a5 <print_mem_block_lists+0x9e>
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	8b 00                	mov    (%eax),%eax
  8028a3:	eb 05                	jmp    8028aa <print_mem_block_lists+0xa3>
  8028a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028aa:	a3 40 51 80 00       	mov    %eax,0x805140
  8028af:	a1 40 51 80 00       	mov    0x805140,%eax
  8028b4:	85 c0                	test   %eax,%eax
  8028b6:	75 8a                	jne    802842 <print_mem_block_lists+0x3b>
  8028b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bc:	75 84                	jne    802842 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8028be:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8028c2:	75 10                	jne    8028d4 <print_mem_block_lists+0xcd>
  8028c4:	83 ec 0c             	sub    $0xc,%esp
  8028c7:	68 2c 47 80 00       	push   $0x80472c
  8028cc:	e8 6a e6 ff ff       	call   800f3b <cprintf>
  8028d1:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8028d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8028db:	83 ec 0c             	sub    $0xc,%esp
  8028de:	68 50 47 80 00       	push   $0x804750
  8028e3:	e8 53 e6 ff ff       	call   800f3b <cprintf>
  8028e8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8028eb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8028ef:	a1 40 50 80 00       	mov    0x805040,%eax
  8028f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f7:	eb 56                	jmp    80294f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8028f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028fd:	74 1c                	je     80291b <print_mem_block_lists+0x114>
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	8b 50 08             	mov    0x8(%eax),%edx
  802905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802908:	8b 48 08             	mov    0x8(%eax),%ecx
  80290b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290e:	8b 40 0c             	mov    0xc(%eax),%eax
  802911:	01 c8                	add    %ecx,%eax
  802913:	39 c2                	cmp    %eax,%edx
  802915:	73 04                	jae    80291b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802917:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 50 08             	mov    0x8(%eax),%edx
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 40 0c             	mov    0xc(%eax),%eax
  802927:	01 c2                	add    %eax,%edx
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	8b 40 08             	mov    0x8(%eax),%eax
  80292f:	83 ec 04             	sub    $0x4,%esp
  802932:	52                   	push   %edx
  802933:	50                   	push   %eax
  802934:	68 1d 47 80 00       	push   $0x80471d
  802939:	e8 fd e5 ff ff       	call   800f3b <cprintf>
  80293e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802947:	a1 48 50 80 00       	mov    0x805048,%eax
  80294c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80294f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802953:	74 07                	je     80295c <print_mem_block_lists+0x155>
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 00                	mov    (%eax),%eax
  80295a:	eb 05                	jmp    802961 <print_mem_block_lists+0x15a>
  80295c:	b8 00 00 00 00       	mov    $0x0,%eax
  802961:	a3 48 50 80 00       	mov    %eax,0x805048
  802966:	a1 48 50 80 00       	mov    0x805048,%eax
  80296b:	85 c0                	test   %eax,%eax
  80296d:	75 8a                	jne    8028f9 <print_mem_block_lists+0xf2>
  80296f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802973:	75 84                	jne    8028f9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802975:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802979:	75 10                	jne    80298b <print_mem_block_lists+0x184>
  80297b:	83 ec 0c             	sub    $0xc,%esp
  80297e:	68 68 47 80 00       	push   $0x804768
  802983:	e8 b3 e5 ff ff       	call   800f3b <cprintf>
  802988:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80298b:	83 ec 0c             	sub    $0xc,%esp
  80298e:	68 dc 46 80 00       	push   $0x8046dc
  802993:	e8 a3 e5 ff ff       	call   800f3b <cprintf>
  802998:	83 c4 10             	add    $0x10,%esp

}
  80299b:	90                   	nop
  80299c:	c9                   	leave  
  80299d:	c3                   	ret    

0080299e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80299e:	55                   	push   %ebp
  80299f:	89 e5                	mov    %esp,%ebp
  8029a1:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8029a4:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8029ab:	00 00 00 
  8029ae:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8029b5:	00 00 00 
  8029b8:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8029bf:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8029c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8029c9:	e9 9e 00 00 00       	jmp    802a6c <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8029ce:	a1 50 50 80 00       	mov    0x805050,%eax
  8029d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d6:	c1 e2 04             	shl    $0x4,%edx
  8029d9:	01 d0                	add    %edx,%eax
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	75 14                	jne    8029f3 <initialize_MemBlocksList+0x55>
  8029df:	83 ec 04             	sub    $0x4,%esp
  8029e2:	68 90 47 80 00       	push   $0x804790
  8029e7:	6a 43                	push   $0x43
  8029e9:	68 b3 47 80 00       	push   $0x8047b3
  8029ee:	e8 94 e2 ff ff       	call   800c87 <_panic>
  8029f3:	a1 50 50 80 00       	mov    0x805050,%eax
  8029f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029fb:	c1 e2 04             	shl    $0x4,%edx
  8029fe:	01 d0                	add    %edx,%eax
  802a00:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a06:	89 10                	mov    %edx,(%eax)
  802a08:	8b 00                	mov    (%eax),%eax
  802a0a:	85 c0                	test   %eax,%eax
  802a0c:	74 18                	je     802a26 <initialize_MemBlocksList+0x88>
  802a0e:	a1 48 51 80 00       	mov    0x805148,%eax
  802a13:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a19:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802a1c:	c1 e1 04             	shl    $0x4,%ecx
  802a1f:	01 ca                	add    %ecx,%edx
  802a21:	89 50 04             	mov    %edx,0x4(%eax)
  802a24:	eb 12                	jmp    802a38 <initialize_MemBlocksList+0x9a>
  802a26:	a1 50 50 80 00       	mov    0x805050,%eax
  802a2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a2e:	c1 e2 04             	shl    $0x4,%edx
  802a31:	01 d0                	add    %edx,%eax
  802a33:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a38:	a1 50 50 80 00       	mov    0x805050,%eax
  802a3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a40:	c1 e2 04             	shl    $0x4,%edx
  802a43:	01 d0                	add    %edx,%eax
  802a45:	a3 48 51 80 00       	mov    %eax,0x805148
  802a4a:	a1 50 50 80 00       	mov    0x805050,%eax
  802a4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a52:	c1 e2 04             	shl    $0x4,%edx
  802a55:	01 d0                	add    %edx,%eax
  802a57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5e:	a1 54 51 80 00       	mov    0x805154,%eax
  802a63:	40                   	inc    %eax
  802a64:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802a69:	ff 45 f4             	incl   -0xc(%ebp)
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a72:	0f 82 56 ff ff ff    	jb     8029ce <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802a78:	90                   	nop
  802a79:	c9                   	leave  
  802a7a:	c3                   	ret    

00802a7b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802a7b:	55                   	push   %ebp
  802a7c:	89 e5                	mov    %esp,%ebp
  802a7e:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802a81:	a1 38 51 80 00       	mov    0x805138,%eax
  802a86:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a89:	eb 18                	jmp    802aa3 <find_block+0x28>
	{
		if (ele->sva==va)
  802a8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a8e:	8b 40 08             	mov    0x8(%eax),%eax
  802a91:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a94:	75 05                	jne    802a9b <find_block+0x20>
			return ele;
  802a96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a99:	eb 7b                	jmp    802b16 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802a9b:	a1 40 51 80 00       	mov    0x805140,%eax
  802aa0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802aa3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802aa7:	74 07                	je     802ab0 <find_block+0x35>
  802aa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802aac:	8b 00                	mov    (%eax),%eax
  802aae:	eb 05                	jmp    802ab5 <find_block+0x3a>
  802ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab5:	a3 40 51 80 00       	mov    %eax,0x805140
  802aba:	a1 40 51 80 00       	mov    0x805140,%eax
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	75 c8                	jne    802a8b <find_block+0x10>
  802ac3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802ac7:	75 c2                	jne    802a8b <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802ac9:	a1 40 50 80 00       	mov    0x805040,%eax
  802ace:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802ad1:	eb 18                	jmp    802aeb <find_block+0x70>
	{
		if (ele->sva==va)
  802ad3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ad6:	8b 40 08             	mov    0x8(%eax),%eax
  802ad9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802adc:	75 05                	jne    802ae3 <find_block+0x68>
					return ele;
  802ade:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ae1:	eb 33                	jmp    802b16 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802ae3:	a1 48 50 80 00       	mov    0x805048,%eax
  802ae8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802aeb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802aef:	74 07                	je     802af8 <find_block+0x7d>
  802af1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802af4:	8b 00                	mov    (%eax),%eax
  802af6:	eb 05                	jmp    802afd <find_block+0x82>
  802af8:	b8 00 00 00 00       	mov    $0x0,%eax
  802afd:	a3 48 50 80 00       	mov    %eax,0x805048
  802b02:	a1 48 50 80 00       	mov    0x805048,%eax
  802b07:	85 c0                	test   %eax,%eax
  802b09:	75 c8                	jne    802ad3 <find_block+0x58>
  802b0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b0f:	75 c2                	jne    802ad3 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802b11:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802b16:	c9                   	leave  
  802b17:	c3                   	ret    

00802b18 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802b18:	55                   	push   %ebp
  802b19:	89 e5                	mov    %esp,%ebp
  802b1b:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802b1e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b23:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802b26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b2a:	75 62                	jne    802b8e <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802b2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b30:	75 14                	jne    802b46 <insert_sorted_allocList+0x2e>
  802b32:	83 ec 04             	sub    $0x4,%esp
  802b35:	68 90 47 80 00       	push   $0x804790
  802b3a:	6a 69                	push   $0x69
  802b3c:	68 b3 47 80 00       	push   $0x8047b3
  802b41:	e8 41 e1 ff ff       	call   800c87 <_panic>
  802b46:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4f:	89 10                	mov    %edx,(%eax)
  802b51:	8b 45 08             	mov    0x8(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	85 c0                	test   %eax,%eax
  802b58:	74 0d                	je     802b67 <insert_sorted_allocList+0x4f>
  802b5a:	a1 40 50 80 00       	mov    0x805040,%eax
  802b5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b62:	89 50 04             	mov    %edx,0x4(%eax)
  802b65:	eb 08                	jmp    802b6f <insert_sorted_allocList+0x57>
  802b67:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6a:	a3 44 50 80 00       	mov    %eax,0x805044
  802b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b72:	a3 40 50 80 00       	mov    %eax,0x805040
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b81:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b86:	40                   	inc    %eax
  802b87:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802b8c:	eb 72                	jmp    802c00 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802b8e:	a1 40 50 80 00       	mov    0x805040,%eax
  802b93:	8b 50 08             	mov    0x8(%eax),%edx
  802b96:	8b 45 08             	mov    0x8(%ebp),%eax
  802b99:	8b 40 08             	mov    0x8(%eax),%eax
  802b9c:	39 c2                	cmp    %eax,%edx
  802b9e:	76 60                	jbe    802c00 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802ba0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ba4:	75 14                	jne    802bba <insert_sorted_allocList+0xa2>
  802ba6:	83 ec 04             	sub    $0x4,%esp
  802ba9:	68 90 47 80 00       	push   $0x804790
  802bae:	6a 6d                	push   $0x6d
  802bb0:	68 b3 47 80 00       	push   $0x8047b3
  802bb5:	e8 cd e0 ff ff       	call   800c87 <_panic>
  802bba:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc3:	89 10                	mov    %edx,(%eax)
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	8b 00                	mov    (%eax),%eax
  802bca:	85 c0                	test   %eax,%eax
  802bcc:	74 0d                	je     802bdb <insert_sorted_allocList+0xc3>
  802bce:	a1 40 50 80 00       	mov    0x805040,%eax
  802bd3:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd6:	89 50 04             	mov    %edx,0x4(%eax)
  802bd9:	eb 08                	jmp    802be3 <insert_sorted_allocList+0xcb>
  802bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bde:	a3 44 50 80 00       	mov    %eax,0x805044
  802be3:	8b 45 08             	mov    0x8(%ebp),%eax
  802be6:	a3 40 50 80 00       	mov    %eax,0x805040
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bfa:	40                   	inc    %eax
  802bfb:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802c00:	a1 40 50 80 00       	mov    0x805040,%eax
  802c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c08:	e9 b9 01 00 00       	jmp    802dc6 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c10:	8b 50 08             	mov    0x8(%eax),%edx
  802c13:	a1 40 50 80 00       	mov    0x805040,%eax
  802c18:	8b 40 08             	mov    0x8(%eax),%eax
  802c1b:	39 c2                	cmp    %eax,%edx
  802c1d:	76 7c                	jbe    802c9b <insert_sorted_allocList+0x183>
  802c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c22:	8b 50 08             	mov    0x8(%eax),%edx
  802c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c28:	8b 40 08             	mov    0x8(%eax),%eax
  802c2b:	39 c2                	cmp    %eax,%edx
  802c2d:	73 6c                	jae    802c9b <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802c2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c33:	74 06                	je     802c3b <insert_sorted_allocList+0x123>
  802c35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c39:	75 14                	jne    802c4f <insert_sorted_allocList+0x137>
  802c3b:	83 ec 04             	sub    $0x4,%esp
  802c3e:	68 cc 47 80 00       	push   $0x8047cc
  802c43:	6a 75                	push   $0x75
  802c45:	68 b3 47 80 00       	push   $0x8047b3
  802c4a:	e8 38 e0 ff ff       	call   800c87 <_panic>
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 50 04             	mov    0x4(%eax),%edx
  802c55:	8b 45 08             	mov    0x8(%ebp),%eax
  802c58:	89 50 04             	mov    %edx,0x4(%eax)
  802c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c61:	89 10                	mov    %edx,(%eax)
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	8b 40 04             	mov    0x4(%eax),%eax
  802c69:	85 c0                	test   %eax,%eax
  802c6b:	74 0d                	je     802c7a <insert_sorted_allocList+0x162>
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 40 04             	mov    0x4(%eax),%eax
  802c73:	8b 55 08             	mov    0x8(%ebp),%edx
  802c76:	89 10                	mov    %edx,(%eax)
  802c78:	eb 08                	jmp    802c82 <insert_sorted_allocList+0x16a>
  802c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7d:	a3 40 50 80 00       	mov    %eax,0x805040
  802c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c85:	8b 55 08             	mov    0x8(%ebp),%edx
  802c88:	89 50 04             	mov    %edx,0x4(%eax)
  802c8b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c90:	40                   	inc    %eax
  802c91:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  802c96:	e9 59 01 00 00       	jmp    802df4 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca4:	8b 40 08             	mov    0x8(%eax),%eax
  802ca7:	39 c2                	cmp    %eax,%edx
  802ca9:	0f 86 98 00 00 00    	jbe    802d47 <insert_sorted_allocList+0x22f>
  802caf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb2:	8b 50 08             	mov    0x8(%eax),%edx
  802cb5:	a1 44 50 80 00       	mov    0x805044,%eax
  802cba:	8b 40 08             	mov    0x8(%eax),%eax
  802cbd:	39 c2                	cmp    %eax,%edx
  802cbf:	0f 83 82 00 00 00    	jae    802d47 <insert_sorted_allocList+0x22f>
  802cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc8:	8b 50 08             	mov    0x8(%eax),%edx
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	8b 00                	mov    (%eax),%eax
  802cd0:	8b 40 08             	mov    0x8(%eax),%eax
  802cd3:	39 c2                	cmp    %eax,%edx
  802cd5:	73 70                	jae    802d47 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802cd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cdb:	74 06                	je     802ce3 <insert_sorted_allocList+0x1cb>
  802cdd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ce1:	75 14                	jne    802cf7 <insert_sorted_allocList+0x1df>
  802ce3:	83 ec 04             	sub    $0x4,%esp
  802ce6:	68 04 48 80 00       	push   $0x804804
  802ceb:	6a 7c                	push   $0x7c
  802ced:	68 b3 47 80 00       	push   $0x8047b3
  802cf2:	e8 90 df ff ff       	call   800c87 <_panic>
  802cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfa:	8b 10                	mov    (%eax),%edx
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	89 10                	mov    %edx,(%eax)
  802d01:	8b 45 08             	mov    0x8(%ebp),%eax
  802d04:	8b 00                	mov    (%eax),%eax
  802d06:	85 c0                	test   %eax,%eax
  802d08:	74 0b                	je     802d15 <insert_sorted_allocList+0x1fd>
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	8b 00                	mov    (%eax),%eax
  802d0f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d12:	89 50 04             	mov    %edx,0x4(%eax)
  802d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d18:	8b 55 08             	mov    0x8(%ebp),%edx
  802d1b:	89 10                	mov    %edx,(%eax)
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d23:	89 50 04             	mov    %edx,0x4(%eax)
  802d26:	8b 45 08             	mov    0x8(%ebp),%eax
  802d29:	8b 00                	mov    (%eax),%eax
  802d2b:	85 c0                	test   %eax,%eax
  802d2d:	75 08                	jne    802d37 <insert_sorted_allocList+0x21f>
  802d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d32:	a3 44 50 80 00       	mov    %eax,0x805044
  802d37:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d3c:	40                   	inc    %eax
  802d3d:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802d42:	e9 ad 00 00 00       	jmp    802df4 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	8b 50 08             	mov    0x8(%eax),%edx
  802d4d:	a1 44 50 80 00       	mov    0x805044,%eax
  802d52:	8b 40 08             	mov    0x8(%eax),%eax
  802d55:	39 c2                	cmp    %eax,%edx
  802d57:	76 65                	jbe    802dbe <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802d59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d5d:	75 17                	jne    802d76 <insert_sorted_allocList+0x25e>
  802d5f:	83 ec 04             	sub    $0x4,%esp
  802d62:	68 38 48 80 00       	push   $0x804838
  802d67:	68 80 00 00 00       	push   $0x80
  802d6c:	68 b3 47 80 00       	push   $0x8047b3
  802d71:	e8 11 df ff ff       	call   800c87 <_panic>
  802d76:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	89 50 04             	mov    %edx,0x4(%eax)
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	8b 40 04             	mov    0x4(%eax),%eax
  802d88:	85 c0                	test   %eax,%eax
  802d8a:	74 0c                	je     802d98 <insert_sorted_allocList+0x280>
  802d8c:	a1 44 50 80 00       	mov    0x805044,%eax
  802d91:	8b 55 08             	mov    0x8(%ebp),%edx
  802d94:	89 10                	mov    %edx,(%eax)
  802d96:	eb 08                	jmp    802da0 <insert_sorted_allocList+0x288>
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	a3 40 50 80 00       	mov    %eax,0x805040
  802da0:	8b 45 08             	mov    0x8(%ebp),%eax
  802da3:	a3 44 50 80 00       	mov    %eax,0x805044
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802db6:	40                   	inc    %eax
  802db7:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802dbc:	eb 36                	jmp    802df4 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802dbe:	a1 48 50 80 00       	mov    0x805048,%eax
  802dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dca:	74 07                	je     802dd3 <insert_sorted_allocList+0x2bb>
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	8b 00                	mov    (%eax),%eax
  802dd1:	eb 05                	jmp    802dd8 <insert_sorted_allocList+0x2c0>
  802dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd8:	a3 48 50 80 00       	mov    %eax,0x805048
  802ddd:	a1 48 50 80 00       	mov    0x805048,%eax
  802de2:	85 c0                	test   %eax,%eax
  802de4:	0f 85 23 fe ff ff    	jne    802c0d <insert_sorted_allocList+0xf5>
  802dea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dee:	0f 85 19 fe ff ff    	jne    802c0d <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802df4:	90                   	nop
  802df5:	c9                   	leave  
  802df6:	c3                   	ret    

00802df7 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802df7:	55                   	push   %ebp
  802df8:	89 e5                	mov    %esp,%ebp
  802dfa:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802dfd:	a1 38 51 80 00       	mov    0x805138,%eax
  802e02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e05:	e9 7c 01 00 00       	jmp    802f86 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e10:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e13:	0f 85 90 00 00 00    	jne    802ea9 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802e1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e23:	75 17                	jne    802e3c <alloc_block_FF+0x45>
  802e25:	83 ec 04             	sub    $0x4,%esp
  802e28:	68 5b 48 80 00       	push   $0x80485b
  802e2d:	68 ba 00 00 00       	push   $0xba
  802e32:	68 b3 47 80 00       	push   $0x8047b3
  802e37:	e8 4b de ff ff       	call   800c87 <_panic>
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	8b 00                	mov    (%eax),%eax
  802e41:	85 c0                	test   %eax,%eax
  802e43:	74 10                	je     802e55 <alloc_block_FF+0x5e>
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	8b 00                	mov    (%eax),%eax
  802e4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e4d:	8b 52 04             	mov    0x4(%edx),%edx
  802e50:	89 50 04             	mov    %edx,0x4(%eax)
  802e53:	eb 0b                	jmp    802e60 <alloc_block_FF+0x69>
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	8b 40 04             	mov    0x4(%eax),%eax
  802e5b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	8b 40 04             	mov    0x4(%eax),%eax
  802e66:	85 c0                	test   %eax,%eax
  802e68:	74 0f                	je     802e79 <alloc_block_FF+0x82>
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	8b 40 04             	mov    0x4(%eax),%eax
  802e70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e73:	8b 12                	mov    (%edx),%edx
  802e75:	89 10                	mov    %edx,(%eax)
  802e77:	eb 0a                	jmp    802e83 <alloc_block_FF+0x8c>
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	8b 00                	mov    (%eax),%eax
  802e7e:	a3 38 51 80 00       	mov    %eax,0x805138
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e96:	a1 44 51 80 00       	mov    0x805144,%eax
  802e9b:	48                   	dec    %eax
  802e9c:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea4:	e9 10 01 00 00       	jmp    802fb9 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eac:	8b 40 0c             	mov    0xc(%eax),%eax
  802eaf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb2:	0f 86 c6 00 00 00    	jbe    802f7e <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802eb8:	a1 48 51 80 00       	mov    0x805148,%eax
  802ebd:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802ec0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec4:	75 17                	jne    802edd <alloc_block_FF+0xe6>
  802ec6:	83 ec 04             	sub    $0x4,%esp
  802ec9:	68 5b 48 80 00       	push   $0x80485b
  802ece:	68 c2 00 00 00       	push   $0xc2
  802ed3:	68 b3 47 80 00       	push   $0x8047b3
  802ed8:	e8 aa dd ff ff       	call   800c87 <_panic>
  802edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee0:	8b 00                	mov    (%eax),%eax
  802ee2:	85 c0                	test   %eax,%eax
  802ee4:	74 10                	je     802ef6 <alloc_block_FF+0xff>
  802ee6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee9:	8b 00                	mov    (%eax),%eax
  802eeb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eee:	8b 52 04             	mov    0x4(%edx),%edx
  802ef1:	89 50 04             	mov    %edx,0x4(%eax)
  802ef4:	eb 0b                	jmp    802f01 <alloc_block_FF+0x10a>
  802ef6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef9:	8b 40 04             	mov    0x4(%eax),%eax
  802efc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f04:	8b 40 04             	mov    0x4(%eax),%eax
  802f07:	85 c0                	test   %eax,%eax
  802f09:	74 0f                	je     802f1a <alloc_block_FF+0x123>
  802f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0e:	8b 40 04             	mov    0x4(%eax),%eax
  802f11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f14:	8b 12                	mov    (%edx),%edx
  802f16:	89 10                	mov    %edx,(%eax)
  802f18:	eb 0a                	jmp    802f24 <alloc_block_FF+0x12d>
  802f1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1d:	8b 00                	mov    (%eax),%eax
  802f1f:	a3 48 51 80 00       	mov    %eax,0x805148
  802f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f37:	a1 54 51 80 00       	mov    0x805154,%eax
  802f3c:	48                   	dec    %eax
  802f3d:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f45:	8b 50 08             	mov    0x8(%eax),%edx
  802f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4b:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f51:	8b 55 08             	mov    0x8(%ebp),%edx
  802f54:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5d:	2b 45 08             	sub    0x8(%ebp),%eax
  802f60:	89 c2                	mov    %eax,%edx
  802f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f65:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6b:	8b 50 08             	mov    0x8(%eax),%edx
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	01 c2                	add    %eax,%edx
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7c:	eb 3b                	jmp    802fb9 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802f7e:	a1 40 51 80 00       	mov    0x805140,%eax
  802f83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8a:	74 07                	je     802f93 <alloc_block_FF+0x19c>
  802f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8f:	8b 00                	mov    (%eax),%eax
  802f91:	eb 05                	jmp    802f98 <alloc_block_FF+0x1a1>
  802f93:	b8 00 00 00 00       	mov    $0x0,%eax
  802f98:	a3 40 51 80 00       	mov    %eax,0x805140
  802f9d:	a1 40 51 80 00       	mov    0x805140,%eax
  802fa2:	85 c0                	test   %eax,%eax
  802fa4:	0f 85 60 fe ff ff    	jne    802e0a <alloc_block_FF+0x13>
  802faa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fae:	0f 85 56 fe ff ff    	jne    802e0a <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802fb4:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb9:	c9                   	leave  
  802fba:	c3                   	ret    

00802fbb <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802fbb:	55                   	push   %ebp
  802fbc:	89 e5                	mov    %esp,%ebp
  802fbe:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802fc1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802fc8:	a1 38 51 80 00       	mov    0x805138,%eax
  802fcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fd0:	eb 3a                	jmp    80300c <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fdb:	72 27                	jb     803004 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802fdd:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802fe1:	75 0b                	jne    802fee <alloc_block_BF+0x33>
					best_size= element->size;
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802fec:	eb 16                	jmp    803004 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff7:	39 c2                	cmp    %eax,%edx
  802ff9:	77 09                	ja     803004 <alloc_block_BF+0x49>
					best_size=element->size;
  802ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffe:	8b 40 0c             	mov    0xc(%eax),%eax
  803001:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  803004:	a1 40 51 80 00       	mov    0x805140,%eax
  803009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80300c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803010:	74 07                	je     803019 <alloc_block_BF+0x5e>
  803012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803015:	8b 00                	mov    (%eax),%eax
  803017:	eb 05                	jmp    80301e <alloc_block_BF+0x63>
  803019:	b8 00 00 00 00       	mov    $0x0,%eax
  80301e:	a3 40 51 80 00       	mov    %eax,0x805140
  803023:	a1 40 51 80 00       	mov    0x805140,%eax
  803028:	85 c0                	test   %eax,%eax
  80302a:	75 a6                	jne    802fd2 <alloc_block_BF+0x17>
  80302c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803030:	75 a0                	jne    802fd2 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  803032:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803036:	0f 84 d3 01 00 00    	je     80320f <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80303c:	a1 38 51 80 00       	mov    0x805138,%eax
  803041:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803044:	e9 98 01 00 00       	jmp    8031e1 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  803049:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80304f:	0f 86 da 00 00 00    	jbe    80312f <alloc_block_BF+0x174>
  803055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803058:	8b 50 0c             	mov    0xc(%eax),%edx
  80305b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305e:	39 c2                	cmp    %eax,%edx
  803060:	0f 85 c9 00 00 00    	jne    80312f <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  803066:	a1 48 51 80 00       	mov    0x805148,%eax
  80306b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80306e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803072:	75 17                	jne    80308b <alloc_block_BF+0xd0>
  803074:	83 ec 04             	sub    $0x4,%esp
  803077:	68 5b 48 80 00       	push   $0x80485b
  80307c:	68 ea 00 00 00       	push   $0xea
  803081:	68 b3 47 80 00       	push   $0x8047b3
  803086:	e8 fc db ff ff       	call   800c87 <_panic>
  80308b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308e:	8b 00                	mov    (%eax),%eax
  803090:	85 c0                	test   %eax,%eax
  803092:	74 10                	je     8030a4 <alloc_block_BF+0xe9>
  803094:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803097:	8b 00                	mov    (%eax),%eax
  803099:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80309c:	8b 52 04             	mov    0x4(%edx),%edx
  80309f:	89 50 04             	mov    %edx,0x4(%eax)
  8030a2:	eb 0b                	jmp    8030af <alloc_block_BF+0xf4>
  8030a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a7:	8b 40 04             	mov    0x4(%eax),%eax
  8030aa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b2:	8b 40 04             	mov    0x4(%eax),%eax
  8030b5:	85 c0                	test   %eax,%eax
  8030b7:	74 0f                	je     8030c8 <alloc_block_BF+0x10d>
  8030b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030bc:	8b 40 04             	mov    0x4(%eax),%eax
  8030bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030c2:	8b 12                	mov    (%edx),%edx
  8030c4:	89 10                	mov    %edx,(%eax)
  8030c6:	eb 0a                	jmp    8030d2 <alloc_block_BF+0x117>
  8030c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030cb:	8b 00                	mov    (%eax),%eax
  8030cd:	a3 48 51 80 00       	mov    %eax,0x805148
  8030d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e5:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ea:	48                   	dec    %eax
  8030eb:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  8030f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f3:	8b 50 08             	mov    0x8(%eax),%edx
  8030f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f9:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  8030fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803102:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  803105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803108:	8b 40 0c             	mov    0xc(%eax),%eax
  80310b:	2b 45 08             	sub    0x8(%ebp),%eax
  80310e:	89 c2                	mov    %eax,%edx
  803110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803113:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  803116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803119:	8b 50 08             	mov    0x8(%eax),%edx
  80311c:	8b 45 08             	mov    0x8(%ebp),%eax
  80311f:	01 c2                	add    %eax,%edx
  803121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803124:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  803127:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312a:	e9 e5 00 00 00       	jmp    803214 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  80312f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803132:	8b 50 0c             	mov    0xc(%eax),%edx
  803135:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803138:	39 c2                	cmp    %eax,%edx
  80313a:	0f 85 99 00 00 00    	jne    8031d9 <alloc_block_BF+0x21e>
  803140:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803143:	3b 45 08             	cmp    0x8(%ebp),%eax
  803146:	0f 85 8d 00 00 00    	jne    8031d9 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  803152:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803156:	75 17                	jne    80316f <alloc_block_BF+0x1b4>
  803158:	83 ec 04             	sub    $0x4,%esp
  80315b:	68 5b 48 80 00       	push   $0x80485b
  803160:	68 f7 00 00 00       	push   $0xf7
  803165:	68 b3 47 80 00       	push   $0x8047b3
  80316a:	e8 18 db ff ff       	call   800c87 <_panic>
  80316f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803172:	8b 00                	mov    (%eax),%eax
  803174:	85 c0                	test   %eax,%eax
  803176:	74 10                	je     803188 <alloc_block_BF+0x1cd>
  803178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317b:	8b 00                	mov    (%eax),%eax
  80317d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803180:	8b 52 04             	mov    0x4(%edx),%edx
  803183:	89 50 04             	mov    %edx,0x4(%eax)
  803186:	eb 0b                	jmp    803193 <alloc_block_BF+0x1d8>
  803188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318b:	8b 40 04             	mov    0x4(%eax),%eax
  80318e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803196:	8b 40 04             	mov    0x4(%eax),%eax
  803199:	85 c0                	test   %eax,%eax
  80319b:	74 0f                	je     8031ac <alloc_block_BF+0x1f1>
  80319d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a0:	8b 40 04             	mov    0x4(%eax),%eax
  8031a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031a6:	8b 12                	mov    (%edx),%edx
  8031a8:	89 10                	mov    %edx,(%eax)
  8031aa:	eb 0a                	jmp    8031b6 <alloc_block_BF+0x1fb>
  8031ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031af:	8b 00                	mov    (%eax),%eax
  8031b1:	a3 38 51 80 00       	mov    %eax,0x805138
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8031ce:	48                   	dec    %eax
  8031cf:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  8031d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d7:	eb 3b                	jmp    803214 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8031d9:	a1 40 51 80 00       	mov    0x805140,%eax
  8031de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e5:	74 07                	je     8031ee <alloc_block_BF+0x233>
  8031e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ea:	8b 00                	mov    (%eax),%eax
  8031ec:	eb 05                	jmp    8031f3 <alloc_block_BF+0x238>
  8031ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f3:	a3 40 51 80 00       	mov    %eax,0x805140
  8031f8:	a1 40 51 80 00       	mov    0x805140,%eax
  8031fd:	85 c0                	test   %eax,%eax
  8031ff:	0f 85 44 fe ff ff    	jne    803049 <alloc_block_BF+0x8e>
  803205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803209:	0f 85 3a fe ff ff    	jne    803049 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  80320f:	b8 00 00 00 00       	mov    $0x0,%eax
  803214:	c9                   	leave  
  803215:	c3                   	ret    

00803216 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803216:	55                   	push   %ebp
  803217:	89 e5                	mov    %esp,%ebp
  803219:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80321c:	83 ec 04             	sub    $0x4,%esp
  80321f:	68 7c 48 80 00       	push   $0x80487c
  803224:	68 04 01 00 00       	push   $0x104
  803229:	68 b3 47 80 00       	push   $0x8047b3
  80322e:	e8 54 da ff ff       	call   800c87 <_panic>

00803233 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  803233:	55                   	push   %ebp
  803234:	89 e5                	mov    %esp,%ebp
  803236:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  803239:	a1 38 51 80 00       	mov    0x805138,%eax
  80323e:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  803241:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803246:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  803249:	a1 38 51 80 00       	mov    0x805138,%eax
  80324e:	85 c0                	test   %eax,%eax
  803250:	75 68                	jne    8032ba <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  803252:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803256:	75 17                	jne    80326f <insert_sorted_with_merge_freeList+0x3c>
  803258:	83 ec 04             	sub    $0x4,%esp
  80325b:	68 90 47 80 00       	push   $0x804790
  803260:	68 14 01 00 00       	push   $0x114
  803265:	68 b3 47 80 00       	push   $0x8047b3
  80326a:	e8 18 da ff ff       	call   800c87 <_panic>
  80326f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	89 10                	mov    %edx,(%eax)
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	8b 00                	mov    (%eax),%eax
  80327f:	85 c0                	test   %eax,%eax
  803281:	74 0d                	je     803290 <insert_sorted_with_merge_freeList+0x5d>
  803283:	a1 38 51 80 00       	mov    0x805138,%eax
  803288:	8b 55 08             	mov    0x8(%ebp),%edx
  80328b:	89 50 04             	mov    %edx,0x4(%eax)
  80328e:	eb 08                	jmp    803298 <insert_sorted_with_merge_freeList+0x65>
  803290:	8b 45 08             	mov    0x8(%ebp),%eax
  803293:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803298:	8b 45 08             	mov    0x8(%ebp),%eax
  80329b:	a3 38 51 80 00       	mov    %eax,0x805138
  8032a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032aa:	a1 44 51 80 00       	mov    0x805144,%eax
  8032af:	40                   	inc    %eax
  8032b0:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  8032b5:	e9 d2 06 00 00       	jmp    80398c <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bd:	8b 50 08             	mov    0x8(%eax),%edx
  8032c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c3:	8b 40 08             	mov    0x8(%eax),%eax
  8032c6:	39 c2                	cmp    %eax,%edx
  8032c8:	0f 83 22 01 00 00    	jae    8033f0 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d1:	8b 50 08             	mov    0x8(%eax),%edx
  8032d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8032da:	01 c2                	add    %eax,%edx
  8032dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032df:	8b 40 08             	mov    0x8(%eax),%eax
  8032e2:	39 c2                	cmp    %eax,%edx
  8032e4:	0f 85 9e 00 00 00    	jne    803388 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  8032ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ed:	8b 50 08             	mov    0x8(%eax),%edx
  8032f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f3:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  8032f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f9:	8b 50 0c             	mov    0xc(%eax),%edx
  8032fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803302:	01 c2                	add    %eax,%edx
  803304:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803307:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  80330a:	8b 45 08             	mov    0x8(%ebp),%eax
  80330d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803314:	8b 45 08             	mov    0x8(%ebp),%eax
  803317:	8b 50 08             	mov    0x8(%eax),%edx
  80331a:	8b 45 08             	mov    0x8(%ebp),%eax
  80331d:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803320:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803324:	75 17                	jne    80333d <insert_sorted_with_merge_freeList+0x10a>
  803326:	83 ec 04             	sub    $0x4,%esp
  803329:	68 90 47 80 00       	push   $0x804790
  80332e:	68 21 01 00 00       	push   $0x121
  803333:	68 b3 47 80 00       	push   $0x8047b3
  803338:	e8 4a d9 ff ff       	call   800c87 <_panic>
  80333d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803343:	8b 45 08             	mov    0x8(%ebp),%eax
  803346:	89 10                	mov    %edx,(%eax)
  803348:	8b 45 08             	mov    0x8(%ebp),%eax
  80334b:	8b 00                	mov    (%eax),%eax
  80334d:	85 c0                	test   %eax,%eax
  80334f:	74 0d                	je     80335e <insert_sorted_with_merge_freeList+0x12b>
  803351:	a1 48 51 80 00       	mov    0x805148,%eax
  803356:	8b 55 08             	mov    0x8(%ebp),%edx
  803359:	89 50 04             	mov    %edx,0x4(%eax)
  80335c:	eb 08                	jmp    803366 <insert_sorted_with_merge_freeList+0x133>
  80335e:	8b 45 08             	mov    0x8(%ebp),%eax
  803361:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803366:	8b 45 08             	mov    0x8(%ebp),%eax
  803369:	a3 48 51 80 00       	mov    %eax,0x805148
  80336e:	8b 45 08             	mov    0x8(%ebp),%eax
  803371:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803378:	a1 54 51 80 00       	mov    0x805154,%eax
  80337d:	40                   	inc    %eax
  80337e:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  803383:	e9 04 06 00 00       	jmp    80398c <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  803388:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80338c:	75 17                	jne    8033a5 <insert_sorted_with_merge_freeList+0x172>
  80338e:	83 ec 04             	sub    $0x4,%esp
  803391:	68 90 47 80 00       	push   $0x804790
  803396:	68 26 01 00 00       	push   $0x126
  80339b:	68 b3 47 80 00       	push   $0x8047b3
  8033a0:	e8 e2 d8 ff ff       	call   800c87 <_panic>
  8033a5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8033ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ae:	89 10                	mov    %edx,(%eax)
  8033b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b3:	8b 00                	mov    (%eax),%eax
  8033b5:	85 c0                	test   %eax,%eax
  8033b7:	74 0d                	je     8033c6 <insert_sorted_with_merge_freeList+0x193>
  8033b9:	a1 38 51 80 00       	mov    0x805138,%eax
  8033be:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c1:	89 50 04             	mov    %edx,0x4(%eax)
  8033c4:	eb 08                	jmp    8033ce <insert_sorted_with_merge_freeList+0x19b>
  8033c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d1:	a3 38 51 80 00       	mov    %eax,0x805138
  8033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e0:	a1 44 51 80 00       	mov    0x805144,%eax
  8033e5:	40                   	inc    %eax
  8033e6:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  8033eb:	e9 9c 05 00 00       	jmp    80398c <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  8033f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f3:	8b 50 08             	mov    0x8(%eax),%edx
  8033f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f9:	8b 40 08             	mov    0x8(%eax),%eax
  8033fc:	39 c2                	cmp    %eax,%edx
  8033fe:	0f 86 16 01 00 00    	jbe    80351a <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  803404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803407:	8b 50 08             	mov    0x8(%eax),%edx
  80340a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80340d:	8b 40 0c             	mov    0xc(%eax),%eax
  803410:	01 c2                	add    %eax,%edx
  803412:	8b 45 08             	mov    0x8(%ebp),%eax
  803415:	8b 40 08             	mov    0x8(%eax),%eax
  803418:	39 c2                	cmp    %eax,%edx
  80341a:	0f 85 92 00 00 00    	jne    8034b2 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  803420:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803423:	8b 50 0c             	mov    0xc(%eax),%edx
  803426:	8b 45 08             	mov    0x8(%ebp),%eax
  803429:	8b 40 0c             	mov    0xc(%eax),%eax
  80342c:	01 c2                	add    %eax,%edx
  80342e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803431:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  803434:	8b 45 08             	mov    0x8(%ebp),%eax
  803437:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80343e:	8b 45 08             	mov    0x8(%ebp),%eax
  803441:	8b 50 08             	mov    0x8(%eax),%edx
  803444:	8b 45 08             	mov    0x8(%ebp),%eax
  803447:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80344a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80344e:	75 17                	jne    803467 <insert_sorted_with_merge_freeList+0x234>
  803450:	83 ec 04             	sub    $0x4,%esp
  803453:	68 90 47 80 00       	push   $0x804790
  803458:	68 31 01 00 00       	push   $0x131
  80345d:	68 b3 47 80 00       	push   $0x8047b3
  803462:	e8 20 d8 ff ff       	call   800c87 <_panic>
  803467:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80346d:	8b 45 08             	mov    0x8(%ebp),%eax
  803470:	89 10                	mov    %edx,(%eax)
  803472:	8b 45 08             	mov    0x8(%ebp),%eax
  803475:	8b 00                	mov    (%eax),%eax
  803477:	85 c0                	test   %eax,%eax
  803479:	74 0d                	je     803488 <insert_sorted_with_merge_freeList+0x255>
  80347b:	a1 48 51 80 00       	mov    0x805148,%eax
  803480:	8b 55 08             	mov    0x8(%ebp),%edx
  803483:	89 50 04             	mov    %edx,0x4(%eax)
  803486:	eb 08                	jmp    803490 <insert_sorted_with_merge_freeList+0x25d>
  803488:	8b 45 08             	mov    0x8(%ebp),%eax
  80348b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803490:	8b 45 08             	mov    0x8(%ebp),%eax
  803493:	a3 48 51 80 00       	mov    %eax,0x805148
  803498:	8b 45 08             	mov    0x8(%ebp),%eax
  80349b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a2:	a1 54 51 80 00       	mov    0x805154,%eax
  8034a7:	40                   	inc    %eax
  8034a8:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  8034ad:	e9 da 04 00 00       	jmp    80398c <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  8034b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034b6:	75 17                	jne    8034cf <insert_sorted_with_merge_freeList+0x29c>
  8034b8:	83 ec 04             	sub    $0x4,%esp
  8034bb:	68 38 48 80 00       	push   $0x804838
  8034c0:	68 37 01 00 00       	push   $0x137
  8034c5:	68 b3 47 80 00       	push   $0x8047b3
  8034ca:	e8 b8 d7 ff ff       	call   800c87 <_panic>
  8034cf:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8034d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d8:	89 50 04             	mov    %edx,0x4(%eax)
  8034db:	8b 45 08             	mov    0x8(%ebp),%eax
  8034de:	8b 40 04             	mov    0x4(%eax),%eax
  8034e1:	85 c0                	test   %eax,%eax
  8034e3:	74 0c                	je     8034f1 <insert_sorted_with_merge_freeList+0x2be>
  8034e5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ed:	89 10                	mov    %edx,(%eax)
  8034ef:	eb 08                	jmp    8034f9 <insert_sorted_with_merge_freeList+0x2c6>
  8034f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f4:	a3 38 51 80 00       	mov    %eax,0x805138
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803501:	8b 45 08             	mov    0x8(%ebp),%eax
  803504:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80350a:	a1 44 51 80 00       	mov    0x805144,%eax
  80350f:	40                   	inc    %eax
  803510:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803515:	e9 72 04 00 00       	jmp    80398c <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  80351a:	a1 38 51 80 00       	mov    0x805138,%eax
  80351f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803522:	e9 35 04 00 00       	jmp    80395c <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  803527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352a:	8b 00                	mov    (%eax),%eax
  80352c:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  80352f:	8b 45 08             	mov    0x8(%ebp),%eax
  803532:	8b 50 08             	mov    0x8(%eax),%edx
  803535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803538:	8b 40 08             	mov    0x8(%eax),%eax
  80353b:	39 c2                	cmp    %eax,%edx
  80353d:	0f 86 11 04 00 00    	jbe    803954 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  803543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803546:	8b 50 08             	mov    0x8(%eax),%edx
  803549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354c:	8b 40 0c             	mov    0xc(%eax),%eax
  80354f:	01 c2                	add    %eax,%edx
  803551:	8b 45 08             	mov    0x8(%ebp),%eax
  803554:	8b 40 08             	mov    0x8(%eax),%eax
  803557:	39 c2                	cmp    %eax,%edx
  803559:	0f 83 8b 00 00 00    	jae    8035ea <insert_sorted_with_merge_freeList+0x3b7>
  80355f:	8b 45 08             	mov    0x8(%ebp),%eax
  803562:	8b 50 08             	mov    0x8(%eax),%edx
  803565:	8b 45 08             	mov    0x8(%ebp),%eax
  803568:	8b 40 0c             	mov    0xc(%eax),%eax
  80356b:	01 c2                	add    %eax,%edx
  80356d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803570:	8b 40 08             	mov    0x8(%eax),%eax
  803573:	39 c2                	cmp    %eax,%edx
  803575:	73 73                	jae    8035ea <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  803577:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80357b:	74 06                	je     803583 <insert_sorted_with_merge_freeList+0x350>
  80357d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803581:	75 17                	jne    80359a <insert_sorted_with_merge_freeList+0x367>
  803583:	83 ec 04             	sub    $0x4,%esp
  803586:	68 04 48 80 00       	push   $0x804804
  80358b:	68 48 01 00 00       	push   $0x148
  803590:	68 b3 47 80 00       	push   $0x8047b3
  803595:	e8 ed d6 ff ff       	call   800c87 <_panic>
  80359a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359d:	8b 10                	mov    (%eax),%edx
  80359f:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a2:	89 10                	mov    %edx,(%eax)
  8035a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a7:	8b 00                	mov    (%eax),%eax
  8035a9:	85 c0                	test   %eax,%eax
  8035ab:	74 0b                	je     8035b8 <insert_sorted_with_merge_freeList+0x385>
  8035ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b0:	8b 00                	mov    (%eax),%eax
  8035b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8035b5:	89 50 04             	mov    %edx,0x4(%eax)
  8035b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8035be:	89 10                	mov    %edx,(%eax)
  8035c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035c6:	89 50 04             	mov    %edx,0x4(%eax)
  8035c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cc:	8b 00                	mov    (%eax),%eax
  8035ce:	85 c0                	test   %eax,%eax
  8035d0:	75 08                	jne    8035da <insert_sorted_with_merge_freeList+0x3a7>
  8035d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035da:	a1 44 51 80 00       	mov    0x805144,%eax
  8035df:	40                   	inc    %eax
  8035e0:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  8035e5:	e9 a2 03 00 00       	jmp    80398c <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8035ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ed:	8b 50 08             	mov    0x8(%eax),%edx
  8035f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f6:	01 c2                	add    %eax,%edx
  8035f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035fb:	8b 40 08             	mov    0x8(%eax),%eax
  8035fe:	39 c2                	cmp    %eax,%edx
  803600:	0f 83 ae 00 00 00    	jae    8036b4 <insert_sorted_with_merge_freeList+0x481>
  803606:	8b 45 08             	mov    0x8(%ebp),%eax
  803609:	8b 50 08             	mov    0x8(%eax),%edx
  80360c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360f:	8b 48 08             	mov    0x8(%eax),%ecx
  803612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803615:	8b 40 0c             	mov    0xc(%eax),%eax
  803618:	01 c8                	add    %ecx,%eax
  80361a:	39 c2                	cmp    %eax,%edx
  80361c:	0f 85 92 00 00 00    	jne    8036b4 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  803622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803625:	8b 50 0c             	mov    0xc(%eax),%edx
  803628:	8b 45 08             	mov    0x8(%ebp),%eax
  80362b:	8b 40 0c             	mov    0xc(%eax),%eax
  80362e:	01 c2                	add    %eax,%edx
  803630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803633:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  803636:	8b 45 08             	mov    0x8(%ebp),%eax
  803639:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803640:	8b 45 08             	mov    0x8(%ebp),%eax
  803643:	8b 50 08             	mov    0x8(%eax),%edx
  803646:	8b 45 08             	mov    0x8(%ebp),%eax
  803649:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80364c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803650:	75 17                	jne    803669 <insert_sorted_with_merge_freeList+0x436>
  803652:	83 ec 04             	sub    $0x4,%esp
  803655:	68 90 47 80 00       	push   $0x804790
  80365a:	68 51 01 00 00       	push   $0x151
  80365f:	68 b3 47 80 00       	push   $0x8047b3
  803664:	e8 1e d6 ff ff       	call   800c87 <_panic>
  803669:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80366f:	8b 45 08             	mov    0x8(%ebp),%eax
  803672:	89 10                	mov    %edx,(%eax)
  803674:	8b 45 08             	mov    0x8(%ebp),%eax
  803677:	8b 00                	mov    (%eax),%eax
  803679:	85 c0                	test   %eax,%eax
  80367b:	74 0d                	je     80368a <insert_sorted_with_merge_freeList+0x457>
  80367d:	a1 48 51 80 00       	mov    0x805148,%eax
  803682:	8b 55 08             	mov    0x8(%ebp),%edx
  803685:	89 50 04             	mov    %edx,0x4(%eax)
  803688:	eb 08                	jmp    803692 <insert_sorted_with_merge_freeList+0x45f>
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803692:	8b 45 08             	mov    0x8(%ebp),%eax
  803695:	a3 48 51 80 00       	mov    %eax,0x805148
  80369a:	8b 45 08             	mov    0x8(%ebp),%eax
  80369d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036a4:	a1 54 51 80 00       	mov    0x805154,%eax
  8036a9:	40                   	inc    %eax
  8036aa:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  8036af:	e9 d8 02 00 00       	jmp    80398c <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  8036b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b7:	8b 50 08             	mov    0x8(%eax),%edx
  8036ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8036c0:	01 c2                	add    %eax,%edx
  8036c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c5:	8b 40 08             	mov    0x8(%eax),%eax
  8036c8:	39 c2                	cmp    %eax,%edx
  8036ca:	0f 85 ba 00 00 00    	jne    80378a <insert_sorted_with_merge_freeList+0x557>
  8036d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d3:	8b 50 08             	mov    0x8(%eax),%edx
  8036d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d9:	8b 48 08             	mov    0x8(%eax),%ecx
  8036dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036df:	8b 40 0c             	mov    0xc(%eax),%eax
  8036e2:	01 c8                	add    %ecx,%eax
  8036e4:	39 c2                	cmp    %eax,%edx
  8036e6:	0f 86 9e 00 00 00    	jbe    80378a <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  8036ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ef:	8b 50 0c             	mov    0xc(%eax),%edx
  8036f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8036f8:	01 c2                	add    %eax,%edx
  8036fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fd:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  803700:	8b 45 08             	mov    0x8(%ebp),%eax
  803703:	8b 50 08             	mov    0x8(%eax),%edx
  803706:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803709:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  80370c:	8b 45 08             	mov    0x8(%ebp),%eax
  80370f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803716:	8b 45 08             	mov    0x8(%ebp),%eax
  803719:	8b 50 08             	mov    0x8(%eax),%edx
  80371c:	8b 45 08             	mov    0x8(%ebp),%eax
  80371f:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803722:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803726:	75 17                	jne    80373f <insert_sorted_with_merge_freeList+0x50c>
  803728:	83 ec 04             	sub    $0x4,%esp
  80372b:	68 90 47 80 00       	push   $0x804790
  803730:	68 5b 01 00 00       	push   $0x15b
  803735:	68 b3 47 80 00       	push   $0x8047b3
  80373a:	e8 48 d5 ff ff       	call   800c87 <_panic>
  80373f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803745:	8b 45 08             	mov    0x8(%ebp),%eax
  803748:	89 10                	mov    %edx,(%eax)
  80374a:	8b 45 08             	mov    0x8(%ebp),%eax
  80374d:	8b 00                	mov    (%eax),%eax
  80374f:	85 c0                	test   %eax,%eax
  803751:	74 0d                	je     803760 <insert_sorted_with_merge_freeList+0x52d>
  803753:	a1 48 51 80 00       	mov    0x805148,%eax
  803758:	8b 55 08             	mov    0x8(%ebp),%edx
  80375b:	89 50 04             	mov    %edx,0x4(%eax)
  80375e:	eb 08                	jmp    803768 <insert_sorted_with_merge_freeList+0x535>
  803760:	8b 45 08             	mov    0x8(%ebp),%eax
  803763:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803768:	8b 45 08             	mov    0x8(%ebp),%eax
  80376b:	a3 48 51 80 00       	mov    %eax,0x805148
  803770:	8b 45 08             	mov    0x8(%ebp),%eax
  803773:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80377a:	a1 54 51 80 00       	mov    0x805154,%eax
  80377f:	40                   	inc    %eax
  803780:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803785:	e9 02 02 00 00       	jmp    80398c <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80378a:	8b 45 08             	mov    0x8(%ebp),%eax
  80378d:	8b 50 08             	mov    0x8(%eax),%edx
  803790:	8b 45 08             	mov    0x8(%ebp),%eax
  803793:	8b 40 0c             	mov    0xc(%eax),%eax
  803796:	01 c2                	add    %eax,%edx
  803798:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379b:	8b 40 08             	mov    0x8(%eax),%eax
  80379e:	39 c2                	cmp    %eax,%edx
  8037a0:	0f 85 ae 01 00 00    	jne    803954 <insert_sorted_with_merge_freeList+0x721>
  8037a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a9:	8b 50 08             	mov    0x8(%eax),%edx
  8037ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037af:	8b 48 08             	mov    0x8(%eax),%ecx
  8037b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8037b8:	01 c8                	add    %ecx,%eax
  8037ba:	39 c2                	cmp    %eax,%edx
  8037bc:	0f 85 92 01 00 00    	jne    803954 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  8037c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c5:	8b 50 0c             	mov    0xc(%eax),%edx
  8037c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8037ce:	01 c2                	add    %eax,%edx
  8037d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8037d6:	01 c2                	add    %eax,%edx
  8037d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037db:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  8037de:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8037e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037eb:	8b 50 08             	mov    0x8(%eax),%edx
  8037ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f1:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  8037f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8037fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803801:	8b 50 08             	mov    0x8(%eax),%edx
  803804:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803807:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  80380a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80380e:	75 17                	jne    803827 <insert_sorted_with_merge_freeList+0x5f4>
  803810:	83 ec 04             	sub    $0x4,%esp
  803813:	68 5b 48 80 00       	push   $0x80485b
  803818:	68 63 01 00 00       	push   $0x163
  80381d:	68 b3 47 80 00       	push   $0x8047b3
  803822:	e8 60 d4 ff ff       	call   800c87 <_panic>
  803827:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382a:	8b 00                	mov    (%eax),%eax
  80382c:	85 c0                	test   %eax,%eax
  80382e:	74 10                	je     803840 <insert_sorted_with_merge_freeList+0x60d>
  803830:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803833:	8b 00                	mov    (%eax),%eax
  803835:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803838:	8b 52 04             	mov    0x4(%edx),%edx
  80383b:	89 50 04             	mov    %edx,0x4(%eax)
  80383e:	eb 0b                	jmp    80384b <insert_sorted_with_merge_freeList+0x618>
  803840:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803843:	8b 40 04             	mov    0x4(%eax),%eax
  803846:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80384b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384e:	8b 40 04             	mov    0x4(%eax),%eax
  803851:	85 c0                	test   %eax,%eax
  803853:	74 0f                	je     803864 <insert_sorted_with_merge_freeList+0x631>
  803855:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803858:	8b 40 04             	mov    0x4(%eax),%eax
  80385b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80385e:	8b 12                	mov    (%edx),%edx
  803860:	89 10                	mov    %edx,(%eax)
  803862:	eb 0a                	jmp    80386e <insert_sorted_with_merge_freeList+0x63b>
  803864:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803867:	8b 00                	mov    (%eax),%eax
  803869:	a3 38 51 80 00       	mov    %eax,0x805138
  80386e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803871:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803877:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803881:	a1 44 51 80 00       	mov    0x805144,%eax
  803886:	48                   	dec    %eax
  803887:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  80388c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803890:	75 17                	jne    8038a9 <insert_sorted_with_merge_freeList+0x676>
  803892:	83 ec 04             	sub    $0x4,%esp
  803895:	68 90 47 80 00       	push   $0x804790
  80389a:	68 64 01 00 00       	push   $0x164
  80389f:	68 b3 47 80 00       	push   $0x8047b3
  8038a4:	e8 de d3 ff ff       	call   800c87 <_panic>
  8038a9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b2:	89 10                	mov    %edx,(%eax)
  8038b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b7:	8b 00                	mov    (%eax),%eax
  8038b9:	85 c0                	test   %eax,%eax
  8038bb:	74 0d                	je     8038ca <insert_sorted_with_merge_freeList+0x697>
  8038bd:	a1 48 51 80 00       	mov    0x805148,%eax
  8038c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038c5:	89 50 04             	mov    %edx,0x4(%eax)
  8038c8:	eb 08                	jmp    8038d2 <insert_sorted_with_merge_freeList+0x69f>
  8038ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038cd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d5:	a3 48 51 80 00       	mov    %eax,0x805148
  8038da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038e4:	a1 54 51 80 00       	mov    0x805154,%eax
  8038e9:	40                   	inc    %eax
  8038ea:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8038ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038f3:	75 17                	jne    80390c <insert_sorted_with_merge_freeList+0x6d9>
  8038f5:	83 ec 04             	sub    $0x4,%esp
  8038f8:	68 90 47 80 00       	push   $0x804790
  8038fd:	68 65 01 00 00       	push   $0x165
  803902:	68 b3 47 80 00       	push   $0x8047b3
  803907:	e8 7b d3 ff ff       	call   800c87 <_panic>
  80390c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803912:	8b 45 08             	mov    0x8(%ebp),%eax
  803915:	89 10                	mov    %edx,(%eax)
  803917:	8b 45 08             	mov    0x8(%ebp),%eax
  80391a:	8b 00                	mov    (%eax),%eax
  80391c:	85 c0                	test   %eax,%eax
  80391e:	74 0d                	je     80392d <insert_sorted_with_merge_freeList+0x6fa>
  803920:	a1 48 51 80 00       	mov    0x805148,%eax
  803925:	8b 55 08             	mov    0x8(%ebp),%edx
  803928:	89 50 04             	mov    %edx,0x4(%eax)
  80392b:	eb 08                	jmp    803935 <insert_sorted_with_merge_freeList+0x702>
  80392d:	8b 45 08             	mov    0x8(%ebp),%eax
  803930:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803935:	8b 45 08             	mov    0x8(%ebp),%eax
  803938:	a3 48 51 80 00       	mov    %eax,0x805148
  80393d:	8b 45 08             	mov    0x8(%ebp),%eax
  803940:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803947:	a1 54 51 80 00       	mov    0x805154,%eax
  80394c:	40                   	inc    %eax
  80394d:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803952:	eb 38                	jmp    80398c <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803954:	a1 40 51 80 00       	mov    0x805140,%eax
  803959:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80395c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803960:	74 07                	je     803969 <insert_sorted_with_merge_freeList+0x736>
  803962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803965:	8b 00                	mov    (%eax),%eax
  803967:	eb 05                	jmp    80396e <insert_sorted_with_merge_freeList+0x73b>
  803969:	b8 00 00 00 00       	mov    $0x0,%eax
  80396e:	a3 40 51 80 00       	mov    %eax,0x805140
  803973:	a1 40 51 80 00       	mov    0x805140,%eax
  803978:	85 c0                	test   %eax,%eax
  80397a:	0f 85 a7 fb ff ff    	jne    803527 <insert_sorted_with_merge_freeList+0x2f4>
  803980:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803984:	0f 85 9d fb ff ff    	jne    803527 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  80398a:	eb 00                	jmp    80398c <insert_sorted_with_merge_freeList+0x759>
  80398c:	90                   	nop
  80398d:	c9                   	leave  
  80398e:	c3                   	ret    

0080398f <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80398f:	55                   	push   %ebp
  803990:	89 e5                	mov    %esp,%ebp
  803992:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803995:	8b 55 08             	mov    0x8(%ebp),%edx
  803998:	89 d0                	mov    %edx,%eax
  80399a:	c1 e0 02             	shl    $0x2,%eax
  80399d:	01 d0                	add    %edx,%eax
  80399f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039a6:	01 d0                	add    %edx,%eax
  8039a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039af:	01 d0                	add    %edx,%eax
  8039b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039b8:	01 d0                	add    %edx,%eax
  8039ba:	c1 e0 04             	shl    $0x4,%eax
  8039bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8039c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8039c7:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8039ca:	83 ec 0c             	sub    $0xc,%esp
  8039cd:	50                   	push   %eax
  8039ce:	e8 ee eb ff ff       	call   8025c1 <sys_get_virtual_time>
  8039d3:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8039d6:	eb 41                	jmp    803a19 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8039d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8039db:	83 ec 0c             	sub    $0xc,%esp
  8039de:	50                   	push   %eax
  8039df:	e8 dd eb ff ff       	call   8025c1 <sys_get_virtual_time>
  8039e4:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8039e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ed:	29 c2                	sub    %eax,%edx
  8039ef:	89 d0                	mov    %edx,%eax
  8039f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8039f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039fa:	89 d1                	mov    %edx,%ecx
  8039fc:	29 c1                	sub    %eax,%ecx
  8039fe:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803a01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a04:	39 c2                	cmp    %eax,%edx
  803a06:	0f 97 c0             	seta   %al
  803a09:	0f b6 c0             	movzbl %al,%eax
  803a0c:	29 c1                	sub    %eax,%ecx
  803a0e:	89 c8                	mov    %ecx,%eax
  803a10:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803a13:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a16:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803a1f:	72 b7                	jb     8039d8 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803a21:	90                   	nop
  803a22:	c9                   	leave  
  803a23:	c3                   	ret    

00803a24 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803a24:	55                   	push   %ebp
  803a25:	89 e5                	mov    %esp,%ebp
  803a27:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803a2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803a31:	eb 03                	jmp    803a36 <busy_wait+0x12>
  803a33:	ff 45 fc             	incl   -0x4(%ebp)
  803a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a39:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a3c:	72 f5                	jb     803a33 <busy_wait+0xf>
	return i;
  803a3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803a41:	c9                   	leave  
  803a42:	c3                   	ret    
  803a43:	90                   	nop

00803a44 <__udivdi3>:
  803a44:	55                   	push   %ebp
  803a45:	57                   	push   %edi
  803a46:	56                   	push   %esi
  803a47:	53                   	push   %ebx
  803a48:	83 ec 1c             	sub    $0x1c,%esp
  803a4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a5b:	89 ca                	mov    %ecx,%edx
  803a5d:	89 f8                	mov    %edi,%eax
  803a5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a63:	85 f6                	test   %esi,%esi
  803a65:	75 2d                	jne    803a94 <__udivdi3+0x50>
  803a67:	39 cf                	cmp    %ecx,%edi
  803a69:	77 65                	ja     803ad0 <__udivdi3+0x8c>
  803a6b:	89 fd                	mov    %edi,%ebp
  803a6d:	85 ff                	test   %edi,%edi
  803a6f:	75 0b                	jne    803a7c <__udivdi3+0x38>
  803a71:	b8 01 00 00 00       	mov    $0x1,%eax
  803a76:	31 d2                	xor    %edx,%edx
  803a78:	f7 f7                	div    %edi
  803a7a:	89 c5                	mov    %eax,%ebp
  803a7c:	31 d2                	xor    %edx,%edx
  803a7e:	89 c8                	mov    %ecx,%eax
  803a80:	f7 f5                	div    %ebp
  803a82:	89 c1                	mov    %eax,%ecx
  803a84:	89 d8                	mov    %ebx,%eax
  803a86:	f7 f5                	div    %ebp
  803a88:	89 cf                	mov    %ecx,%edi
  803a8a:	89 fa                	mov    %edi,%edx
  803a8c:	83 c4 1c             	add    $0x1c,%esp
  803a8f:	5b                   	pop    %ebx
  803a90:	5e                   	pop    %esi
  803a91:	5f                   	pop    %edi
  803a92:	5d                   	pop    %ebp
  803a93:	c3                   	ret    
  803a94:	39 ce                	cmp    %ecx,%esi
  803a96:	77 28                	ja     803ac0 <__udivdi3+0x7c>
  803a98:	0f bd fe             	bsr    %esi,%edi
  803a9b:	83 f7 1f             	xor    $0x1f,%edi
  803a9e:	75 40                	jne    803ae0 <__udivdi3+0x9c>
  803aa0:	39 ce                	cmp    %ecx,%esi
  803aa2:	72 0a                	jb     803aae <__udivdi3+0x6a>
  803aa4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803aa8:	0f 87 9e 00 00 00    	ja     803b4c <__udivdi3+0x108>
  803aae:	b8 01 00 00 00       	mov    $0x1,%eax
  803ab3:	89 fa                	mov    %edi,%edx
  803ab5:	83 c4 1c             	add    $0x1c,%esp
  803ab8:	5b                   	pop    %ebx
  803ab9:	5e                   	pop    %esi
  803aba:	5f                   	pop    %edi
  803abb:	5d                   	pop    %ebp
  803abc:	c3                   	ret    
  803abd:	8d 76 00             	lea    0x0(%esi),%esi
  803ac0:	31 ff                	xor    %edi,%edi
  803ac2:	31 c0                	xor    %eax,%eax
  803ac4:	89 fa                	mov    %edi,%edx
  803ac6:	83 c4 1c             	add    $0x1c,%esp
  803ac9:	5b                   	pop    %ebx
  803aca:	5e                   	pop    %esi
  803acb:	5f                   	pop    %edi
  803acc:	5d                   	pop    %ebp
  803acd:	c3                   	ret    
  803ace:	66 90                	xchg   %ax,%ax
  803ad0:	89 d8                	mov    %ebx,%eax
  803ad2:	f7 f7                	div    %edi
  803ad4:	31 ff                	xor    %edi,%edi
  803ad6:	89 fa                	mov    %edi,%edx
  803ad8:	83 c4 1c             	add    $0x1c,%esp
  803adb:	5b                   	pop    %ebx
  803adc:	5e                   	pop    %esi
  803add:	5f                   	pop    %edi
  803ade:	5d                   	pop    %ebp
  803adf:	c3                   	ret    
  803ae0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ae5:	89 eb                	mov    %ebp,%ebx
  803ae7:	29 fb                	sub    %edi,%ebx
  803ae9:	89 f9                	mov    %edi,%ecx
  803aeb:	d3 e6                	shl    %cl,%esi
  803aed:	89 c5                	mov    %eax,%ebp
  803aef:	88 d9                	mov    %bl,%cl
  803af1:	d3 ed                	shr    %cl,%ebp
  803af3:	89 e9                	mov    %ebp,%ecx
  803af5:	09 f1                	or     %esi,%ecx
  803af7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803afb:	89 f9                	mov    %edi,%ecx
  803afd:	d3 e0                	shl    %cl,%eax
  803aff:	89 c5                	mov    %eax,%ebp
  803b01:	89 d6                	mov    %edx,%esi
  803b03:	88 d9                	mov    %bl,%cl
  803b05:	d3 ee                	shr    %cl,%esi
  803b07:	89 f9                	mov    %edi,%ecx
  803b09:	d3 e2                	shl    %cl,%edx
  803b0b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b0f:	88 d9                	mov    %bl,%cl
  803b11:	d3 e8                	shr    %cl,%eax
  803b13:	09 c2                	or     %eax,%edx
  803b15:	89 d0                	mov    %edx,%eax
  803b17:	89 f2                	mov    %esi,%edx
  803b19:	f7 74 24 0c          	divl   0xc(%esp)
  803b1d:	89 d6                	mov    %edx,%esi
  803b1f:	89 c3                	mov    %eax,%ebx
  803b21:	f7 e5                	mul    %ebp
  803b23:	39 d6                	cmp    %edx,%esi
  803b25:	72 19                	jb     803b40 <__udivdi3+0xfc>
  803b27:	74 0b                	je     803b34 <__udivdi3+0xf0>
  803b29:	89 d8                	mov    %ebx,%eax
  803b2b:	31 ff                	xor    %edi,%edi
  803b2d:	e9 58 ff ff ff       	jmp    803a8a <__udivdi3+0x46>
  803b32:	66 90                	xchg   %ax,%ax
  803b34:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b38:	89 f9                	mov    %edi,%ecx
  803b3a:	d3 e2                	shl    %cl,%edx
  803b3c:	39 c2                	cmp    %eax,%edx
  803b3e:	73 e9                	jae    803b29 <__udivdi3+0xe5>
  803b40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b43:	31 ff                	xor    %edi,%edi
  803b45:	e9 40 ff ff ff       	jmp    803a8a <__udivdi3+0x46>
  803b4a:	66 90                	xchg   %ax,%ax
  803b4c:	31 c0                	xor    %eax,%eax
  803b4e:	e9 37 ff ff ff       	jmp    803a8a <__udivdi3+0x46>
  803b53:	90                   	nop

00803b54 <__umoddi3>:
  803b54:	55                   	push   %ebp
  803b55:	57                   	push   %edi
  803b56:	56                   	push   %esi
  803b57:	53                   	push   %ebx
  803b58:	83 ec 1c             	sub    $0x1c,%esp
  803b5b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b67:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b73:	89 f3                	mov    %esi,%ebx
  803b75:	89 fa                	mov    %edi,%edx
  803b77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b7b:	89 34 24             	mov    %esi,(%esp)
  803b7e:	85 c0                	test   %eax,%eax
  803b80:	75 1a                	jne    803b9c <__umoddi3+0x48>
  803b82:	39 f7                	cmp    %esi,%edi
  803b84:	0f 86 a2 00 00 00    	jbe    803c2c <__umoddi3+0xd8>
  803b8a:	89 c8                	mov    %ecx,%eax
  803b8c:	89 f2                	mov    %esi,%edx
  803b8e:	f7 f7                	div    %edi
  803b90:	89 d0                	mov    %edx,%eax
  803b92:	31 d2                	xor    %edx,%edx
  803b94:	83 c4 1c             	add    $0x1c,%esp
  803b97:	5b                   	pop    %ebx
  803b98:	5e                   	pop    %esi
  803b99:	5f                   	pop    %edi
  803b9a:	5d                   	pop    %ebp
  803b9b:	c3                   	ret    
  803b9c:	39 f0                	cmp    %esi,%eax
  803b9e:	0f 87 ac 00 00 00    	ja     803c50 <__umoddi3+0xfc>
  803ba4:	0f bd e8             	bsr    %eax,%ebp
  803ba7:	83 f5 1f             	xor    $0x1f,%ebp
  803baa:	0f 84 ac 00 00 00    	je     803c5c <__umoddi3+0x108>
  803bb0:	bf 20 00 00 00       	mov    $0x20,%edi
  803bb5:	29 ef                	sub    %ebp,%edi
  803bb7:	89 fe                	mov    %edi,%esi
  803bb9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bbd:	89 e9                	mov    %ebp,%ecx
  803bbf:	d3 e0                	shl    %cl,%eax
  803bc1:	89 d7                	mov    %edx,%edi
  803bc3:	89 f1                	mov    %esi,%ecx
  803bc5:	d3 ef                	shr    %cl,%edi
  803bc7:	09 c7                	or     %eax,%edi
  803bc9:	89 e9                	mov    %ebp,%ecx
  803bcb:	d3 e2                	shl    %cl,%edx
  803bcd:	89 14 24             	mov    %edx,(%esp)
  803bd0:	89 d8                	mov    %ebx,%eax
  803bd2:	d3 e0                	shl    %cl,%eax
  803bd4:	89 c2                	mov    %eax,%edx
  803bd6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bda:	d3 e0                	shl    %cl,%eax
  803bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803be0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803be4:	89 f1                	mov    %esi,%ecx
  803be6:	d3 e8                	shr    %cl,%eax
  803be8:	09 d0                	or     %edx,%eax
  803bea:	d3 eb                	shr    %cl,%ebx
  803bec:	89 da                	mov    %ebx,%edx
  803bee:	f7 f7                	div    %edi
  803bf0:	89 d3                	mov    %edx,%ebx
  803bf2:	f7 24 24             	mull   (%esp)
  803bf5:	89 c6                	mov    %eax,%esi
  803bf7:	89 d1                	mov    %edx,%ecx
  803bf9:	39 d3                	cmp    %edx,%ebx
  803bfb:	0f 82 87 00 00 00    	jb     803c88 <__umoddi3+0x134>
  803c01:	0f 84 91 00 00 00    	je     803c98 <__umoddi3+0x144>
  803c07:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c0b:	29 f2                	sub    %esi,%edx
  803c0d:	19 cb                	sbb    %ecx,%ebx
  803c0f:	89 d8                	mov    %ebx,%eax
  803c11:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c15:	d3 e0                	shl    %cl,%eax
  803c17:	89 e9                	mov    %ebp,%ecx
  803c19:	d3 ea                	shr    %cl,%edx
  803c1b:	09 d0                	or     %edx,%eax
  803c1d:	89 e9                	mov    %ebp,%ecx
  803c1f:	d3 eb                	shr    %cl,%ebx
  803c21:	89 da                	mov    %ebx,%edx
  803c23:	83 c4 1c             	add    $0x1c,%esp
  803c26:	5b                   	pop    %ebx
  803c27:	5e                   	pop    %esi
  803c28:	5f                   	pop    %edi
  803c29:	5d                   	pop    %ebp
  803c2a:	c3                   	ret    
  803c2b:	90                   	nop
  803c2c:	89 fd                	mov    %edi,%ebp
  803c2e:	85 ff                	test   %edi,%edi
  803c30:	75 0b                	jne    803c3d <__umoddi3+0xe9>
  803c32:	b8 01 00 00 00       	mov    $0x1,%eax
  803c37:	31 d2                	xor    %edx,%edx
  803c39:	f7 f7                	div    %edi
  803c3b:	89 c5                	mov    %eax,%ebp
  803c3d:	89 f0                	mov    %esi,%eax
  803c3f:	31 d2                	xor    %edx,%edx
  803c41:	f7 f5                	div    %ebp
  803c43:	89 c8                	mov    %ecx,%eax
  803c45:	f7 f5                	div    %ebp
  803c47:	89 d0                	mov    %edx,%eax
  803c49:	e9 44 ff ff ff       	jmp    803b92 <__umoddi3+0x3e>
  803c4e:	66 90                	xchg   %ax,%ax
  803c50:	89 c8                	mov    %ecx,%eax
  803c52:	89 f2                	mov    %esi,%edx
  803c54:	83 c4 1c             	add    $0x1c,%esp
  803c57:	5b                   	pop    %ebx
  803c58:	5e                   	pop    %esi
  803c59:	5f                   	pop    %edi
  803c5a:	5d                   	pop    %ebp
  803c5b:	c3                   	ret    
  803c5c:	3b 04 24             	cmp    (%esp),%eax
  803c5f:	72 06                	jb     803c67 <__umoddi3+0x113>
  803c61:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c65:	77 0f                	ja     803c76 <__umoddi3+0x122>
  803c67:	89 f2                	mov    %esi,%edx
  803c69:	29 f9                	sub    %edi,%ecx
  803c6b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c6f:	89 14 24             	mov    %edx,(%esp)
  803c72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c76:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c7a:	8b 14 24             	mov    (%esp),%edx
  803c7d:	83 c4 1c             	add    $0x1c,%esp
  803c80:	5b                   	pop    %ebx
  803c81:	5e                   	pop    %esi
  803c82:	5f                   	pop    %edi
  803c83:	5d                   	pop    %ebp
  803c84:	c3                   	ret    
  803c85:	8d 76 00             	lea    0x0(%esi),%esi
  803c88:	2b 04 24             	sub    (%esp),%eax
  803c8b:	19 fa                	sbb    %edi,%edx
  803c8d:	89 d1                	mov    %edx,%ecx
  803c8f:	89 c6                	mov    %eax,%esi
  803c91:	e9 71 ff ff ff       	jmp    803c07 <__umoddi3+0xb3>
  803c96:	66 90                	xchg   %ax,%ax
  803c98:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c9c:	72 ea                	jb     803c88 <__umoddi3+0x134>
  803c9e:	89 d9                	mov    %ebx,%ecx
  803ca0:	e9 62 ff ff ff       	jmp    803c07 <__umoddi3+0xb3>
