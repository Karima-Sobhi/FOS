
obj/user/tst_air_clerk:     file format elf32-i386


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
  800031:	e8 e7 05 00 00       	call   80061d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
#include <user/air.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 01 00 00    	sub    $0x19c,%esp
	int parentenvID = sys_getparentenvid();
  800044:	e8 17 20 00 00       	call   802060 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb 15 37 80 00       	mov    $0x803715,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb 1f 37 80 00       	mov    $0x80371f,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb 2b 37 80 00       	mov    $0x80372b,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb 3a 37 80 00       	mov    $0x80373a,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb 49 37 80 00       	mov    $0x803749,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb 5e 37 80 00       	mov    $0x80375e,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb 73 37 80 00       	mov    $0x803773,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb 84 37 80 00       	mov    $0x803784,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb 95 37 80 00       	mov    $0x803795,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb a6 37 80 00       	mov    $0x8037a6,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb af 37 80 00       	mov    $0x8037af,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb b9 37 80 00       	mov    $0x8037b9,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb c4 37 80 00       	mov    $0x8037c4,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb d0 37 80 00       	mov    $0x8037d0,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb da 37 80 00       	mov    $0x8037da,%ebx
  80019b:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001a0:	89 c7                	mov    %eax,%edi
  8001a2:	89 de                	mov    %ebx,%esi
  8001a4:	89 d1                	mov    %edx,%ecx
  8001a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a8:	c7 85 e3 fe ff ff 63 	movl   $0x72656c63,-0x11d(%ebp)
  8001af:	6c 65 72 
  8001b2:	66 c7 85 e7 fe ff ff 	movw   $0x6b,-0x119(%ebp)
  8001b9:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001bb:	8d 85 d5 fe ff ff    	lea    -0x12b(%ebp),%eax
  8001c1:	bb e4 37 80 00       	mov    $0x8037e4,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb f2 37 80 00       	mov    $0x8037f2,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb 01 38 80 00       	mov    $0x803801,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb 08 38 80 00       	mov    $0x803808,%ebx
  80020e:	ba 07 00 00 00       	mov    $0x7,%edx
  800213:	89 c7                	mov    %eax,%edi
  800215:	89 de                	mov    %ebx,%esi
  800217:	89 d1                	mov    %edx,%ecx
  800219:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * customers = sget(parentenvID, _customers);
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	8d 45 ae             	lea    -0x52(%ebp),%eax
  800221:	50                   	push   %eax
  800222:	ff 75 e4             	pushl  -0x1c(%ebp)
  800225:	e8 07 19 00 00       	call   801b31 <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 f2 18 00 00       	call   801b31 <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 dd 18 00 00       	call   801b31 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 c5 18 00 00       	call   801b31 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 ad 18 00 00       	call   801b31 <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 95 18 00 00       	call   801b31 <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 7d 18 00 00       	call   801b31 <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 65 18 00 00       	call   801b31 <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 4d 18 00 00       	call   801b31 <sget>
  8002e4:	83 c4 10             	add    $0x10,%esp
  8002e7:	89 45 c0             	mov    %eax,-0x40(%ebp)

	while(1==1)
	{
		int custId;
		//wait for a customer
		sys_waitSemaphore(parentenvID, _cust_ready);
  8002ea:	83 ec 08             	sub    $0x8,%esp
  8002ed:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  8002f3:	50                   	push   %eax
  8002f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f7:	e8 05 1c 00 00       	call   801f01 <sys_waitSemaphore>
  8002fc:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		sys_waitSemaphore(parentenvID, _custQueueCS);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800308:	50                   	push   %eax
  800309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030c:	e8 f0 1b 00 00       	call   801f01 <sys_waitSemaphore>
  800311:	83 c4 10             	add    $0x10,%esp
		{
			//cprintf("*queue_out = %d\n", *queue_out);
			custId = cust_ready_queue[*queue_out];
  800314:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800317:	8b 00                	mov    (%eax),%eax
  800319:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800320:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800323:	01 d0                	add    %edx,%eax
  800325:	8b 00                	mov    (%eax),%eax
  800327:	89 45 bc             	mov    %eax,-0x44(%ebp)
			*queue_out = *queue_out +1;
  80032a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80032d:	8b 00                	mov    (%eax),%eax
  80032f:	8d 50 01             	lea    0x1(%eax),%edx
  800332:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800335:	89 10                	mov    %edx,(%eax)
		}
		sys_signalSemaphore(parentenvID, _custQueueCS);
  800337:	83 ec 08             	sub    $0x8,%esp
  80033a:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800340:	50                   	push   %eax
  800341:	ff 75 e4             	pushl  -0x1c(%ebp)
  800344:	e8 d6 1b 00 00       	call   801f1f <sys_signalSemaphore>
  800349:	83 c4 10             	add    $0x10,%esp

		//try reserving on the required flight
		int custFlightType = customers[custId].flightType;
  80034c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80034f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800356:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	8b 00                	mov    (%eax),%eax
  80035d:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//cprintf("custId dequeued = %d, ft = %d\n", custId, customers[custId].flightType);

		switch (custFlightType)
  800360:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800363:	83 f8 02             	cmp    $0x2,%eax
  800366:	0f 84 90 00 00 00    	je     8003fc <_main+0x3c4>
  80036c:	83 f8 03             	cmp    $0x3,%eax
  80036f:	0f 84 05 01 00 00    	je     80047a <_main+0x442>
  800375:	83 f8 01             	cmp    $0x1,%eax
  800378:	0f 85 f8 01 00 00    	jne    800576 <_main+0x53e>
		{
		case 1:
		{
			//Check and update Flight1
			sys_waitSemaphore(parentenvID, _flight1CS);
  80037e:	83 ec 08             	sub    $0x8,%esp
  800381:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800387:	50                   	push   %eax
  800388:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038b:	e8 71 1b 00 00       	call   801f01 <sys_waitSemaphore>
  800390:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0)
  800393:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	85 c0                	test   %eax,%eax
  80039a:	7e 46                	jle    8003e2 <_main+0x3aa>
				{
					*flight1Counter = *flight1Counter - 1;
  80039c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8003a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003a7:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8003a9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003ac:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b6:	01 d0                	add    %edx,%eax
  8003b8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8003bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c2:	8b 00                	mov    (%eax),%eax
  8003c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003ce:	01 c2                	add    %eax,%edx
  8003d0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d3:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8003d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d8:	8b 00                	mov    (%eax),%eax
  8003da:	8d 50 01             	lea    0x1(%eax),%edx
  8003dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003e0:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight1CS);
  8003e2:	83 ec 08             	sub    $0x8,%esp
  8003e5:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  8003eb:	50                   	push   %eax
  8003ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ef:	e8 2b 1b 00 00       	call   801f1f <sys_signalSemaphore>
  8003f4:	83 c4 10             	add    $0x10,%esp
		}

		break;
  8003f7:	e9 91 01 00 00       	jmp    80058d <_main+0x555>
		case 2:
		{
			//Check and update Flight2
			sys_waitSemaphore(parentenvID, _flight2CS);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800405:	50                   	push   %eax
  800406:	ff 75 e4             	pushl  -0x1c(%ebp)
  800409:	e8 f3 1a 00 00       	call   801f01 <sys_waitSemaphore>
  80040e:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight2Counter > 0)
  800411:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800414:	8b 00                	mov    (%eax),%eax
  800416:	85 c0                	test   %eax,%eax
  800418:	7e 46                	jle    800460 <_main+0x428>
				{
					*flight2Counter = *flight2Counter - 1;
  80041a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80041d:	8b 00                	mov    (%eax),%eax
  80041f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800422:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800425:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800427:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80042a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800434:	01 d0                	add    %edx,%eax
  800436:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  80043d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800449:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80044c:	01 c2                	add    %eax,%edx
  80044e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800451:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  800453:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800456:	8b 00                	mov    (%eax),%eax
  800458:	8d 50 01             	lea    0x1(%eax),%edx
  80045b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80045e:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight2CS);
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800469:	50                   	push   %eax
  80046a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80046d:	e8 ad 1a 00 00       	call   801f1f <sys_signalSemaphore>
  800472:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800475:	e9 13 01 00 00       	jmp    80058d <_main+0x555>
		case 3:
		{
			//Check and update Both Flights
			sys_waitSemaphore(parentenvID, _flight1CS); sys_waitSemaphore(parentenvID, _flight2CS);
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800483:	50                   	push   %eax
  800484:	ff 75 e4             	pushl  -0x1c(%ebp)
  800487:	e8 75 1a 00 00       	call   801f01 <sys_waitSemaphore>
  80048c:	83 c4 10             	add    $0x10,%esp
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800498:	50                   	push   %eax
  800499:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049c:	e8 60 1a 00 00       	call   801f01 <sys_waitSemaphore>
  8004a1:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0 && *flight2Counter >0 )
  8004a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	85 c0                	test   %eax,%eax
  8004ab:	0f 8e 99 00 00 00    	jle    80054a <_main+0x512>
  8004b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	85 c0                	test   %eax,%eax
  8004b8:	0f 8e 8c 00 00 00    	jle    80054a <_main+0x512>
				{
					*flight1Counter = *flight1Counter - 1;
  8004be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8004c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c9:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8004cb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d8:	01 d0                	add    %edx,%eax
  8004da:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8004e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004f0:	01 c2                	add    %eax,%edx
  8004f2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004f5:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8004f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	8d 50 01             	lea    0x1(%eax),%edx
  8004ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800502:	89 10                	mov    %edx,(%eax)

					*flight2Counter = *flight2Counter - 1;
  800504:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	8d 50 ff             	lea    -0x1(%eax),%edx
  80050c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80050f:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800511:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800514:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80051b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051e:	01 d0                	add    %edx,%eax
  800520:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  800527:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800533:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800536:	01 c2                	add    %eax,%edx
  800538:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80053b:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  80053d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	8d 50 01             	lea    0x1(%eax),%edx
  800545:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800548:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight2CS); sys_signalSemaphore(parentenvID, _flight1CS);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800553:	50                   	push   %eax
  800554:	ff 75 e4             	pushl  -0x1c(%ebp)
  800557:	e8 c3 19 00 00       	call   801f1f <sys_signalSemaphore>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800568:	50                   	push   %eax
  800569:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056c:	e8 ae 19 00 00       	call   801f1f <sys_signalSemaphore>
  800571:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800574:	eb 17                	jmp    80058d <_main+0x555>
		default:
			panic("customer must have flight type\n");
  800576:	83 ec 04             	sub    $0x4,%esp
  800579:	68 e0 36 80 00       	push   $0x8036e0
  80057e:	68 8f 00 00 00       	push   $0x8f
  800583:	68 00 37 80 00       	push   $0x803700
  800588:	e8 cc 01 00 00       	call   800759 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  80058d:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  800593:	bb 0f 38 80 00       	mov    $0x80380f,%ebx
  800598:	ba 0e 00 00 00       	mov    $0xe,%edx
  80059d:	89 c7                	mov    %eax,%edi
  80059f:	89 de                	mov    %ebx,%esi
  8005a1:	89 d1                	mov    %edx,%ecx
  8005a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8005a5:	8d 95 a8 fe ff ff    	lea    -0x158(%ebp),%edx
  8005ab:	b9 04 00 00 00       	mov    $0x4,%ecx
  8005b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b5:	89 d7                	mov    %edx,%edi
  8005b7:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  8005c2:	50                   	push   %eax
  8005c3:	ff 75 bc             	pushl  -0x44(%ebp)
  8005c6:	e8 6a 0f 00 00       	call   801535 <ltostr>
  8005cb:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8005ce:	83 ec 04             	sub    $0x4,%esp
  8005d1:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8005d7:	50                   	push   %eax
  8005d8:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  8005de:	50                   	push   %eax
  8005df:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8005e5:	50                   	push   %eax
  8005e6:	e8 42 10 00 00       	call   80162d <strcconcat>
  8005eb:	83 c4 10             	add    $0x10,%esp
		sys_signalSemaphore(parentenvID, sname);
  8005ee:	83 ec 08             	sub    $0x8,%esp
  8005f1:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8005f7:	50                   	push   %eax
  8005f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005fb:	e8 1f 19 00 00       	call   801f1f <sys_signalSemaphore>
  800600:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		sys_signalSemaphore(parentenvID, _clerk);
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80060c:	50                   	push   %eax
  80060d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800610:	e8 0a 19 00 00       	call   801f1f <sys_signalSemaphore>
  800615:	83 c4 10             	add    $0x10,%esp
	}
  800618:	e9 cd fc ff ff       	jmp    8002ea <_main+0x2b2>

0080061d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80061d:	55                   	push   %ebp
  80061e:	89 e5                	mov    %esp,%ebp
  800620:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800623:	e8 1f 1a 00 00       	call   802047 <sys_getenvindex>
  800628:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80062b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062e:	89 d0                	mov    %edx,%eax
  800630:	c1 e0 03             	shl    $0x3,%eax
  800633:	01 d0                	add    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800640:	01 d0                	add    %edx,%eax
  800642:	c1 e0 04             	shl    $0x4,%eax
  800645:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80064a:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80064f:	a1 20 50 80 00       	mov    0x805020,%eax
  800654:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80065a:	84 c0                	test   %al,%al
  80065c:	74 0f                	je     80066d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80065e:	a1 20 50 80 00       	mov    0x805020,%eax
  800663:	05 5c 05 00 00       	add    $0x55c,%eax
  800668:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80066d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800671:	7e 0a                	jle    80067d <libmain+0x60>
		binaryname = argv[0];
  800673:	8b 45 0c             	mov    0xc(%ebp),%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	ff 75 0c             	pushl  0xc(%ebp)
  800683:	ff 75 08             	pushl  0x8(%ebp)
  800686:	e8 ad f9 ff ff       	call   800038 <_main>
  80068b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80068e:	e8 c1 17 00 00       	call   801e54 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800693:	83 ec 0c             	sub    $0xc,%esp
  800696:	68 48 38 80 00       	push   $0x803848
  80069b:	e8 6d 03 00 00       	call   800a0d <cprintf>
  8006a0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8006b3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006b9:	83 ec 04             	sub    $0x4,%esp
  8006bc:	52                   	push   %edx
  8006bd:	50                   	push   %eax
  8006be:	68 70 38 80 00       	push   $0x803870
  8006c3:	e8 45 03 00 00       	call   800a0d <cprintf>
  8006c8:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8006d0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006db:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006e6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006ec:	51                   	push   %ecx
  8006ed:	52                   	push   %edx
  8006ee:	50                   	push   %eax
  8006ef:	68 98 38 80 00       	push   $0x803898
  8006f4:	e8 14 03 00 00       	call   800a0d <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800701:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	50                   	push   %eax
  80070b:	68 f0 38 80 00       	push   $0x8038f0
  800710:	e8 f8 02 00 00       	call   800a0d <cprintf>
  800715:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	68 48 38 80 00       	push   $0x803848
  800720:	e8 e8 02 00 00       	call   800a0d <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800728:	e8 41 17 00 00       	call   801e6e <sys_enable_interrupt>

	// exit gracefully
	exit();
  80072d:	e8 19 00 00 00       	call   80074b <exit>
}
  800732:	90                   	nop
  800733:	c9                   	leave  
  800734:	c3                   	ret    

00800735 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80073b:	83 ec 0c             	sub    $0xc,%esp
  80073e:	6a 00                	push   $0x0
  800740:	e8 ce 18 00 00       	call   802013 <sys_destroy_env>
  800745:	83 c4 10             	add    $0x10,%esp
}
  800748:	90                   	nop
  800749:	c9                   	leave  
  80074a:	c3                   	ret    

0080074b <exit>:

void
exit(void)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800751:	e8 23 19 00 00       	call   802079 <sys_exit_env>
}
  800756:	90                   	nop
  800757:	c9                   	leave  
  800758:	c3                   	ret    

00800759 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800759:	55                   	push   %ebp
  80075a:	89 e5                	mov    %esp,%ebp
  80075c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80075f:	8d 45 10             	lea    0x10(%ebp),%eax
  800762:	83 c0 04             	add    $0x4,%eax
  800765:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800768:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80076d:	85 c0                	test   %eax,%eax
  80076f:	74 16                	je     800787 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800771:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	50                   	push   %eax
  80077a:	68 04 39 80 00       	push   $0x803904
  80077f:	e8 89 02 00 00       	call   800a0d <cprintf>
  800784:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800787:	a1 00 50 80 00       	mov    0x805000,%eax
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	ff 75 08             	pushl  0x8(%ebp)
  800792:	50                   	push   %eax
  800793:	68 09 39 80 00       	push   $0x803909
  800798:	e8 70 02 00 00       	call   800a0d <cprintf>
  80079d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a9:	50                   	push   %eax
  8007aa:	e8 f3 01 00 00       	call   8009a2 <vcprintf>
  8007af:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	6a 00                	push   $0x0
  8007b7:	68 25 39 80 00       	push   $0x803925
  8007bc:	e8 e1 01 00 00       	call   8009a2 <vcprintf>
  8007c1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007c4:	e8 82 ff ff ff       	call   80074b <exit>

	// should not return here
	while (1) ;
  8007c9:	eb fe                	jmp    8007c9 <_panic+0x70>

008007cb <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8007d6:	8b 50 74             	mov    0x74(%eax),%edx
  8007d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007dc:	39 c2                	cmp    %eax,%edx
  8007de:	74 14                	je     8007f4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007e0:	83 ec 04             	sub    $0x4,%esp
  8007e3:	68 28 39 80 00       	push   $0x803928
  8007e8:	6a 26                	push   $0x26
  8007ea:	68 74 39 80 00       	push   $0x803974
  8007ef:	e8 65 ff ff ff       	call   800759 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800802:	e9 c2 00 00 00       	jmp    8008c9 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80080a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	01 d0                	add    %edx,%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	85 c0                	test   %eax,%eax
  80081a:	75 08                	jne    800824 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80081c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80081f:	e9 a2 00 00 00       	jmp    8008c6 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800824:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80082b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800832:	eb 69                	jmp    80089d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800834:	a1 20 50 80 00       	mov    0x805020,%eax
  800839:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80083f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800842:	89 d0                	mov    %edx,%eax
  800844:	01 c0                	add    %eax,%eax
  800846:	01 d0                	add    %edx,%eax
  800848:	c1 e0 03             	shl    $0x3,%eax
  80084b:	01 c8                	add    %ecx,%eax
  80084d:	8a 40 04             	mov    0x4(%eax),%al
  800850:	84 c0                	test   %al,%al
  800852:	75 46                	jne    80089a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800854:	a1 20 50 80 00       	mov    0x805020,%eax
  800859:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80085f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800862:	89 d0                	mov    %edx,%eax
  800864:	01 c0                	add    %eax,%eax
  800866:	01 d0                	add    %edx,%eax
  800868:	c1 e0 03             	shl    $0x3,%eax
  80086b:	01 c8                	add    %ecx,%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800872:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800875:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80087c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	01 c8                	add    %ecx,%eax
  80088b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088d:	39 c2                	cmp    %eax,%edx
  80088f:	75 09                	jne    80089a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800891:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800898:	eb 12                	jmp    8008ac <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80089a:	ff 45 e8             	incl   -0x18(%ebp)
  80089d:	a1 20 50 80 00       	mov    0x805020,%eax
  8008a2:	8b 50 74             	mov    0x74(%eax),%edx
  8008a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a8:	39 c2                	cmp    %eax,%edx
  8008aa:	77 88                	ja     800834 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008b0:	75 14                	jne    8008c6 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 80 39 80 00       	push   $0x803980
  8008ba:	6a 3a                	push   $0x3a
  8008bc:	68 74 39 80 00       	push   $0x803974
  8008c1:	e8 93 fe ff ff       	call   800759 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008c6:	ff 45 f0             	incl   -0x10(%ebp)
  8008c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008cf:	0f 8c 32 ff ff ff    	jl     800807 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008dc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008e3:	eb 26                	jmp    80090b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8008ea:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008f3:	89 d0                	mov    %edx,%eax
  8008f5:	01 c0                	add    %eax,%eax
  8008f7:	01 d0                	add    %edx,%eax
  8008f9:	c1 e0 03             	shl    $0x3,%eax
  8008fc:	01 c8                	add    %ecx,%eax
  8008fe:	8a 40 04             	mov    0x4(%eax),%al
  800901:	3c 01                	cmp    $0x1,%al
  800903:	75 03                	jne    800908 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800905:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800908:	ff 45 e0             	incl   -0x20(%ebp)
  80090b:	a1 20 50 80 00       	mov    0x805020,%eax
  800910:	8b 50 74             	mov    0x74(%eax),%edx
  800913:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800916:	39 c2                	cmp    %eax,%edx
  800918:	77 cb                	ja     8008e5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80091a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80091d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800920:	74 14                	je     800936 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800922:	83 ec 04             	sub    $0x4,%esp
  800925:	68 d4 39 80 00       	push   $0x8039d4
  80092a:	6a 44                	push   $0x44
  80092c:	68 74 39 80 00       	push   $0x803974
  800931:	e8 23 fe ff ff       	call   800759 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800936:	90                   	nop
  800937:	c9                   	leave  
  800938:	c3                   	ret    

00800939 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80093f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800942:	8b 00                	mov    (%eax),%eax
  800944:	8d 48 01             	lea    0x1(%eax),%ecx
  800947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094a:	89 0a                	mov    %ecx,(%edx)
  80094c:	8b 55 08             	mov    0x8(%ebp),%edx
  80094f:	88 d1                	mov    %dl,%cl
  800951:	8b 55 0c             	mov    0xc(%ebp),%edx
  800954:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800962:	75 2c                	jne    800990 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800964:	a0 24 50 80 00       	mov    0x805024,%al
  800969:	0f b6 c0             	movzbl %al,%eax
  80096c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096f:	8b 12                	mov    (%edx),%edx
  800971:	89 d1                	mov    %edx,%ecx
  800973:	8b 55 0c             	mov    0xc(%ebp),%edx
  800976:	83 c2 08             	add    $0x8,%edx
  800979:	83 ec 04             	sub    $0x4,%esp
  80097c:	50                   	push   %eax
  80097d:	51                   	push   %ecx
  80097e:	52                   	push   %edx
  80097f:	e8 22 13 00 00       	call   801ca6 <sys_cputs>
  800984:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	8b 40 04             	mov    0x4(%eax),%eax
  800996:	8d 50 01             	lea    0x1(%eax),%edx
  800999:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80099f:	90                   	nop
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009b2:	00 00 00 
	b.cnt = 0;
  8009b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009bc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	ff 75 08             	pushl  0x8(%ebp)
  8009c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009cb:	50                   	push   %eax
  8009cc:	68 39 09 80 00       	push   $0x800939
  8009d1:	e8 11 02 00 00       	call   800be7 <vprintfmt>
  8009d6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009d9:	a0 24 50 80 00       	mov    0x805024,%al
  8009de:	0f b6 c0             	movzbl %al,%eax
  8009e1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009e7:	83 ec 04             	sub    $0x4,%esp
  8009ea:	50                   	push   %eax
  8009eb:	52                   	push   %edx
  8009ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f2:	83 c0 08             	add    $0x8,%eax
  8009f5:	50                   	push   %eax
  8009f6:	e8 ab 12 00 00       	call   801ca6 <sys_cputs>
  8009fb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009fe:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800a05:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    

00800a0d <cprintf>:

int cprintf(const char *fmt, ...) {
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a13:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800a1a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	ff 75 f4             	pushl  -0xc(%ebp)
  800a29:	50                   	push   %eax
  800a2a:	e8 73 ff ff ff       	call   8009a2 <vcprintf>
  800a2f:	83 c4 10             	add    $0x10,%esp
  800a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a38:	c9                   	leave  
  800a39:	c3                   	ret    

00800a3a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a40:	e8 0f 14 00 00       	call   801e54 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a45:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 f4             	pushl  -0xc(%ebp)
  800a54:	50                   	push   %eax
  800a55:	e8 48 ff ff ff       	call   8009a2 <vcprintf>
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a60:	e8 09 14 00 00       	call   801e6e <sys_enable_interrupt>
	return cnt;
  800a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a68:	c9                   	leave  
  800a69:	c3                   	ret    

00800a6a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	53                   	push   %ebx
  800a6e:	83 ec 14             	sub    $0x14,%esp
  800a71:	8b 45 10             	mov    0x10(%ebp),%eax
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a7d:	8b 45 18             	mov    0x18(%ebp),%eax
  800a80:	ba 00 00 00 00       	mov    $0x0,%edx
  800a85:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a88:	77 55                	ja     800adf <printnum+0x75>
  800a8a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a8d:	72 05                	jb     800a94 <printnum+0x2a>
  800a8f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a92:	77 4b                	ja     800adf <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a94:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a97:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a9a:	8b 45 18             	mov    0x18(%ebp),%eax
  800a9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa2:	52                   	push   %edx
  800aa3:	50                   	push   %eax
  800aa4:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa7:	ff 75 f0             	pushl  -0x10(%ebp)
  800aaa:	e8 b5 29 00 00       	call   803464 <__udivdi3>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	83 ec 04             	sub    $0x4,%esp
  800ab5:	ff 75 20             	pushl  0x20(%ebp)
  800ab8:	53                   	push   %ebx
  800ab9:	ff 75 18             	pushl  0x18(%ebp)
  800abc:	52                   	push   %edx
  800abd:	50                   	push   %eax
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	ff 75 08             	pushl  0x8(%ebp)
  800ac4:	e8 a1 ff ff ff       	call   800a6a <printnum>
  800ac9:	83 c4 20             	add    $0x20,%esp
  800acc:	eb 1a                	jmp    800ae8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	ff 75 20             	pushl  0x20(%ebp)
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	ff d0                	call   *%eax
  800adc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800adf:	ff 4d 1c             	decl   0x1c(%ebp)
  800ae2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ae6:	7f e6                	jg     800ace <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ae8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800aeb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af6:	53                   	push   %ebx
  800af7:	51                   	push   %ecx
  800af8:	52                   	push   %edx
  800af9:	50                   	push   %eax
  800afa:	e8 75 2a 00 00       	call   803574 <__umoddi3>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	05 34 3c 80 00       	add    $0x803c34,%eax
  800b07:	8a 00                	mov    (%eax),%al
  800b09:	0f be c0             	movsbl %al,%eax
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	50                   	push   %eax
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	ff d0                	call   *%eax
  800b18:	83 c4 10             	add    $0x10,%esp
}
  800b1b:	90                   	nop
  800b1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b1f:	c9                   	leave  
  800b20:	c3                   	ret    

00800b21 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b24:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b28:	7e 1c                	jle    800b46 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	8b 00                	mov    (%eax),%eax
  800b2f:	8d 50 08             	lea    0x8(%eax),%edx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	89 10                	mov    %edx,(%eax)
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	83 e8 08             	sub    $0x8,%eax
  800b3f:	8b 50 04             	mov    0x4(%eax),%edx
  800b42:	8b 00                	mov    (%eax),%eax
  800b44:	eb 40                	jmp    800b86 <getuint+0x65>
	else if (lflag)
  800b46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4a:	74 1e                	je     800b6a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 00                	mov    (%eax),%eax
  800b51:	8d 50 04             	lea    0x4(%eax),%edx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	89 10                	mov    %edx,(%eax)
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	83 e8 04             	sub    $0x4,%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	ba 00 00 00 00       	mov    $0x0,%edx
  800b68:	eb 1c                	jmp    800b86 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8b 00                	mov    (%eax),%eax
  800b6f:	8d 50 04             	lea    0x4(%eax),%edx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	89 10                	mov    %edx,(%eax)
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	83 e8 04             	sub    $0x4,%eax
  800b7f:	8b 00                	mov    (%eax),%eax
  800b81:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b8b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b8f:	7e 1c                	jle    800bad <getint+0x25>
		return va_arg(*ap, long long);
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	8d 50 08             	lea    0x8(%eax),%edx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	89 10                	mov    %edx,(%eax)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8b 00                	mov    (%eax),%eax
  800ba3:	83 e8 08             	sub    $0x8,%eax
  800ba6:	8b 50 04             	mov    0x4(%eax),%edx
  800ba9:	8b 00                	mov    (%eax),%eax
  800bab:	eb 38                	jmp    800be5 <getint+0x5d>
	else if (lflag)
  800bad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb1:	74 1a                	je     800bcd <getint+0x45>
		return va_arg(*ap, long);
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8b 00                	mov    (%eax),%eax
  800bb8:	8d 50 04             	lea    0x4(%eax),%edx
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	89 10                	mov    %edx,(%eax)
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	8b 00                	mov    (%eax),%eax
  800bc5:	83 e8 04             	sub    $0x4,%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	99                   	cltd   
  800bcb:	eb 18                	jmp    800be5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	8d 50 04             	lea    0x4(%eax),%edx
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	89 10                	mov    %edx,(%eax)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	83 e8 04             	sub    $0x4,%eax
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	99                   	cltd   
}
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
  800bec:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bef:	eb 17                	jmp    800c08 <vprintfmt+0x21>
			if (ch == '\0')
  800bf1:	85 db                	test   %ebx,%ebx
  800bf3:	0f 84 af 03 00 00    	je     800fa8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bf9:	83 ec 08             	sub    $0x8,%esp
  800bfc:	ff 75 0c             	pushl  0xc(%ebp)
  800bff:	53                   	push   %ebx
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c08:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	0f b6 d8             	movzbl %al,%ebx
  800c16:	83 fb 25             	cmp    $0x25,%ebx
  800c19:	75 d6                	jne    800bf1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c1b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c1f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c26:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c2d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c34:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	8d 50 01             	lea    0x1(%eax),%edx
  800c41:	89 55 10             	mov    %edx,0x10(%ebp)
  800c44:	8a 00                	mov    (%eax),%al
  800c46:	0f b6 d8             	movzbl %al,%ebx
  800c49:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c4c:	83 f8 55             	cmp    $0x55,%eax
  800c4f:	0f 87 2b 03 00 00    	ja     800f80 <vprintfmt+0x399>
  800c55:	8b 04 85 58 3c 80 00 	mov    0x803c58(,%eax,4),%eax
  800c5c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c5e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c62:	eb d7                	jmp    800c3b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c64:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c68:	eb d1                	jmp    800c3b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c71:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c74:	89 d0                	mov    %edx,%eax
  800c76:	c1 e0 02             	shl    $0x2,%eax
  800c79:	01 d0                	add    %edx,%eax
  800c7b:	01 c0                	add    %eax,%eax
  800c7d:	01 d8                	add    %ebx,%eax
  800c7f:	83 e8 30             	sub    $0x30,%eax
  800c82:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	8a 00                	mov    (%eax),%al
  800c8a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c8d:	83 fb 2f             	cmp    $0x2f,%ebx
  800c90:	7e 3e                	jle    800cd0 <vprintfmt+0xe9>
  800c92:	83 fb 39             	cmp    $0x39,%ebx
  800c95:	7f 39                	jg     800cd0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c97:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c9a:	eb d5                	jmp    800c71 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9f:	83 c0 04             	add    $0x4,%eax
  800ca2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca8:	83 e8 04             	sub    $0x4,%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cb0:	eb 1f                	jmp    800cd1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cb6:	79 83                	jns    800c3b <vprintfmt+0x54>
				width = 0;
  800cb8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cbf:	e9 77 ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cc4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ccb:	e9 6b ff ff ff       	jmp    800c3b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cd0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cd5:	0f 89 60 ff ff ff    	jns    800c3b <vprintfmt+0x54>
				width = precision, precision = -1;
  800cdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ce1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ce8:	e9 4e ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ced:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cf0:	e9 46 ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf8:	83 c0 04             	add    $0x4,%eax
  800cfb:	89 45 14             	mov    %eax,0x14(%ebp)
  800cfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800d01:	83 e8 04             	sub    $0x4,%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	83 ec 08             	sub    $0x8,%esp
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	50                   	push   %eax
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	ff d0                	call   *%eax
  800d12:	83 c4 10             	add    $0x10,%esp
			break;
  800d15:	e9 89 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1d:	83 c0 04             	add    $0x4,%eax
  800d20:	89 45 14             	mov    %eax,0x14(%ebp)
  800d23:	8b 45 14             	mov    0x14(%ebp),%eax
  800d26:	83 e8 04             	sub    $0x4,%eax
  800d29:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d2b:	85 db                	test   %ebx,%ebx
  800d2d:	79 02                	jns    800d31 <vprintfmt+0x14a>
				err = -err;
  800d2f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d31:	83 fb 64             	cmp    $0x64,%ebx
  800d34:	7f 0b                	jg     800d41 <vprintfmt+0x15a>
  800d36:	8b 34 9d a0 3a 80 00 	mov    0x803aa0(,%ebx,4),%esi
  800d3d:	85 f6                	test   %esi,%esi
  800d3f:	75 19                	jne    800d5a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d41:	53                   	push   %ebx
  800d42:	68 45 3c 80 00       	push   $0x803c45
  800d47:	ff 75 0c             	pushl  0xc(%ebp)
  800d4a:	ff 75 08             	pushl  0x8(%ebp)
  800d4d:	e8 5e 02 00 00       	call   800fb0 <printfmt>
  800d52:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d55:	e9 49 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d5a:	56                   	push   %esi
  800d5b:	68 4e 3c 80 00       	push   $0x803c4e
  800d60:	ff 75 0c             	pushl  0xc(%ebp)
  800d63:	ff 75 08             	pushl  0x8(%ebp)
  800d66:	e8 45 02 00 00       	call   800fb0 <printfmt>
  800d6b:	83 c4 10             	add    $0x10,%esp
			break;
  800d6e:	e9 30 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d73:	8b 45 14             	mov    0x14(%ebp),%eax
  800d76:	83 c0 04             	add    $0x4,%eax
  800d79:	89 45 14             	mov    %eax,0x14(%ebp)
  800d7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7f:	83 e8 04             	sub    $0x4,%eax
  800d82:	8b 30                	mov    (%eax),%esi
  800d84:	85 f6                	test   %esi,%esi
  800d86:	75 05                	jne    800d8d <vprintfmt+0x1a6>
				p = "(null)";
  800d88:	be 51 3c 80 00       	mov    $0x803c51,%esi
			if (width > 0 && padc != '-')
  800d8d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d91:	7e 6d                	jle    800e00 <vprintfmt+0x219>
  800d93:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d97:	74 67                	je     800e00 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d9c:	83 ec 08             	sub    $0x8,%esp
  800d9f:	50                   	push   %eax
  800da0:	56                   	push   %esi
  800da1:	e8 0c 03 00 00       	call   8010b2 <strnlen>
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dac:	eb 16                	jmp    800dc4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dae:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800db2:	83 ec 08             	sub    $0x8,%esp
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	50                   	push   %eax
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	ff d0                	call   *%eax
  800dbe:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc1:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc8:	7f e4                	jg     800dae <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dca:	eb 34                	jmp    800e00 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dcc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dd0:	74 1c                	je     800dee <vprintfmt+0x207>
  800dd2:	83 fb 1f             	cmp    $0x1f,%ebx
  800dd5:	7e 05                	jle    800ddc <vprintfmt+0x1f5>
  800dd7:	83 fb 7e             	cmp    $0x7e,%ebx
  800dda:	7e 12                	jle    800dee <vprintfmt+0x207>
					putch('?', putdat);
  800ddc:	83 ec 08             	sub    $0x8,%esp
  800ddf:	ff 75 0c             	pushl  0xc(%ebp)
  800de2:	6a 3f                	push   $0x3f
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	ff d0                	call   *%eax
  800de9:	83 c4 10             	add    $0x10,%esp
  800dec:	eb 0f                	jmp    800dfd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dee:	83 ec 08             	sub    $0x8,%esp
  800df1:	ff 75 0c             	pushl  0xc(%ebp)
  800df4:	53                   	push   %ebx
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	ff d0                	call   *%eax
  800dfa:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dfd:	ff 4d e4             	decl   -0x1c(%ebp)
  800e00:	89 f0                	mov    %esi,%eax
  800e02:	8d 70 01             	lea    0x1(%eax),%esi
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	0f be d8             	movsbl %al,%ebx
  800e0a:	85 db                	test   %ebx,%ebx
  800e0c:	74 24                	je     800e32 <vprintfmt+0x24b>
  800e0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e12:	78 b8                	js     800dcc <vprintfmt+0x1e5>
  800e14:	ff 4d e0             	decl   -0x20(%ebp)
  800e17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e1b:	79 af                	jns    800dcc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e1d:	eb 13                	jmp    800e32 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e1f:	83 ec 08             	sub    $0x8,%esp
  800e22:	ff 75 0c             	pushl  0xc(%ebp)
  800e25:	6a 20                	push   $0x20
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	ff d0                	call   *%eax
  800e2c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e2f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e36:	7f e7                	jg     800e1f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e38:	e9 66 01 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	ff 75 e8             	pushl  -0x18(%ebp)
  800e43:	8d 45 14             	lea    0x14(%ebp),%eax
  800e46:	50                   	push   %eax
  800e47:	e8 3c fd ff ff       	call   800b88 <getint>
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e52:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5b:	85 d2                	test   %edx,%edx
  800e5d:	79 23                	jns    800e82 <vprintfmt+0x29b>
				putch('-', putdat);
  800e5f:	83 ec 08             	sub    $0x8,%esp
  800e62:	ff 75 0c             	pushl  0xc(%ebp)
  800e65:	6a 2d                	push   $0x2d
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	ff d0                	call   *%eax
  800e6c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e75:	f7 d8                	neg    %eax
  800e77:	83 d2 00             	adc    $0x0,%edx
  800e7a:	f7 da                	neg    %edx
  800e7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e89:	e9 bc 00 00 00       	jmp    800f4a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e8e:	83 ec 08             	sub    $0x8,%esp
  800e91:	ff 75 e8             	pushl  -0x18(%ebp)
  800e94:	8d 45 14             	lea    0x14(%ebp),%eax
  800e97:	50                   	push   %eax
  800e98:	e8 84 fc ff ff       	call   800b21 <getuint>
  800e9d:	83 c4 10             	add    $0x10,%esp
  800ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ea6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ead:	e9 98 00 00 00       	jmp    800f4a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	ff 75 0c             	pushl  0xc(%ebp)
  800eb8:	6a 58                	push   $0x58
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	ff d0                	call   *%eax
  800ebf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	6a 58                	push   $0x58
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	ff d0                	call   *%eax
  800ecf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ed2:	83 ec 08             	sub    $0x8,%esp
  800ed5:	ff 75 0c             	pushl  0xc(%ebp)
  800ed8:	6a 58                	push   $0x58
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	ff d0                	call   *%eax
  800edf:	83 c4 10             	add    $0x10,%esp
			break;
  800ee2:	e9 bc 00 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	ff 75 0c             	pushl  0xc(%ebp)
  800eed:	6a 30                	push   $0x30
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	ff d0                	call   *%eax
  800ef4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	6a 78                	push   $0x78
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	ff d0                	call   *%eax
  800f04:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f07:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0a:	83 c0 04             	add    $0x4,%eax
  800f0d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f10:	8b 45 14             	mov    0x14(%ebp),%eax
  800f13:	83 e8 04             	sub    $0x4,%eax
  800f16:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f22:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f29:	eb 1f                	jmp    800f4a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f2b:	83 ec 08             	sub    $0x8,%esp
  800f2e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f31:	8d 45 14             	lea    0x14(%ebp),%eax
  800f34:	50                   	push   %eax
  800f35:	e8 e7 fb ff ff       	call   800b21 <getuint>
  800f3a:	83 c4 10             	add    $0x10,%esp
  800f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f43:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f4a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f51:	83 ec 04             	sub    $0x4,%esp
  800f54:	52                   	push   %edx
  800f55:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f58:	50                   	push   %eax
  800f59:	ff 75 f4             	pushl  -0xc(%ebp)
  800f5c:	ff 75 f0             	pushl  -0x10(%ebp)
  800f5f:	ff 75 0c             	pushl  0xc(%ebp)
  800f62:	ff 75 08             	pushl  0x8(%ebp)
  800f65:	e8 00 fb ff ff       	call   800a6a <printnum>
  800f6a:	83 c4 20             	add    $0x20,%esp
			break;
  800f6d:	eb 34                	jmp    800fa3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f6f:	83 ec 08             	sub    $0x8,%esp
  800f72:	ff 75 0c             	pushl  0xc(%ebp)
  800f75:	53                   	push   %ebx
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	ff d0                	call   *%eax
  800f7b:	83 c4 10             	add    $0x10,%esp
			break;
  800f7e:	eb 23                	jmp    800fa3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f80:	83 ec 08             	sub    $0x8,%esp
  800f83:	ff 75 0c             	pushl  0xc(%ebp)
  800f86:	6a 25                	push   $0x25
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	ff d0                	call   *%eax
  800f8d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f90:	ff 4d 10             	decl   0x10(%ebp)
  800f93:	eb 03                	jmp    800f98 <vprintfmt+0x3b1>
  800f95:	ff 4d 10             	decl   0x10(%ebp)
  800f98:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9b:	48                   	dec    %eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	3c 25                	cmp    $0x25,%al
  800fa0:	75 f3                	jne    800f95 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fa2:	90                   	nop
		}
	}
  800fa3:	e9 47 fc ff ff       	jmp    800bef <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fa8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fa9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fac:	5b                   	pop    %ebx
  800fad:	5e                   	pop    %esi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fb6:	8d 45 10             	lea    0x10(%ebp),%eax
  800fb9:	83 c0 04             	add    $0x4,%eax
  800fbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc5:	50                   	push   %eax
  800fc6:	ff 75 0c             	pushl  0xc(%ebp)
  800fc9:	ff 75 08             	pushl  0x8(%ebp)
  800fcc:	e8 16 fc ff ff       	call   800be7 <vprintfmt>
  800fd1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fd4:	90                   	nop
  800fd5:	c9                   	leave  
  800fd6:	c3                   	ret    

00800fd7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdd:	8b 40 08             	mov    0x8(%eax),%eax
  800fe0:	8d 50 01             	lea    0x1(%eax),%edx
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fec:	8b 10                	mov    (%eax),%edx
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	8b 40 04             	mov    0x4(%eax),%eax
  800ff4:	39 c2                	cmp    %eax,%edx
  800ff6:	73 12                	jae    80100a <sprintputch+0x33>
		*b->buf++ = ch;
  800ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffb:	8b 00                	mov    (%eax),%eax
  800ffd:	8d 48 01             	lea    0x1(%eax),%ecx
  801000:	8b 55 0c             	mov    0xc(%ebp),%edx
  801003:	89 0a                	mov    %ecx,(%edx)
  801005:	8b 55 08             	mov    0x8(%ebp),%edx
  801008:	88 10                	mov    %dl,(%eax)
}
  80100a:	90                   	nop
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    

0080100d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	01 d0                	add    %edx,%eax
  801024:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801027:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80102e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801032:	74 06                	je     80103a <vsnprintf+0x2d>
  801034:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801038:	7f 07                	jg     801041 <vsnprintf+0x34>
		return -E_INVAL;
  80103a:	b8 03 00 00 00       	mov    $0x3,%eax
  80103f:	eb 20                	jmp    801061 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801041:	ff 75 14             	pushl  0x14(%ebp)
  801044:	ff 75 10             	pushl  0x10(%ebp)
  801047:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80104a:	50                   	push   %eax
  80104b:	68 d7 0f 80 00       	push   $0x800fd7
  801050:	e8 92 fb ff ff       	call   800be7 <vprintfmt>
  801055:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801058:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80105b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80105e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801061:	c9                   	leave  
  801062:	c3                   	ret    

00801063 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801069:	8d 45 10             	lea    0x10(%ebp),%eax
  80106c:	83 c0 04             	add    $0x4,%eax
  80106f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	ff 75 f4             	pushl  -0xc(%ebp)
  801078:	50                   	push   %eax
  801079:	ff 75 0c             	pushl  0xc(%ebp)
  80107c:	ff 75 08             	pushl  0x8(%ebp)
  80107f:	e8 89 ff ff ff       	call   80100d <vsnprintf>
  801084:	83 c4 10             	add    $0x10,%esp
  801087:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80108a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80108d:	c9                   	leave  
  80108e:	c3                   	ret    

0080108f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801095:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80109c:	eb 06                	jmp    8010a4 <strlen+0x15>
		n++;
  80109e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010a1:	ff 45 08             	incl   0x8(%ebp)
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	84 c0                	test   %al,%al
  8010ab:	75 f1                	jne    80109e <strlen+0xf>
		n++;
	return n;
  8010ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b0:	c9                   	leave  
  8010b1:	c3                   	ret    

008010b2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010bf:	eb 09                	jmp    8010ca <strnlen+0x18>
		n++;
  8010c1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010c4:	ff 45 08             	incl   0x8(%ebp)
  8010c7:	ff 4d 0c             	decl   0xc(%ebp)
  8010ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010ce:	74 09                	je     8010d9 <strnlen+0x27>
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	84 c0                	test   %al,%al
  8010d7:	75 e8                	jne    8010c1 <strnlen+0xf>
		n++;
	return n;
  8010d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010dc:	c9                   	leave  
  8010dd:	c3                   	ret    

008010de <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010ea:	90                   	nop
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8d 50 01             	lea    0x1(%eax),%edx
  8010f1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010fa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010fd:	8a 12                	mov    (%edx),%dl
  8010ff:	88 10                	mov    %dl,(%eax)
  801101:	8a 00                	mov    (%eax),%al
  801103:	84 c0                	test   %al,%al
  801105:	75 e4                	jne    8010eb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801107:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801118:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80111f:	eb 1f                	jmp    801140 <strncpy+0x34>
		*dst++ = *src;
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	8d 50 01             	lea    0x1(%eax),%edx
  801127:	89 55 08             	mov    %edx,0x8(%ebp)
  80112a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112d:	8a 12                	mov    (%edx),%dl
  80112f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801131:	8b 45 0c             	mov    0xc(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	84 c0                	test   %al,%al
  801138:	74 03                	je     80113d <strncpy+0x31>
			src++;
  80113a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80113d:	ff 45 fc             	incl   -0x4(%ebp)
  801140:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801143:	3b 45 10             	cmp    0x10(%ebp),%eax
  801146:	72 d9                	jb     801121 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801148:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801159:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115d:	74 30                	je     80118f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80115f:	eb 16                	jmp    801177 <strlcpy+0x2a>
			*dst++ = *src++;
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8d 50 01             	lea    0x1(%eax),%edx
  801167:	89 55 08             	mov    %edx,0x8(%ebp)
  80116a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801170:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801173:	8a 12                	mov    (%edx),%dl
  801175:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801177:	ff 4d 10             	decl   0x10(%ebp)
  80117a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117e:	74 09                	je     801189 <strlcpy+0x3c>
  801180:	8b 45 0c             	mov    0xc(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	84 c0                	test   %al,%al
  801187:	75 d8                	jne    801161 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80118f:	8b 55 08             	mov    0x8(%ebp),%edx
  801192:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801195:	29 c2                	sub    %eax,%edx
  801197:	89 d0                	mov    %edx,%eax
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80119e:	eb 06                	jmp    8011a6 <strcmp+0xb>
		p++, q++;
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	84 c0                	test   %al,%al
  8011ad:	74 0e                	je     8011bd <strcmp+0x22>
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	8a 10                	mov    (%eax),%dl
  8011b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	38 c2                	cmp    %al,%dl
  8011bb:	74 e3                	je     8011a0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	0f b6 d0             	movzbl %al,%edx
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	0f b6 c0             	movzbl %al,%eax
  8011cd:	29 c2                	sub    %eax,%edx
  8011cf:	89 d0                	mov    %edx,%eax
}
  8011d1:	5d                   	pop    %ebp
  8011d2:	c3                   	ret    

008011d3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011d6:	eb 09                	jmp    8011e1 <strncmp+0xe>
		n--, p++, q++;
  8011d8:	ff 4d 10             	decl   0x10(%ebp)
  8011db:	ff 45 08             	incl   0x8(%ebp)
  8011de:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e5:	74 17                	je     8011fe <strncmp+0x2b>
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	84 c0                	test   %al,%al
  8011ee:	74 0e                	je     8011fe <strncmp+0x2b>
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 10                	mov    (%eax),%dl
  8011f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	38 c2                	cmp    %al,%dl
  8011fc:	74 da                	je     8011d8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801202:	75 07                	jne    80120b <strncmp+0x38>
		return 0;
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
  801209:	eb 14                	jmp    80121f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	0f b6 d0             	movzbl %al,%edx
  801213:	8b 45 0c             	mov    0xc(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	0f b6 c0             	movzbl %al,%eax
  80121b:	29 c2                	sub    %eax,%edx
  80121d:	89 d0                	mov    %edx,%eax
}
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    

00801221 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	83 ec 04             	sub    $0x4,%esp
  801227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80122d:	eb 12                	jmp    801241 <strchr+0x20>
		if (*s == c)
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801237:	75 05                	jne    80123e <strchr+0x1d>
			return (char *) s;
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	eb 11                	jmp    80124f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80123e:	ff 45 08             	incl   0x8(%ebp)
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	84 c0                	test   %al,%al
  801248:	75 e5                	jne    80122f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80124a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80124f:	c9                   	leave  
  801250:	c3                   	ret    

00801251 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	83 ec 04             	sub    $0x4,%esp
  801257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80125d:	eb 0d                	jmp    80126c <strfind+0x1b>
		if (*s == c)
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801267:	74 0e                	je     801277 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801269:	ff 45 08             	incl   0x8(%ebp)
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	84 c0                	test   %al,%al
  801273:	75 ea                	jne    80125f <strfind+0xe>
  801275:	eb 01                	jmp    801278 <strfind+0x27>
		if (*s == c)
			break;
  801277:	90                   	nop
	return (char *) s;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801289:	8b 45 10             	mov    0x10(%ebp),%eax
  80128c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80128f:	eb 0e                	jmp    80129f <memset+0x22>
		*p++ = c;
  801291:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801294:	8d 50 01             	lea    0x1(%eax),%edx
  801297:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80129a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80129f:	ff 4d f8             	decl   -0x8(%ebp)
  8012a2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012a6:	79 e9                	jns    801291 <memset+0x14>
		*p++ = c;

	return v;
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8012bf:	eb 16                	jmp    8012d7 <memcpy+0x2a>
		*d++ = *s++;
  8012c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c4:	8d 50 01             	lea    0x1(%eax),%edx
  8012c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d3:	8a 12                	mov    (%edx),%dl
  8012d5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8012d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	75 dd                	jne    8012c1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801301:	73 50                	jae    801353 <memmove+0x6a>
  801303:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801306:	8b 45 10             	mov    0x10(%ebp),%eax
  801309:	01 d0                	add    %edx,%eax
  80130b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80130e:	76 43                	jbe    801353 <memmove+0x6a>
		s += n;
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801316:	8b 45 10             	mov    0x10(%ebp),%eax
  801319:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80131c:	eb 10                	jmp    80132e <memmove+0x45>
			*--d = *--s;
  80131e:	ff 4d f8             	decl   -0x8(%ebp)
  801321:	ff 4d fc             	decl   -0x4(%ebp)
  801324:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801327:	8a 10                	mov    (%eax),%dl
  801329:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80132e:	8b 45 10             	mov    0x10(%ebp),%eax
  801331:	8d 50 ff             	lea    -0x1(%eax),%edx
  801334:	89 55 10             	mov    %edx,0x10(%ebp)
  801337:	85 c0                	test   %eax,%eax
  801339:	75 e3                	jne    80131e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80133b:	eb 23                	jmp    801360 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80133d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801340:	8d 50 01             	lea    0x1(%eax),%edx
  801343:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801346:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801349:	8d 4a 01             	lea    0x1(%edx),%ecx
  80134c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80134f:	8a 12                	mov    (%edx),%dl
  801351:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	8d 50 ff             	lea    -0x1(%eax),%edx
  801359:	89 55 10             	mov    %edx,0x10(%ebp)
  80135c:	85 c0                	test   %eax,%eax
  80135e:	75 dd                	jne    80133d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801371:	8b 45 0c             	mov    0xc(%ebp),%eax
  801374:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801377:	eb 2a                	jmp    8013a3 <memcmp+0x3e>
		if (*s1 != *s2)
  801379:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137c:	8a 10                	mov    (%eax),%dl
  80137e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	38 c2                	cmp    %al,%dl
  801385:	74 16                	je     80139d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801387:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	0f b6 d0             	movzbl %al,%edx
  80138f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	0f b6 c0             	movzbl %al,%eax
  801397:	29 c2                	sub    %eax,%edx
  801399:	89 d0                	mov    %edx,%eax
  80139b:	eb 18                	jmp    8013b5 <memcmp+0x50>
		s1++, s2++;
  80139d:	ff 45 fc             	incl   -0x4(%ebp)
  8013a0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	75 c9                	jne    801379 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c3:	01 d0                	add    %edx,%eax
  8013c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013c8:	eb 15                	jmp    8013df <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	0f b6 d0             	movzbl %al,%edx
  8013d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d5:	0f b6 c0             	movzbl %al,%eax
  8013d8:	39 c2                	cmp    %eax,%edx
  8013da:	74 0d                	je     8013e9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013dc:	ff 45 08             	incl   0x8(%ebp)
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013e5:	72 e3                	jb     8013ca <memfind+0x13>
  8013e7:	eb 01                	jmp    8013ea <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013e9:	90                   	nop
	return (void *) s;
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801403:	eb 03                	jmp    801408 <strtol+0x19>
		s++;
  801405:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	3c 20                	cmp    $0x20,%al
  80140f:	74 f4                	je     801405 <strtol+0x16>
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	3c 09                	cmp    $0x9,%al
  801418:	74 eb                	je     801405 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	3c 2b                	cmp    $0x2b,%al
  801421:	75 05                	jne    801428 <strtol+0x39>
		s++;
  801423:	ff 45 08             	incl   0x8(%ebp)
  801426:	eb 13                	jmp    80143b <strtol+0x4c>
	else if (*s == '-')
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	3c 2d                	cmp    $0x2d,%al
  80142f:	75 0a                	jne    80143b <strtol+0x4c>
		s++, neg = 1;
  801431:	ff 45 08             	incl   0x8(%ebp)
  801434:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80143b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80143f:	74 06                	je     801447 <strtol+0x58>
  801441:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801445:	75 20                	jne    801467 <strtol+0x78>
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8a 00                	mov    (%eax),%al
  80144c:	3c 30                	cmp    $0x30,%al
  80144e:	75 17                	jne    801467 <strtol+0x78>
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	40                   	inc    %eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	3c 78                	cmp    $0x78,%al
  801458:	75 0d                	jne    801467 <strtol+0x78>
		s += 2, base = 16;
  80145a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80145e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801465:	eb 28                	jmp    80148f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801467:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80146b:	75 15                	jne    801482 <strtol+0x93>
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3c 30                	cmp    $0x30,%al
  801474:	75 0c                	jne    801482 <strtol+0x93>
		s++, base = 8;
  801476:	ff 45 08             	incl   0x8(%ebp)
  801479:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801480:	eb 0d                	jmp    80148f <strtol+0xa0>
	else if (base == 0)
  801482:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801486:	75 07                	jne    80148f <strtol+0xa0>
		base = 10;
  801488:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	3c 2f                	cmp    $0x2f,%al
  801496:	7e 19                	jle    8014b1 <strtol+0xc2>
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	3c 39                	cmp    $0x39,%al
  80149f:	7f 10                	jg     8014b1 <strtol+0xc2>
			dig = *s - '0';
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	0f be c0             	movsbl %al,%eax
  8014a9:	83 e8 30             	sub    $0x30,%eax
  8014ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014af:	eb 42                	jmp    8014f3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	8a 00                	mov    (%eax),%al
  8014b6:	3c 60                	cmp    $0x60,%al
  8014b8:	7e 19                	jle    8014d3 <strtol+0xe4>
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	8a 00                	mov    (%eax),%al
  8014bf:	3c 7a                	cmp    $0x7a,%al
  8014c1:	7f 10                	jg     8014d3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	0f be c0             	movsbl %al,%eax
  8014cb:	83 e8 57             	sub    $0x57,%eax
  8014ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014d1:	eb 20                	jmp    8014f3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	8a 00                	mov    (%eax),%al
  8014d8:	3c 40                	cmp    $0x40,%al
  8014da:	7e 39                	jle    801515 <strtol+0x126>
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	8a 00                	mov    (%eax),%al
  8014e1:	3c 5a                	cmp    $0x5a,%al
  8014e3:	7f 30                	jg     801515 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	0f be c0             	movsbl %al,%eax
  8014ed:	83 e8 37             	sub    $0x37,%eax
  8014f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f9:	7d 19                	jge    801514 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014fb:	ff 45 08             	incl   0x8(%ebp)
  8014fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801501:	0f af 45 10          	imul   0x10(%ebp),%eax
  801505:	89 c2                	mov    %eax,%edx
  801507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150a:	01 d0                	add    %edx,%eax
  80150c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80150f:	e9 7b ff ff ff       	jmp    80148f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801514:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801515:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801519:	74 08                	je     801523 <strtol+0x134>
		*endptr = (char *) s;
  80151b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151e:	8b 55 08             	mov    0x8(%ebp),%edx
  801521:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801523:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801527:	74 07                	je     801530 <strtol+0x141>
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152c:	f7 d8                	neg    %eax
  80152e:	eb 03                	jmp    801533 <strtol+0x144>
  801530:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <ltostr>:

void
ltostr(long value, char *str)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80153b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801542:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801549:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80154d:	79 13                	jns    801562 <ltostr+0x2d>
	{
		neg = 1;
  80154f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801556:	8b 45 0c             	mov    0xc(%ebp),%eax
  801559:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80155c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80155f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80156a:	99                   	cltd   
  80156b:	f7 f9                	idiv   %ecx
  80156d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801570:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801573:	8d 50 01             	lea    0x1(%eax),%edx
  801576:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801579:	89 c2                	mov    %eax,%edx
  80157b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157e:	01 d0                	add    %edx,%eax
  801580:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801583:	83 c2 30             	add    $0x30,%edx
  801586:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801588:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80158b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801590:	f7 e9                	imul   %ecx
  801592:	c1 fa 02             	sar    $0x2,%edx
  801595:	89 c8                	mov    %ecx,%eax
  801597:	c1 f8 1f             	sar    $0x1f,%eax
  80159a:	29 c2                	sub    %eax,%edx
  80159c:	89 d0                	mov    %edx,%eax
  80159e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015a4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015a9:	f7 e9                	imul   %ecx
  8015ab:	c1 fa 02             	sar    $0x2,%edx
  8015ae:	89 c8                	mov    %ecx,%eax
  8015b0:	c1 f8 1f             	sar    $0x1f,%eax
  8015b3:	29 c2                	sub    %eax,%edx
  8015b5:	89 d0                	mov    %edx,%eax
  8015b7:	c1 e0 02             	shl    $0x2,%eax
  8015ba:	01 d0                	add    %edx,%eax
  8015bc:	01 c0                	add    %eax,%eax
  8015be:	29 c1                	sub    %eax,%ecx
  8015c0:	89 ca                	mov    %ecx,%edx
  8015c2:	85 d2                	test   %edx,%edx
  8015c4:	75 9c                	jne    801562 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d0:	48                   	dec    %eax
  8015d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015d8:	74 3d                	je     801617 <ltostr+0xe2>
		start = 1 ;
  8015da:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015e1:	eb 34                	jmp    801617 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e9:	01 d0                	add    %edx,%eax
  8015eb:	8a 00                	mov    (%eax),%al
  8015ed:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	01 c2                	add    %eax,%edx
  8015f8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 c8                	add    %ecx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801604:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160a:	01 c2                	add    %eax,%edx
  80160c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80160f:	88 02                	mov    %al,(%edx)
		start++ ;
  801611:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801614:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80161d:	7c c4                	jl     8015e3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80161f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801622:	8b 45 0c             	mov    0xc(%ebp),%eax
  801625:	01 d0                	add    %edx,%eax
  801627:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80162a:	90                   	nop
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801633:	ff 75 08             	pushl  0x8(%ebp)
  801636:	e8 54 fa ff ff       	call   80108f <strlen>
  80163b:	83 c4 04             	add    $0x4,%esp
  80163e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801641:	ff 75 0c             	pushl  0xc(%ebp)
  801644:	e8 46 fa ff ff       	call   80108f <strlen>
  801649:	83 c4 04             	add    $0x4,%esp
  80164c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80164f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801656:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80165d:	eb 17                	jmp    801676 <strcconcat+0x49>
		final[s] = str1[s] ;
  80165f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	01 c2                	add    %eax,%edx
  801667:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	01 c8                	add    %ecx,%eax
  80166f:	8a 00                	mov    (%eax),%al
  801671:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801673:	ff 45 fc             	incl   -0x4(%ebp)
  801676:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801679:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80167c:	7c e1                	jl     80165f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80167e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801685:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80168c:	eb 1f                	jmp    8016ad <strcconcat+0x80>
		final[s++] = str2[i] ;
  80168e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801691:	8d 50 01             	lea    0x1(%eax),%edx
  801694:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801697:	89 c2                	mov    %eax,%edx
  801699:	8b 45 10             	mov    0x10(%ebp),%eax
  80169c:	01 c2                	add    %eax,%edx
  80169e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a4:	01 c8                	add    %ecx,%eax
  8016a6:	8a 00                	mov    (%eax),%al
  8016a8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016aa:	ff 45 f8             	incl   -0x8(%ebp)
  8016ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016b3:	7c d9                	jl     80168e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bb:	01 d0                	add    %edx,%eax
  8016bd:	c6 00 00             	movb   $0x0,(%eax)
}
  8016c0:	90                   	nop
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d2:	8b 00                	mov    (%eax),%eax
  8016d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	01 d0                	add    %edx,%eax
  8016e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016e6:	eb 0c                	jmp    8016f4 <strsplit+0x31>
			*string++ = 0;
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8d 50 01             	lea    0x1(%eax),%edx
  8016ee:	89 55 08             	mov    %edx,0x8(%ebp)
  8016f1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	8a 00                	mov    (%eax),%al
  8016f9:	84 c0                	test   %al,%al
  8016fb:	74 18                	je     801715 <strsplit+0x52>
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	8a 00                	mov    (%eax),%al
  801702:	0f be c0             	movsbl %al,%eax
  801705:	50                   	push   %eax
  801706:	ff 75 0c             	pushl  0xc(%ebp)
  801709:	e8 13 fb ff ff       	call   801221 <strchr>
  80170e:	83 c4 08             	add    $0x8,%esp
  801711:	85 c0                	test   %eax,%eax
  801713:	75 d3                	jne    8016e8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	84 c0                	test   %al,%al
  80171c:	74 5a                	je     801778 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80171e:	8b 45 14             	mov    0x14(%ebp),%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	83 f8 0f             	cmp    $0xf,%eax
  801726:	75 07                	jne    80172f <strsplit+0x6c>
		{
			return 0;
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
  80172d:	eb 66                	jmp    801795 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80172f:	8b 45 14             	mov    0x14(%ebp),%eax
  801732:	8b 00                	mov    (%eax),%eax
  801734:	8d 48 01             	lea    0x1(%eax),%ecx
  801737:	8b 55 14             	mov    0x14(%ebp),%edx
  80173a:	89 0a                	mov    %ecx,(%edx)
  80173c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801743:	8b 45 10             	mov    0x10(%ebp),%eax
  801746:	01 c2                	add    %eax,%edx
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80174d:	eb 03                	jmp    801752 <strsplit+0x8f>
			string++;
  80174f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	84 c0                	test   %al,%al
  801759:	74 8b                	je     8016e6 <strsplit+0x23>
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	0f be c0             	movsbl %al,%eax
  801763:	50                   	push   %eax
  801764:	ff 75 0c             	pushl  0xc(%ebp)
  801767:	e8 b5 fa ff ff       	call   801221 <strchr>
  80176c:	83 c4 08             	add    $0x8,%esp
  80176f:	85 c0                	test   %eax,%eax
  801771:	74 dc                	je     80174f <strsplit+0x8c>
			string++;
	}
  801773:	e9 6e ff ff ff       	jmp    8016e6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801778:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801779:	8b 45 14             	mov    0x14(%ebp),%eax
  80177c:	8b 00                	mov    (%eax),%eax
  80177e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 d0                	add    %edx,%eax
  80178a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801790:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80179d:	a1 04 50 80 00       	mov    0x805004,%eax
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	74 1f                	je     8017c5 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8017a6:	e8 1d 00 00 00       	call   8017c8 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8017ab:	83 ec 0c             	sub    $0xc,%esp
  8017ae:	68 b0 3d 80 00       	push   $0x803db0
  8017b3:	e8 55 f2 ff ff       	call   800a0d <cprintf>
  8017b8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8017bb:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8017c2:	00 00 00 
	}
}
  8017c5:	90                   	nop
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8017ce:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8017d5:	00 00 00 
  8017d8:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8017df:	00 00 00 
  8017e2:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8017e9:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  8017ec:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8017f3:	00 00 00 
  8017f6:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8017fd:	00 00 00 
  801800:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801807:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  80180a:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801811:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801814:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80181b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801823:	2d 00 10 00 00       	sub    $0x1000,%eax
  801828:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  80182d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801834:	a1 20 51 80 00       	mov    0x805120,%eax
  801839:	c1 e0 04             	shl    $0x4,%eax
  80183c:	89 c2                	mov    %eax,%edx
  80183e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801841:	01 d0                	add    %edx,%eax
  801843:	48                   	dec    %eax
  801844:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801847:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80184a:	ba 00 00 00 00       	mov    $0x0,%edx
  80184f:	f7 75 f0             	divl   -0x10(%ebp)
  801852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801855:	29 d0                	sub    %edx,%eax
  801857:	89 c2                	mov    %eax,%edx
  801859:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801860:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801863:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801868:	2d 00 10 00 00       	sub    $0x1000,%eax
  80186d:	83 ec 04             	sub    $0x4,%esp
  801870:	6a 06                	push   $0x6
  801872:	52                   	push   %edx
  801873:	50                   	push   %eax
  801874:	e8 71 05 00 00       	call   801dea <sys_allocate_chunk>
  801879:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80187c:	a1 20 51 80 00       	mov    0x805120,%eax
  801881:	83 ec 0c             	sub    $0xc,%esp
  801884:	50                   	push   %eax
  801885:	e8 e6 0b 00 00       	call   802470 <initialize_MemBlocksList>
  80188a:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  80188d:	a1 48 51 80 00       	mov    0x805148,%eax
  801892:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801895:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801899:	75 14                	jne    8018af <initialize_dyn_block_system+0xe7>
  80189b:	83 ec 04             	sub    $0x4,%esp
  80189e:	68 d5 3d 80 00       	push   $0x803dd5
  8018a3:	6a 2b                	push   $0x2b
  8018a5:	68 f3 3d 80 00       	push   $0x803df3
  8018aa:	e8 aa ee ff ff       	call   800759 <_panic>
  8018af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018b2:	8b 00                	mov    (%eax),%eax
  8018b4:	85 c0                	test   %eax,%eax
  8018b6:	74 10                	je     8018c8 <initialize_dyn_block_system+0x100>
  8018b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018bb:	8b 00                	mov    (%eax),%eax
  8018bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018c0:	8b 52 04             	mov    0x4(%edx),%edx
  8018c3:	89 50 04             	mov    %edx,0x4(%eax)
  8018c6:	eb 0b                	jmp    8018d3 <initialize_dyn_block_system+0x10b>
  8018c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018cb:	8b 40 04             	mov    0x4(%eax),%eax
  8018ce:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8018d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018d6:	8b 40 04             	mov    0x4(%eax),%eax
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	74 0f                	je     8018ec <initialize_dyn_block_system+0x124>
  8018dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018e0:	8b 40 04             	mov    0x4(%eax),%eax
  8018e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018e6:	8b 12                	mov    (%edx),%edx
  8018e8:	89 10                	mov    %edx,(%eax)
  8018ea:	eb 0a                	jmp    8018f6 <initialize_dyn_block_system+0x12e>
  8018ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018ef:	8b 00                	mov    (%eax),%eax
  8018f1:	a3 48 51 80 00       	mov    %eax,0x805148
  8018f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801902:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801909:	a1 54 51 80 00       	mov    0x805154,%eax
  80190e:	48                   	dec    %eax
  80190f:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801914:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801917:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  80191e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801921:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801928:	83 ec 0c             	sub    $0xc,%esp
  80192b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80192e:	e8 d2 13 00 00       	call   802d05 <insert_sorted_with_merge_freeList>
  801933:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801936:	90                   	nop
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80193f:	e8 53 fe ff ff       	call   801797 <InitializeUHeap>
	if (size == 0) return NULL ;
  801944:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801948:	75 07                	jne    801951 <malloc+0x18>
  80194a:	b8 00 00 00 00       	mov    $0x0,%eax
  80194f:	eb 61                	jmp    8019b2 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801951:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801958:	8b 55 08             	mov    0x8(%ebp),%edx
  80195b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195e:	01 d0                	add    %edx,%eax
  801960:	48                   	dec    %eax
  801961:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801967:	ba 00 00 00 00       	mov    $0x0,%edx
  80196c:	f7 75 f4             	divl   -0xc(%ebp)
  80196f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801972:	29 d0                	sub    %edx,%eax
  801974:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801977:	e8 3c 08 00 00       	call   8021b8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80197c:	85 c0                	test   %eax,%eax
  80197e:	74 2d                	je     8019ad <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801980:	83 ec 0c             	sub    $0xc,%esp
  801983:	ff 75 08             	pushl  0x8(%ebp)
  801986:	e8 3e 0f 00 00       	call   8028c9 <alloc_block_FF>
  80198b:	83 c4 10             	add    $0x10,%esp
  80198e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801991:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801995:	74 16                	je     8019ad <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801997:	83 ec 0c             	sub    $0xc,%esp
  80199a:	ff 75 ec             	pushl  -0x14(%ebp)
  80199d:	e8 48 0c 00 00       	call   8025ea <insert_sorted_allocList>
  8019a2:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8019a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019a8:	8b 40 08             	mov    0x8(%eax),%eax
  8019ab:	eb 05                	jmp    8019b2 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8019ad:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019c8:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	83 ec 08             	sub    $0x8,%esp
  8019d1:	50                   	push   %eax
  8019d2:	68 40 50 80 00       	push   $0x805040
  8019d7:	e8 71 0b 00 00       	call   80254d <find_block>
  8019dc:	83 c4 10             	add    $0x10,%esp
  8019df:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  8019e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e5:	8b 50 0c             	mov    0xc(%eax),%edx
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	83 ec 08             	sub    $0x8,%esp
  8019ee:	52                   	push   %edx
  8019ef:	50                   	push   %eax
  8019f0:	e8 bd 03 00 00       	call   801db2 <sys_free_user_mem>
  8019f5:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  8019f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019fc:	75 14                	jne    801a12 <free+0x5e>
  8019fe:	83 ec 04             	sub    $0x4,%esp
  801a01:	68 d5 3d 80 00       	push   $0x803dd5
  801a06:	6a 71                	push   $0x71
  801a08:	68 f3 3d 80 00       	push   $0x803df3
  801a0d:	e8 47 ed ff ff       	call   800759 <_panic>
  801a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a15:	8b 00                	mov    (%eax),%eax
  801a17:	85 c0                	test   %eax,%eax
  801a19:	74 10                	je     801a2b <free+0x77>
  801a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1e:	8b 00                	mov    (%eax),%eax
  801a20:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a23:	8b 52 04             	mov    0x4(%edx),%edx
  801a26:	89 50 04             	mov    %edx,0x4(%eax)
  801a29:	eb 0b                	jmp    801a36 <free+0x82>
  801a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2e:	8b 40 04             	mov    0x4(%eax),%eax
  801a31:	a3 44 50 80 00       	mov    %eax,0x805044
  801a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a39:	8b 40 04             	mov    0x4(%eax),%eax
  801a3c:	85 c0                	test   %eax,%eax
  801a3e:	74 0f                	je     801a4f <free+0x9b>
  801a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a43:	8b 40 04             	mov    0x4(%eax),%eax
  801a46:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a49:	8b 12                	mov    (%edx),%edx
  801a4b:	89 10                	mov    %edx,(%eax)
  801a4d:	eb 0a                	jmp    801a59 <free+0xa5>
  801a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a52:	8b 00                	mov    (%eax),%eax
  801a54:	a3 40 50 80 00       	mov    %eax,0x805040
  801a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a6c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a71:	48                   	dec    %eax
  801a72:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801a77:	83 ec 0c             	sub    $0xc,%esp
  801a7a:	ff 75 f0             	pushl  -0x10(%ebp)
  801a7d:	e8 83 12 00 00       	call   802d05 <insert_sorted_with_merge_freeList>
  801a82:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801a85:	90                   	nop
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	83 ec 28             	sub    $0x28,%esp
  801a8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a91:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a94:	e8 fe fc ff ff       	call   801797 <InitializeUHeap>
	if (size == 0) return NULL ;
  801a99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a9d:	75 0a                	jne    801aa9 <smalloc+0x21>
  801a9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa4:	e9 86 00 00 00       	jmp    801b2f <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801aa9:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab6:	01 d0                	add    %edx,%eax
  801ab8:	48                   	dec    %eax
  801ab9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac4:	f7 75 f4             	divl   -0xc(%ebp)
  801ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aca:	29 d0                	sub    %edx,%eax
  801acc:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801acf:	e8 e4 06 00 00       	call   8021b8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ad4:	85 c0                	test   %eax,%eax
  801ad6:	74 52                	je     801b2a <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801ad8:	83 ec 0c             	sub    $0xc,%esp
  801adb:	ff 75 0c             	pushl  0xc(%ebp)
  801ade:	e8 e6 0d 00 00       	call   8028c9 <alloc_block_FF>
  801ae3:	83 c4 10             	add    $0x10,%esp
  801ae6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801ae9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801aed:	75 07                	jne    801af6 <smalloc+0x6e>
			return NULL ;
  801aef:	b8 00 00 00 00       	mov    $0x0,%eax
  801af4:	eb 39                	jmp    801b2f <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801af6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af9:	8b 40 08             	mov    0x8(%eax),%eax
  801afc:	89 c2                	mov    %eax,%edx
  801afe:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801b02:	52                   	push   %edx
  801b03:	50                   	push   %eax
  801b04:	ff 75 0c             	pushl  0xc(%ebp)
  801b07:	ff 75 08             	pushl  0x8(%ebp)
  801b0a:	e8 2e 04 00 00       	call   801f3d <sys_createSharedObject>
  801b0f:	83 c4 10             	add    $0x10,%esp
  801b12:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801b15:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b19:	79 07                	jns    801b22 <smalloc+0x9a>
			return (void*)NULL ;
  801b1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b20:	eb 0d                	jmp    801b2f <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b25:	8b 40 08             	mov    0x8(%eax),%eax
  801b28:	eb 05                	jmp    801b2f <smalloc+0xa7>
		}
		return (void*)NULL ;
  801b2a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b37:	e8 5b fc ff ff       	call   801797 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b3c:	83 ec 08             	sub    $0x8,%esp
  801b3f:	ff 75 0c             	pushl  0xc(%ebp)
  801b42:	ff 75 08             	pushl  0x8(%ebp)
  801b45:	e8 1d 04 00 00       	call   801f67 <sys_getSizeOfSharedObject>
  801b4a:	83 c4 10             	add    $0x10,%esp
  801b4d:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801b50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b54:	75 0a                	jne    801b60 <sget+0x2f>
			return NULL ;
  801b56:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5b:	e9 83 00 00 00       	jmp    801be3 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801b60:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6d:	01 d0                	add    %edx,%eax
  801b6f:	48                   	dec    %eax
  801b70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b76:	ba 00 00 00 00       	mov    $0x0,%edx
  801b7b:	f7 75 f0             	divl   -0x10(%ebp)
  801b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b81:	29 d0                	sub    %edx,%eax
  801b83:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b86:	e8 2d 06 00 00       	call   8021b8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b8b:	85 c0                	test   %eax,%eax
  801b8d:	74 4f                	je     801bde <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b92:	83 ec 0c             	sub    $0xc,%esp
  801b95:	50                   	push   %eax
  801b96:	e8 2e 0d 00 00       	call   8028c9 <alloc_block_FF>
  801b9b:	83 c4 10             	add    $0x10,%esp
  801b9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801ba1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ba5:	75 07                	jne    801bae <sget+0x7d>
					return (void*)NULL ;
  801ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bac:	eb 35                	jmp    801be3 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801bae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bb1:	8b 40 08             	mov    0x8(%eax),%eax
  801bb4:	83 ec 04             	sub    $0x4,%esp
  801bb7:	50                   	push   %eax
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	ff 75 08             	pushl  0x8(%ebp)
  801bbe:	e8 c1 03 00 00       	call   801f84 <sys_getSharedObject>
  801bc3:	83 c4 10             	add    $0x10,%esp
  801bc6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801bc9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bcd:	79 07                	jns    801bd6 <sget+0xa5>
				return (void*)NULL ;
  801bcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd4:	eb 0d                	jmp    801be3 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801bd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bd9:	8b 40 08             	mov    0x8(%eax),%eax
  801bdc:	eb 05                	jmp    801be3 <sget+0xb2>


		}
	return (void*)NULL ;
  801bde:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801beb:	e8 a7 fb ff ff       	call   801797 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801bf0:	83 ec 04             	sub    $0x4,%esp
  801bf3:	68 00 3e 80 00       	push   $0x803e00
  801bf8:	68 f9 00 00 00       	push   $0xf9
  801bfd:	68 f3 3d 80 00       	push   $0x803df3
  801c02:	e8 52 eb ff ff       	call   800759 <_panic>

00801c07 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c0d:	83 ec 04             	sub    $0x4,%esp
  801c10:	68 28 3e 80 00       	push   $0x803e28
  801c15:	68 0d 01 00 00       	push   $0x10d
  801c1a:	68 f3 3d 80 00       	push   $0x803df3
  801c1f:	e8 35 eb ff ff       	call   800759 <_panic>

00801c24 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
  801c27:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c2a:	83 ec 04             	sub    $0x4,%esp
  801c2d:	68 4c 3e 80 00       	push   $0x803e4c
  801c32:	68 18 01 00 00       	push   $0x118
  801c37:	68 f3 3d 80 00       	push   $0x803df3
  801c3c:	e8 18 eb ff ff       	call   800759 <_panic>

00801c41 <shrink>:

}
void shrink(uint32 newSize)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c47:	83 ec 04             	sub    $0x4,%esp
  801c4a:	68 4c 3e 80 00       	push   $0x803e4c
  801c4f:	68 1d 01 00 00       	push   $0x11d
  801c54:	68 f3 3d 80 00       	push   $0x803df3
  801c59:	e8 fb ea ff ff       	call   800759 <_panic>

00801c5e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c64:	83 ec 04             	sub    $0x4,%esp
  801c67:	68 4c 3e 80 00       	push   $0x803e4c
  801c6c:	68 22 01 00 00       	push   $0x122
  801c71:	68 f3 3d 80 00       	push   $0x803df3
  801c76:	e8 de ea ff ff       	call   800759 <_panic>

00801c7b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	57                   	push   %edi
  801c7f:	56                   	push   %esi
  801c80:	53                   	push   %ebx
  801c81:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c8d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c90:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c93:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c96:	cd 30                	int    $0x30
  801c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c9e:	83 c4 10             	add    $0x10,%esp
  801ca1:	5b                   	pop    %ebx
  801ca2:	5e                   	pop    %esi
  801ca3:	5f                   	pop    %edi
  801ca4:	5d                   	pop    %ebp
  801ca5:	c3                   	ret    

00801ca6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 04             	sub    $0x4,%esp
  801cac:	8b 45 10             	mov    0x10(%ebp),%eax
  801caf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cb2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	52                   	push   %edx
  801cbe:	ff 75 0c             	pushl  0xc(%ebp)
  801cc1:	50                   	push   %eax
  801cc2:	6a 00                	push   $0x0
  801cc4:	e8 b2 ff ff ff       	call   801c7b <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
}
  801ccc:	90                   	nop
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_cgetc>:

int
sys_cgetc(void)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 01                	push   $0x1
  801cde:	e8 98 ff ff ff       	call   801c7b <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	52                   	push   %edx
  801cf8:	50                   	push   %eax
  801cf9:	6a 05                	push   $0x5
  801cfb:	e8 7b ff ff ff       	call   801c7b <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	56                   	push   %esi
  801d09:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d0a:	8b 75 18             	mov    0x18(%ebp),%esi
  801d0d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d10:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d16:	8b 45 08             	mov    0x8(%ebp),%eax
  801d19:	56                   	push   %esi
  801d1a:	53                   	push   %ebx
  801d1b:	51                   	push   %ecx
  801d1c:	52                   	push   %edx
  801d1d:	50                   	push   %eax
  801d1e:	6a 06                	push   $0x6
  801d20:	e8 56 ff ff ff       	call   801c7b <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
}
  801d28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d2b:	5b                   	pop    %ebx
  801d2c:	5e                   	pop    %esi
  801d2d:	5d                   	pop    %ebp
  801d2e:	c3                   	ret    

00801d2f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	52                   	push   %edx
  801d3f:	50                   	push   %eax
  801d40:	6a 07                	push   $0x7
  801d42:	e8 34 ff ff ff       	call   801c7b <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	ff 75 0c             	pushl  0xc(%ebp)
  801d58:	ff 75 08             	pushl  0x8(%ebp)
  801d5b:	6a 08                	push   $0x8
  801d5d:	e8 19 ff ff ff       	call   801c7b <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 09                	push   $0x9
  801d76:	e8 00 ff ff ff       	call   801c7b <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 0a                	push   $0xa
  801d8f:	e8 e7 fe ff ff       	call   801c7b <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 0b                	push   $0xb
  801da8:	e8 ce fe ff ff       	call   801c7b <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	ff 75 0c             	pushl  0xc(%ebp)
  801dbe:	ff 75 08             	pushl  0x8(%ebp)
  801dc1:	6a 0f                	push   $0xf
  801dc3:	e8 b3 fe ff ff       	call   801c7b <syscall>
  801dc8:	83 c4 18             	add    $0x18,%esp
	return;
  801dcb:	90                   	nop
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	ff 75 0c             	pushl  0xc(%ebp)
  801dda:	ff 75 08             	pushl  0x8(%ebp)
  801ddd:	6a 10                	push   $0x10
  801ddf:	e8 97 fe ff ff       	call   801c7b <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
	return ;
  801de7:	90                   	nop
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	ff 75 10             	pushl  0x10(%ebp)
  801df4:	ff 75 0c             	pushl  0xc(%ebp)
  801df7:	ff 75 08             	pushl  0x8(%ebp)
  801dfa:	6a 11                	push   $0x11
  801dfc:	e8 7a fe ff ff       	call   801c7b <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
	return ;
  801e04:	90                   	nop
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 0c                	push   $0xc
  801e16:	e8 60 fe ff ff       	call   801c7b <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	ff 75 08             	pushl  0x8(%ebp)
  801e2e:	6a 0d                	push   $0xd
  801e30:	e8 46 fe ff ff       	call   801c7b <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 0e                	push   $0xe
  801e49:	e8 2d fe ff ff       	call   801c7b <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
}
  801e51:	90                   	nop
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 13                	push   $0x13
  801e63:	e8 13 fe ff ff       	call   801c7b <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
}
  801e6b:	90                   	nop
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 14                	push   $0x14
  801e7d:	e8 f9 fd ff ff       	call   801c7b <syscall>
  801e82:	83 c4 18             	add    $0x18,%esp
}
  801e85:	90                   	nop
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 04             	sub    $0x4,%esp
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e94:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	50                   	push   %eax
  801ea1:	6a 15                	push   $0x15
  801ea3:	e8 d3 fd ff ff       	call   801c7b <syscall>
  801ea8:	83 c4 18             	add    $0x18,%esp
}
  801eab:	90                   	nop
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 16                	push   $0x16
  801ebd:	e8 b9 fd ff ff       	call   801c7b <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	90                   	nop
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	ff 75 0c             	pushl  0xc(%ebp)
  801ed7:	50                   	push   %eax
  801ed8:	6a 17                	push   $0x17
  801eda:	e8 9c fd ff ff       	call   801c7b <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ee7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	52                   	push   %edx
  801ef4:	50                   	push   %eax
  801ef5:	6a 1a                	push   $0x1a
  801ef7:	e8 7f fd ff ff       	call   801c7b <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	52                   	push   %edx
  801f11:	50                   	push   %eax
  801f12:	6a 18                	push   $0x18
  801f14:	e8 62 fd ff ff       	call   801c7b <syscall>
  801f19:	83 c4 18             	add    $0x18,%esp
}
  801f1c:	90                   	nop
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f25:	8b 45 08             	mov    0x8(%ebp),%eax
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	52                   	push   %edx
  801f2f:	50                   	push   %eax
  801f30:	6a 19                	push   $0x19
  801f32:	e8 44 fd ff ff       	call   801c7b <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
}
  801f3a:	90                   	nop
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 04             	sub    $0x4,%esp
  801f43:	8b 45 10             	mov    0x10(%ebp),%eax
  801f46:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f49:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f4c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f50:	8b 45 08             	mov    0x8(%ebp),%eax
  801f53:	6a 00                	push   $0x0
  801f55:	51                   	push   %ecx
  801f56:	52                   	push   %edx
  801f57:	ff 75 0c             	pushl  0xc(%ebp)
  801f5a:	50                   	push   %eax
  801f5b:	6a 1b                	push   $0x1b
  801f5d:	e8 19 fd ff ff       	call   801c7b <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	52                   	push   %edx
  801f77:	50                   	push   %eax
  801f78:	6a 1c                	push   $0x1c
  801f7a:	e8 fc fc ff ff       	call   801c7b <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f87:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	51                   	push   %ecx
  801f95:	52                   	push   %edx
  801f96:	50                   	push   %eax
  801f97:	6a 1d                	push   $0x1d
  801f99:	e8 dd fc ff ff       	call   801c7b <syscall>
  801f9e:	83 c4 18             	add    $0x18,%esp
}
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	52                   	push   %edx
  801fb3:	50                   	push   %eax
  801fb4:	6a 1e                	push   $0x1e
  801fb6:	e8 c0 fc ff ff       	call   801c7b <syscall>
  801fbb:	83 c4 18             	add    $0x18,%esp
}
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 1f                	push   $0x1f
  801fcf:	e8 a7 fc ff ff       	call   801c7b <syscall>
  801fd4:	83 c4 18             	add    $0x18,%esp
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	6a 00                	push   $0x0
  801fe1:	ff 75 14             	pushl  0x14(%ebp)
  801fe4:	ff 75 10             	pushl  0x10(%ebp)
  801fe7:	ff 75 0c             	pushl  0xc(%ebp)
  801fea:	50                   	push   %eax
  801feb:	6a 20                	push   $0x20
  801fed:	e8 89 fc ff ff       	call   801c7b <syscall>
  801ff2:	83 c4 18             	add    $0x18,%esp
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	50                   	push   %eax
  802006:	6a 21                	push   $0x21
  802008:	e8 6e fc ff ff       	call   801c7b <syscall>
  80200d:	83 c4 18             	add    $0x18,%esp
}
  802010:	90                   	nop
  802011:	c9                   	leave  
  802012:	c3                   	ret    

00802013 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802016:	8b 45 08             	mov    0x8(%ebp),%eax
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	50                   	push   %eax
  802022:	6a 22                	push   $0x22
  802024:	e8 52 fc ff ff       	call   801c7b <syscall>
  802029:	83 c4 18             	add    $0x18,%esp
}
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    

0080202e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 02                	push   $0x2
  80203d:	e8 39 fc ff ff       	call   801c7b <syscall>
  802042:	83 c4 18             	add    $0x18,%esp
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 03                	push   $0x3
  802056:	e8 20 fc ff ff       	call   801c7b <syscall>
  80205b:	83 c4 18             	add    $0x18,%esp
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 04                	push   $0x4
  80206f:	e8 07 fc ff ff       	call   801c7b <syscall>
  802074:	83 c4 18             	add    $0x18,%esp
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <sys_exit_env>:


void sys_exit_env(void)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 23                	push   $0x23
  802088:	e8 ee fb ff ff       	call   801c7b <syscall>
  80208d:	83 c4 18             	add    $0x18,%esp
}
  802090:	90                   	nop
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802099:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80209c:	8d 50 04             	lea    0x4(%eax),%edx
  80209f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	52                   	push   %edx
  8020a9:	50                   	push   %eax
  8020aa:	6a 24                	push   $0x24
  8020ac:	e8 ca fb ff ff       	call   801c7b <syscall>
  8020b1:	83 c4 18             	add    $0x18,%esp
	return result;
  8020b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020bd:	89 01                	mov    %eax,(%ecx)
  8020bf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	c9                   	leave  
  8020c6:	c2 04 00             	ret    $0x4

008020c9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	ff 75 10             	pushl  0x10(%ebp)
  8020d3:	ff 75 0c             	pushl  0xc(%ebp)
  8020d6:	ff 75 08             	pushl  0x8(%ebp)
  8020d9:	6a 12                	push   $0x12
  8020db:	e8 9b fb ff ff       	call   801c7b <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e3:	90                   	nop
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 25                	push   $0x25
  8020f5:	e8 81 fb ff ff       	call   801c7b <syscall>
  8020fa:	83 c4 18             	add    $0x18,%esp
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 04             	sub    $0x4,%esp
  802105:	8b 45 08             	mov    0x8(%ebp),%eax
  802108:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80210b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	50                   	push   %eax
  802118:	6a 26                	push   $0x26
  80211a:	e8 5c fb ff ff       	call   801c7b <syscall>
  80211f:	83 c4 18             	add    $0x18,%esp
	return ;
  802122:	90                   	nop
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <rsttst>:
void rsttst()
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 28                	push   $0x28
  802134:	e8 42 fb ff ff       	call   801c7b <syscall>
  802139:	83 c4 18             	add    $0x18,%esp
	return ;
  80213c:	90                   	nop
}
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
  802142:	83 ec 04             	sub    $0x4,%esp
  802145:	8b 45 14             	mov    0x14(%ebp),%eax
  802148:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80214b:	8b 55 18             	mov    0x18(%ebp),%edx
  80214e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802152:	52                   	push   %edx
  802153:	50                   	push   %eax
  802154:	ff 75 10             	pushl  0x10(%ebp)
  802157:	ff 75 0c             	pushl  0xc(%ebp)
  80215a:	ff 75 08             	pushl  0x8(%ebp)
  80215d:	6a 27                	push   $0x27
  80215f:	e8 17 fb ff ff       	call   801c7b <syscall>
  802164:	83 c4 18             	add    $0x18,%esp
	return ;
  802167:	90                   	nop
}
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <chktst>:
void chktst(uint32 n)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	ff 75 08             	pushl  0x8(%ebp)
  802178:	6a 29                	push   $0x29
  80217a:	e8 fc fa ff ff       	call   801c7b <syscall>
  80217f:	83 c4 18             	add    $0x18,%esp
	return ;
  802182:	90                   	nop
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <inctst>:

void inctst()
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 2a                	push   $0x2a
  802194:	e8 e2 fa ff ff       	call   801c7b <syscall>
  802199:	83 c4 18             	add    $0x18,%esp
	return ;
  80219c:	90                   	nop
}
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    

0080219f <gettst>:
uint32 gettst()
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 2b                	push   $0x2b
  8021ae:	e8 c8 fa ff ff       	call   801c7b <syscall>
  8021b3:	83 c4 18             	add    $0x18,%esp
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
  8021bb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 2c                	push   $0x2c
  8021ca:	e8 ac fa ff ff       	call   801c7b <syscall>
  8021cf:	83 c4 18             	add    $0x18,%esp
  8021d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021d5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021d9:	75 07                	jne    8021e2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021db:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e0:	eb 05                	jmp    8021e7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e7:	c9                   	leave  
  8021e8:	c3                   	ret    

008021e9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
  8021ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 2c                	push   $0x2c
  8021fb:	e8 7b fa ff ff       	call   801c7b <syscall>
  802200:	83 c4 18             	add    $0x18,%esp
  802203:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802206:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80220a:	75 07                	jne    802213 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80220c:	b8 01 00 00 00       	mov    $0x1,%eax
  802211:	eb 05                	jmp    802218 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802213:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 2c                	push   $0x2c
  80222c:	e8 4a fa ff ff       	call   801c7b <syscall>
  802231:	83 c4 18             	add    $0x18,%esp
  802234:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802237:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80223b:	75 07                	jne    802244 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80223d:	b8 01 00 00 00       	mov    $0x1,%eax
  802242:	eb 05                	jmp    802249 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802244:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
  80224e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 2c                	push   $0x2c
  80225d:	e8 19 fa ff ff       	call   801c7b <syscall>
  802262:	83 c4 18             	add    $0x18,%esp
  802265:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802268:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80226c:	75 07                	jne    802275 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80226e:	b8 01 00 00 00       	mov    $0x1,%eax
  802273:	eb 05                	jmp    80227a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802275:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80227a:	c9                   	leave  
  80227b:	c3                   	ret    

0080227c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80227c:	55                   	push   %ebp
  80227d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	ff 75 08             	pushl  0x8(%ebp)
  80228a:	6a 2d                	push   $0x2d
  80228c:	e8 ea f9 ff ff       	call   801c7b <syscall>
  802291:	83 c4 18             	add    $0x18,%esp
	return ;
  802294:	90                   	nop
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80229b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80229e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	6a 00                	push   $0x0
  8022a9:	53                   	push   %ebx
  8022aa:	51                   	push   %ecx
  8022ab:	52                   	push   %edx
  8022ac:	50                   	push   %eax
  8022ad:	6a 2e                	push   $0x2e
  8022af:	e8 c7 f9 ff ff       	call   801c7b <syscall>
  8022b4:	83 c4 18             	add    $0x18,%esp
}
  8022b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022ba:	c9                   	leave  
  8022bb:	c3                   	ret    

008022bc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	52                   	push   %edx
  8022cc:	50                   	push   %eax
  8022cd:	6a 2f                	push   $0x2f
  8022cf:	e8 a7 f9 ff ff       	call   801c7b <syscall>
  8022d4:	83 c4 18             	add    $0x18,%esp
}
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8022df:	83 ec 0c             	sub    $0xc,%esp
  8022e2:	68 5c 3e 80 00       	push   $0x803e5c
  8022e7:	e8 21 e7 ff ff       	call   800a0d <cprintf>
  8022ec:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022f6:	83 ec 0c             	sub    $0xc,%esp
  8022f9:	68 88 3e 80 00       	push   $0x803e88
  8022fe:	e8 0a e7 ff ff       	call   800a0d <cprintf>
  802303:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802306:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80230a:	a1 38 51 80 00       	mov    0x805138,%eax
  80230f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802312:	eb 56                	jmp    80236a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802314:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802318:	74 1c                	je     802336 <print_mem_block_lists+0x5d>
  80231a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231d:	8b 50 08             	mov    0x8(%eax),%edx
  802320:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802323:	8b 48 08             	mov    0x8(%eax),%ecx
  802326:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802329:	8b 40 0c             	mov    0xc(%eax),%eax
  80232c:	01 c8                	add    %ecx,%eax
  80232e:	39 c2                	cmp    %eax,%edx
  802330:	73 04                	jae    802336 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802332:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802339:	8b 50 08             	mov    0x8(%eax),%edx
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8b 40 0c             	mov    0xc(%eax),%eax
  802342:	01 c2                	add    %eax,%edx
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	8b 40 08             	mov    0x8(%eax),%eax
  80234a:	83 ec 04             	sub    $0x4,%esp
  80234d:	52                   	push   %edx
  80234e:	50                   	push   %eax
  80234f:	68 9d 3e 80 00       	push   $0x803e9d
  802354:	e8 b4 e6 ff ff       	call   800a0d <cprintf>
  802359:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80235c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802362:	a1 40 51 80 00       	mov    0x805140,%eax
  802367:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80236a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236e:	74 07                	je     802377 <print_mem_block_lists+0x9e>
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	8b 00                	mov    (%eax),%eax
  802375:	eb 05                	jmp    80237c <print_mem_block_lists+0xa3>
  802377:	b8 00 00 00 00       	mov    $0x0,%eax
  80237c:	a3 40 51 80 00       	mov    %eax,0x805140
  802381:	a1 40 51 80 00       	mov    0x805140,%eax
  802386:	85 c0                	test   %eax,%eax
  802388:	75 8a                	jne    802314 <print_mem_block_lists+0x3b>
  80238a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238e:	75 84                	jne    802314 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802390:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802394:	75 10                	jne    8023a6 <print_mem_block_lists+0xcd>
  802396:	83 ec 0c             	sub    $0xc,%esp
  802399:	68 ac 3e 80 00       	push   $0x803eac
  80239e:	e8 6a e6 ff ff       	call   800a0d <cprintf>
  8023a3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8023a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8023ad:	83 ec 0c             	sub    $0xc,%esp
  8023b0:	68 d0 3e 80 00       	push   $0x803ed0
  8023b5:	e8 53 e6 ff ff       	call   800a0d <cprintf>
  8023ba:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8023bd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023c1:	a1 40 50 80 00       	mov    0x805040,%eax
  8023c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c9:	eb 56                	jmp    802421 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023cf:	74 1c                	je     8023ed <print_mem_block_lists+0x114>
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	8b 50 08             	mov    0x8(%eax),%edx
  8023d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023da:	8b 48 08             	mov    0x8(%eax),%ecx
  8023dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e3:	01 c8                	add    %ecx,%eax
  8023e5:	39 c2                	cmp    %eax,%edx
  8023e7:	73 04                	jae    8023ed <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023e9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	8b 50 08             	mov    0x8(%eax),%edx
  8023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f9:	01 c2                	add    %eax,%edx
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	8b 40 08             	mov    0x8(%eax),%eax
  802401:	83 ec 04             	sub    $0x4,%esp
  802404:	52                   	push   %edx
  802405:	50                   	push   %eax
  802406:	68 9d 3e 80 00       	push   $0x803e9d
  80240b:	e8 fd e5 ff ff       	call   800a0d <cprintf>
  802410:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802419:	a1 48 50 80 00       	mov    0x805048,%eax
  80241e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802421:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802425:	74 07                	je     80242e <print_mem_block_lists+0x155>
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	8b 00                	mov    (%eax),%eax
  80242c:	eb 05                	jmp    802433 <print_mem_block_lists+0x15a>
  80242e:	b8 00 00 00 00       	mov    $0x0,%eax
  802433:	a3 48 50 80 00       	mov    %eax,0x805048
  802438:	a1 48 50 80 00       	mov    0x805048,%eax
  80243d:	85 c0                	test   %eax,%eax
  80243f:	75 8a                	jne    8023cb <print_mem_block_lists+0xf2>
  802441:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802445:	75 84                	jne    8023cb <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802447:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80244b:	75 10                	jne    80245d <print_mem_block_lists+0x184>
  80244d:	83 ec 0c             	sub    $0xc,%esp
  802450:	68 e8 3e 80 00       	push   $0x803ee8
  802455:	e8 b3 e5 ff ff       	call   800a0d <cprintf>
  80245a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80245d:	83 ec 0c             	sub    $0xc,%esp
  802460:	68 5c 3e 80 00       	push   $0x803e5c
  802465:	e8 a3 e5 ff ff       	call   800a0d <cprintf>
  80246a:	83 c4 10             	add    $0x10,%esp

}
  80246d:	90                   	nop
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
  802473:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802476:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80247d:	00 00 00 
  802480:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802487:	00 00 00 
  80248a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802491:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802494:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80249b:	e9 9e 00 00 00       	jmp    80253e <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8024a0:	a1 50 50 80 00       	mov    0x805050,%eax
  8024a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a8:	c1 e2 04             	shl    $0x4,%edx
  8024ab:	01 d0                	add    %edx,%eax
  8024ad:	85 c0                	test   %eax,%eax
  8024af:	75 14                	jne    8024c5 <initialize_MemBlocksList+0x55>
  8024b1:	83 ec 04             	sub    $0x4,%esp
  8024b4:	68 10 3f 80 00       	push   $0x803f10
  8024b9:	6a 43                	push   $0x43
  8024bb:	68 33 3f 80 00       	push   $0x803f33
  8024c0:	e8 94 e2 ff ff       	call   800759 <_panic>
  8024c5:	a1 50 50 80 00       	mov    0x805050,%eax
  8024ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024cd:	c1 e2 04             	shl    $0x4,%edx
  8024d0:	01 d0                	add    %edx,%eax
  8024d2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8024d8:	89 10                	mov    %edx,(%eax)
  8024da:	8b 00                	mov    (%eax),%eax
  8024dc:	85 c0                	test   %eax,%eax
  8024de:	74 18                	je     8024f8 <initialize_MemBlocksList+0x88>
  8024e0:	a1 48 51 80 00       	mov    0x805148,%eax
  8024e5:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8024eb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024ee:	c1 e1 04             	shl    $0x4,%ecx
  8024f1:	01 ca                	add    %ecx,%edx
  8024f3:	89 50 04             	mov    %edx,0x4(%eax)
  8024f6:	eb 12                	jmp    80250a <initialize_MemBlocksList+0x9a>
  8024f8:	a1 50 50 80 00       	mov    0x805050,%eax
  8024fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802500:	c1 e2 04             	shl    $0x4,%edx
  802503:	01 d0                	add    %edx,%eax
  802505:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80250a:	a1 50 50 80 00       	mov    0x805050,%eax
  80250f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802512:	c1 e2 04             	shl    $0x4,%edx
  802515:	01 d0                	add    %edx,%eax
  802517:	a3 48 51 80 00       	mov    %eax,0x805148
  80251c:	a1 50 50 80 00       	mov    0x805050,%eax
  802521:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802524:	c1 e2 04             	shl    $0x4,%edx
  802527:	01 d0                	add    %edx,%eax
  802529:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802530:	a1 54 51 80 00       	mov    0x805154,%eax
  802535:	40                   	inc    %eax
  802536:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80253b:	ff 45 f4             	incl   -0xc(%ebp)
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	3b 45 08             	cmp    0x8(%ebp),%eax
  802544:	0f 82 56 ff ff ff    	jb     8024a0 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  80254a:	90                   	nop
  80254b:	c9                   	leave  
  80254c:	c3                   	ret    

0080254d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80254d:	55                   	push   %ebp
  80254e:	89 e5                	mov    %esp,%ebp
  802550:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802553:	a1 38 51 80 00       	mov    0x805138,%eax
  802558:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80255b:	eb 18                	jmp    802575 <find_block+0x28>
	{
		if (ele->sva==va)
  80255d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802560:	8b 40 08             	mov    0x8(%eax),%eax
  802563:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802566:	75 05                	jne    80256d <find_block+0x20>
			return ele;
  802568:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80256b:	eb 7b                	jmp    8025e8 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80256d:	a1 40 51 80 00       	mov    0x805140,%eax
  802572:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802575:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802579:	74 07                	je     802582 <find_block+0x35>
  80257b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80257e:	8b 00                	mov    (%eax),%eax
  802580:	eb 05                	jmp    802587 <find_block+0x3a>
  802582:	b8 00 00 00 00       	mov    $0x0,%eax
  802587:	a3 40 51 80 00       	mov    %eax,0x805140
  80258c:	a1 40 51 80 00       	mov    0x805140,%eax
  802591:	85 c0                	test   %eax,%eax
  802593:	75 c8                	jne    80255d <find_block+0x10>
  802595:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802599:	75 c2                	jne    80255d <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80259b:	a1 40 50 80 00       	mov    0x805040,%eax
  8025a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025a3:	eb 18                	jmp    8025bd <find_block+0x70>
	{
		if (ele->sva==va)
  8025a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025a8:	8b 40 08             	mov    0x8(%eax),%eax
  8025ab:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025ae:	75 05                	jne    8025b5 <find_block+0x68>
					return ele;
  8025b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025b3:	eb 33                	jmp    8025e8 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8025b5:	a1 48 50 80 00       	mov    0x805048,%eax
  8025ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025c1:	74 07                	je     8025ca <find_block+0x7d>
  8025c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025c6:	8b 00                	mov    (%eax),%eax
  8025c8:	eb 05                	jmp    8025cf <find_block+0x82>
  8025ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cf:	a3 48 50 80 00       	mov    %eax,0x805048
  8025d4:	a1 48 50 80 00       	mov    0x805048,%eax
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	75 c8                	jne    8025a5 <find_block+0x58>
  8025dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025e1:	75 c2                	jne    8025a5 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  8025e3:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8025e8:	c9                   	leave  
  8025e9:	c3                   	ret    

008025ea <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
  8025ed:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  8025f0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025f5:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  8025f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025fc:	75 62                	jne    802660 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8025fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802602:	75 14                	jne    802618 <insert_sorted_allocList+0x2e>
  802604:	83 ec 04             	sub    $0x4,%esp
  802607:	68 10 3f 80 00       	push   $0x803f10
  80260c:	6a 69                	push   $0x69
  80260e:	68 33 3f 80 00       	push   $0x803f33
  802613:	e8 41 e1 ff ff       	call   800759 <_panic>
  802618:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80261e:	8b 45 08             	mov    0x8(%ebp),%eax
  802621:	89 10                	mov    %edx,(%eax)
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	8b 00                	mov    (%eax),%eax
  802628:	85 c0                	test   %eax,%eax
  80262a:	74 0d                	je     802639 <insert_sorted_allocList+0x4f>
  80262c:	a1 40 50 80 00       	mov    0x805040,%eax
  802631:	8b 55 08             	mov    0x8(%ebp),%edx
  802634:	89 50 04             	mov    %edx,0x4(%eax)
  802637:	eb 08                	jmp    802641 <insert_sorted_allocList+0x57>
  802639:	8b 45 08             	mov    0x8(%ebp),%eax
  80263c:	a3 44 50 80 00       	mov    %eax,0x805044
  802641:	8b 45 08             	mov    0x8(%ebp),%eax
  802644:	a3 40 50 80 00       	mov    %eax,0x805040
  802649:	8b 45 08             	mov    0x8(%ebp),%eax
  80264c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802653:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802658:	40                   	inc    %eax
  802659:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80265e:	eb 72                	jmp    8026d2 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802660:	a1 40 50 80 00       	mov    0x805040,%eax
  802665:	8b 50 08             	mov    0x8(%eax),%edx
  802668:	8b 45 08             	mov    0x8(%ebp),%eax
  80266b:	8b 40 08             	mov    0x8(%eax),%eax
  80266e:	39 c2                	cmp    %eax,%edx
  802670:	76 60                	jbe    8026d2 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802672:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802676:	75 14                	jne    80268c <insert_sorted_allocList+0xa2>
  802678:	83 ec 04             	sub    $0x4,%esp
  80267b:	68 10 3f 80 00       	push   $0x803f10
  802680:	6a 6d                	push   $0x6d
  802682:	68 33 3f 80 00       	push   $0x803f33
  802687:	e8 cd e0 ff ff       	call   800759 <_panic>
  80268c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802692:	8b 45 08             	mov    0x8(%ebp),%eax
  802695:	89 10                	mov    %edx,(%eax)
  802697:	8b 45 08             	mov    0x8(%ebp),%eax
  80269a:	8b 00                	mov    (%eax),%eax
  80269c:	85 c0                	test   %eax,%eax
  80269e:	74 0d                	je     8026ad <insert_sorted_allocList+0xc3>
  8026a0:	a1 40 50 80 00       	mov    0x805040,%eax
  8026a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a8:	89 50 04             	mov    %edx,0x4(%eax)
  8026ab:	eb 08                	jmp    8026b5 <insert_sorted_allocList+0xcb>
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	a3 44 50 80 00       	mov    %eax,0x805044
  8026b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b8:	a3 40 50 80 00       	mov    %eax,0x805040
  8026bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026cc:	40                   	inc    %eax
  8026cd:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8026d2:	a1 40 50 80 00       	mov    0x805040,%eax
  8026d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026da:	e9 b9 01 00 00       	jmp    802898 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  8026df:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e2:	8b 50 08             	mov    0x8(%eax),%edx
  8026e5:	a1 40 50 80 00       	mov    0x805040,%eax
  8026ea:	8b 40 08             	mov    0x8(%eax),%eax
  8026ed:	39 c2                	cmp    %eax,%edx
  8026ef:	76 7c                	jbe    80276d <insert_sorted_allocList+0x183>
  8026f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f4:	8b 50 08             	mov    0x8(%eax),%edx
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	8b 40 08             	mov    0x8(%eax),%eax
  8026fd:	39 c2                	cmp    %eax,%edx
  8026ff:	73 6c                	jae    80276d <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802701:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802705:	74 06                	je     80270d <insert_sorted_allocList+0x123>
  802707:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80270b:	75 14                	jne    802721 <insert_sorted_allocList+0x137>
  80270d:	83 ec 04             	sub    $0x4,%esp
  802710:	68 4c 3f 80 00       	push   $0x803f4c
  802715:	6a 75                	push   $0x75
  802717:	68 33 3f 80 00       	push   $0x803f33
  80271c:	e8 38 e0 ff ff       	call   800759 <_panic>
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 50 04             	mov    0x4(%eax),%edx
  802727:	8b 45 08             	mov    0x8(%ebp),%eax
  80272a:	89 50 04             	mov    %edx,0x4(%eax)
  80272d:	8b 45 08             	mov    0x8(%ebp),%eax
  802730:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802733:	89 10                	mov    %edx,(%eax)
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	8b 40 04             	mov    0x4(%eax),%eax
  80273b:	85 c0                	test   %eax,%eax
  80273d:	74 0d                	je     80274c <insert_sorted_allocList+0x162>
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	8b 40 04             	mov    0x4(%eax),%eax
  802745:	8b 55 08             	mov    0x8(%ebp),%edx
  802748:	89 10                	mov    %edx,(%eax)
  80274a:	eb 08                	jmp    802754 <insert_sorted_allocList+0x16a>
  80274c:	8b 45 08             	mov    0x8(%ebp),%eax
  80274f:	a3 40 50 80 00       	mov    %eax,0x805040
  802754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802757:	8b 55 08             	mov    0x8(%ebp),%edx
  80275a:	89 50 04             	mov    %edx,0x4(%eax)
  80275d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802762:	40                   	inc    %eax
  802763:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  802768:	e9 59 01 00 00       	jmp    8028c6 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  80276d:	8b 45 08             	mov    0x8(%ebp),%eax
  802770:	8b 50 08             	mov    0x8(%eax),%edx
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	8b 40 08             	mov    0x8(%eax),%eax
  802779:	39 c2                	cmp    %eax,%edx
  80277b:	0f 86 98 00 00 00    	jbe    802819 <insert_sorted_allocList+0x22f>
  802781:	8b 45 08             	mov    0x8(%ebp),%eax
  802784:	8b 50 08             	mov    0x8(%eax),%edx
  802787:	a1 44 50 80 00       	mov    0x805044,%eax
  80278c:	8b 40 08             	mov    0x8(%eax),%eax
  80278f:	39 c2                	cmp    %eax,%edx
  802791:	0f 83 82 00 00 00    	jae    802819 <insert_sorted_allocList+0x22f>
  802797:	8b 45 08             	mov    0x8(%ebp),%eax
  80279a:	8b 50 08             	mov    0x8(%eax),%edx
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	8b 40 08             	mov    0x8(%eax),%eax
  8027a5:	39 c2                	cmp    %eax,%edx
  8027a7:	73 70                	jae    802819 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8027a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ad:	74 06                	je     8027b5 <insert_sorted_allocList+0x1cb>
  8027af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027b3:	75 14                	jne    8027c9 <insert_sorted_allocList+0x1df>
  8027b5:	83 ec 04             	sub    $0x4,%esp
  8027b8:	68 84 3f 80 00       	push   $0x803f84
  8027bd:	6a 7c                	push   $0x7c
  8027bf:	68 33 3f 80 00       	push   $0x803f33
  8027c4:	e8 90 df ff ff       	call   800759 <_panic>
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	8b 10                	mov    (%eax),%edx
  8027ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d1:	89 10                	mov    %edx,(%eax)
  8027d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d6:	8b 00                	mov    (%eax),%eax
  8027d8:	85 c0                	test   %eax,%eax
  8027da:	74 0b                	je     8027e7 <insert_sorted_allocList+0x1fd>
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	8b 00                	mov    (%eax),%eax
  8027e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e4:	89 50 04             	mov    %edx,0x4(%eax)
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ed:	89 10                	mov    %edx,(%eax)
  8027ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f5:	89 50 04             	mov    %edx,0x4(%eax)
  8027f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fb:	8b 00                	mov    (%eax),%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	75 08                	jne    802809 <insert_sorted_allocList+0x21f>
  802801:	8b 45 08             	mov    0x8(%ebp),%eax
  802804:	a3 44 50 80 00       	mov    %eax,0x805044
  802809:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80280e:	40                   	inc    %eax
  80280f:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802814:	e9 ad 00 00 00       	jmp    8028c6 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802819:	8b 45 08             	mov    0x8(%ebp),%eax
  80281c:	8b 50 08             	mov    0x8(%eax),%edx
  80281f:	a1 44 50 80 00       	mov    0x805044,%eax
  802824:	8b 40 08             	mov    0x8(%eax),%eax
  802827:	39 c2                	cmp    %eax,%edx
  802829:	76 65                	jbe    802890 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  80282b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80282f:	75 17                	jne    802848 <insert_sorted_allocList+0x25e>
  802831:	83 ec 04             	sub    $0x4,%esp
  802834:	68 b8 3f 80 00       	push   $0x803fb8
  802839:	68 80 00 00 00       	push   $0x80
  80283e:	68 33 3f 80 00       	push   $0x803f33
  802843:	e8 11 df ff ff       	call   800759 <_panic>
  802848:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80284e:	8b 45 08             	mov    0x8(%ebp),%eax
  802851:	89 50 04             	mov    %edx,0x4(%eax)
  802854:	8b 45 08             	mov    0x8(%ebp),%eax
  802857:	8b 40 04             	mov    0x4(%eax),%eax
  80285a:	85 c0                	test   %eax,%eax
  80285c:	74 0c                	je     80286a <insert_sorted_allocList+0x280>
  80285e:	a1 44 50 80 00       	mov    0x805044,%eax
  802863:	8b 55 08             	mov    0x8(%ebp),%edx
  802866:	89 10                	mov    %edx,(%eax)
  802868:	eb 08                	jmp    802872 <insert_sorted_allocList+0x288>
  80286a:	8b 45 08             	mov    0x8(%ebp),%eax
  80286d:	a3 40 50 80 00       	mov    %eax,0x805040
  802872:	8b 45 08             	mov    0x8(%ebp),%eax
  802875:	a3 44 50 80 00       	mov    %eax,0x805044
  80287a:	8b 45 08             	mov    0x8(%ebp),%eax
  80287d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802883:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802888:	40                   	inc    %eax
  802889:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  80288e:	eb 36                	jmp    8028c6 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802890:	a1 48 50 80 00       	mov    0x805048,%eax
  802895:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802898:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289c:	74 07                	je     8028a5 <insert_sorted_allocList+0x2bb>
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	8b 00                	mov    (%eax),%eax
  8028a3:	eb 05                	jmp    8028aa <insert_sorted_allocList+0x2c0>
  8028a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028aa:	a3 48 50 80 00       	mov    %eax,0x805048
  8028af:	a1 48 50 80 00       	mov    0x805048,%eax
  8028b4:	85 c0                	test   %eax,%eax
  8028b6:	0f 85 23 fe ff ff    	jne    8026df <insert_sorted_allocList+0xf5>
  8028bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c0:	0f 85 19 fe ff ff    	jne    8026df <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  8028c6:	90                   	nop
  8028c7:	c9                   	leave  
  8028c8:	c3                   	ret    

008028c9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8028c9:	55                   	push   %ebp
  8028ca:	89 e5                	mov    %esp,%ebp
  8028cc:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8028cf:	a1 38 51 80 00       	mov    0x805138,%eax
  8028d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d7:	e9 7c 01 00 00       	jmp    802a58 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e5:	0f 85 90 00 00 00    	jne    80297b <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  8028f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f5:	75 17                	jne    80290e <alloc_block_FF+0x45>
  8028f7:	83 ec 04             	sub    $0x4,%esp
  8028fa:	68 db 3f 80 00       	push   $0x803fdb
  8028ff:	68 ba 00 00 00       	push   $0xba
  802904:	68 33 3f 80 00       	push   $0x803f33
  802909:	e8 4b de ff ff       	call   800759 <_panic>
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 00                	mov    (%eax),%eax
  802913:	85 c0                	test   %eax,%eax
  802915:	74 10                	je     802927 <alloc_block_FF+0x5e>
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	8b 00                	mov    (%eax),%eax
  80291c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291f:	8b 52 04             	mov    0x4(%edx),%edx
  802922:	89 50 04             	mov    %edx,0x4(%eax)
  802925:	eb 0b                	jmp    802932 <alloc_block_FF+0x69>
  802927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292a:	8b 40 04             	mov    0x4(%eax),%eax
  80292d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	8b 40 04             	mov    0x4(%eax),%eax
  802938:	85 c0                	test   %eax,%eax
  80293a:	74 0f                	je     80294b <alloc_block_FF+0x82>
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	8b 40 04             	mov    0x4(%eax),%eax
  802942:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802945:	8b 12                	mov    (%edx),%edx
  802947:	89 10                	mov    %edx,(%eax)
  802949:	eb 0a                	jmp    802955 <alloc_block_FF+0x8c>
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	8b 00                	mov    (%eax),%eax
  802950:	a3 38 51 80 00       	mov    %eax,0x805138
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802968:	a1 44 51 80 00       	mov    0x805144,%eax
  80296d:	48                   	dec    %eax
  80296e:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802976:	e9 10 01 00 00       	jmp    802a8b <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 40 0c             	mov    0xc(%eax),%eax
  802981:	3b 45 08             	cmp    0x8(%ebp),%eax
  802984:	0f 86 c6 00 00 00    	jbe    802a50 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  80298a:	a1 48 51 80 00       	mov    0x805148,%eax
  80298f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802992:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802996:	75 17                	jne    8029af <alloc_block_FF+0xe6>
  802998:	83 ec 04             	sub    $0x4,%esp
  80299b:	68 db 3f 80 00       	push   $0x803fdb
  8029a0:	68 c2 00 00 00       	push   $0xc2
  8029a5:	68 33 3f 80 00       	push   $0x803f33
  8029aa:	e8 aa dd ff ff       	call   800759 <_panic>
  8029af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b2:	8b 00                	mov    (%eax),%eax
  8029b4:	85 c0                	test   %eax,%eax
  8029b6:	74 10                	je     8029c8 <alloc_block_FF+0xff>
  8029b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bb:	8b 00                	mov    (%eax),%eax
  8029bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029c0:	8b 52 04             	mov    0x4(%edx),%edx
  8029c3:	89 50 04             	mov    %edx,0x4(%eax)
  8029c6:	eb 0b                	jmp    8029d3 <alloc_block_FF+0x10a>
  8029c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cb:	8b 40 04             	mov    0x4(%eax),%eax
  8029ce:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d6:	8b 40 04             	mov    0x4(%eax),%eax
  8029d9:	85 c0                	test   %eax,%eax
  8029db:	74 0f                	je     8029ec <alloc_block_FF+0x123>
  8029dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e0:	8b 40 04             	mov    0x4(%eax),%eax
  8029e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029e6:	8b 12                	mov    (%edx),%edx
  8029e8:	89 10                	mov    %edx,(%eax)
  8029ea:	eb 0a                	jmp    8029f6 <alloc_block_FF+0x12d>
  8029ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ef:	8b 00                	mov    (%eax),%eax
  8029f1:	a3 48 51 80 00       	mov    %eax,0x805148
  8029f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a09:	a1 54 51 80 00       	mov    0x805154,%eax
  802a0e:	48                   	dec    %eax
  802a0f:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 50 08             	mov    0x8(%eax),%edx
  802a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1d:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a23:	8b 55 08             	mov    0x8(%ebp),%edx
  802a26:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2f:	2b 45 08             	sub    0x8(%ebp),%eax
  802a32:	89 c2                	mov    %eax,%edx
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	8b 50 08             	mov    0x8(%eax),%edx
  802a40:	8b 45 08             	mov    0x8(%ebp),%eax
  802a43:	01 c2                	add    %eax,%edx
  802a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a48:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4e:	eb 3b                	jmp    802a8b <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802a50:	a1 40 51 80 00       	mov    0x805140,%eax
  802a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5c:	74 07                	je     802a65 <alloc_block_FF+0x19c>
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	8b 00                	mov    (%eax),%eax
  802a63:	eb 05                	jmp    802a6a <alloc_block_FF+0x1a1>
  802a65:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6a:	a3 40 51 80 00       	mov    %eax,0x805140
  802a6f:	a1 40 51 80 00       	mov    0x805140,%eax
  802a74:	85 c0                	test   %eax,%eax
  802a76:	0f 85 60 fe ff ff    	jne    8028dc <alloc_block_FF+0x13>
  802a7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a80:	0f 85 56 fe ff ff    	jne    8028dc <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802a86:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8b:	c9                   	leave  
  802a8c:	c3                   	ret    

00802a8d <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802a8d:	55                   	push   %ebp
  802a8e:	89 e5                	mov    %esp,%ebp
  802a90:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802a93:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802a9a:	a1 38 51 80 00       	mov    0x805138,%eax
  802a9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa2:	eb 3a                	jmp    802ade <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aaa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aad:	72 27                	jb     802ad6 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802aaf:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802ab3:	75 0b                	jne    802ac0 <alloc_block_BF+0x33>
					best_size= element->size;
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	8b 40 0c             	mov    0xc(%eax),%eax
  802abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802abe:	eb 16                	jmp    802ad6 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	8b 50 0c             	mov    0xc(%eax),%edx
  802ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac9:	39 c2                	cmp    %eax,%edx
  802acb:	77 09                	ja     802ad6 <alloc_block_BF+0x49>
					best_size=element->size;
  802acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad3:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802ad6:	a1 40 51 80 00       	mov    0x805140,%eax
  802adb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ade:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae2:	74 07                	je     802aeb <alloc_block_BF+0x5e>
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	8b 00                	mov    (%eax),%eax
  802ae9:	eb 05                	jmp    802af0 <alloc_block_BF+0x63>
  802aeb:	b8 00 00 00 00       	mov    $0x0,%eax
  802af0:	a3 40 51 80 00       	mov    %eax,0x805140
  802af5:	a1 40 51 80 00       	mov    0x805140,%eax
  802afa:	85 c0                	test   %eax,%eax
  802afc:	75 a6                	jne    802aa4 <alloc_block_BF+0x17>
  802afe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b02:	75 a0                	jne    802aa4 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802b04:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802b08:	0f 84 d3 01 00 00    	je     802ce1 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802b0e:	a1 38 51 80 00       	mov    0x805138,%eax
  802b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b16:	e9 98 01 00 00       	jmp    802cb3 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b21:	0f 86 da 00 00 00    	jbe    802c01 <alloc_block_BF+0x174>
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	8b 50 0c             	mov    0xc(%eax),%edx
  802b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b30:	39 c2                	cmp    %eax,%edx
  802b32:	0f 85 c9 00 00 00    	jne    802c01 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802b38:	a1 48 51 80 00       	mov    0x805148,%eax
  802b3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802b40:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b44:	75 17                	jne    802b5d <alloc_block_BF+0xd0>
  802b46:	83 ec 04             	sub    $0x4,%esp
  802b49:	68 db 3f 80 00       	push   $0x803fdb
  802b4e:	68 ea 00 00 00       	push   $0xea
  802b53:	68 33 3f 80 00       	push   $0x803f33
  802b58:	e8 fc db ff ff       	call   800759 <_panic>
  802b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b60:	8b 00                	mov    (%eax),%eax
  802b62:	85 c0                	test   %eax,%eax
  802b64:	74 10                	je     802b76 <alloc_block_BF+0xe9>
  802b66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b69:	8b 00                	mov    (%eax),%eax
  802b6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b6e:	8b 52 04             	mov    0x4(%edx),%edx
  802b71:	89 50 04             	mov    %edx,0x4(%eax)
  802b74:	eb 0b                	jmp    802b81 <alloc_block_BF+0xf4>
  802b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b79:	8b 40 04             	mov    0x4(%eax),%eax
  802b7c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b84:	8b 40 04             	mov    0x4(%eax),%eax
  802b87:	85 c0                	test   %eax,%eax
  802b89:	74 0f                	je     802b9a <alloc_block_BF+0x10d>
  802b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8e:	8b 40 04             	mov    0x4(%eax),%eax
  802b91:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b94:	8b 12                	mov    (%edx),%edx
  802b96:	89 10                	mov    %edx,(%eax)
  802b98:	eb 0a                	jmp    802ba4 <alloc_block_BF+0x117>
  802b9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9d:	8b 00                	mov    (%eax),%eax
  802b9f:	a3 48 51 80 00       	mov    %eax,0x805148
  802ba4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb7:	a1 54 51 80 00       	mov    0x805154,%eax
  802bbc:	48                   	dec    %eax
  802bbd:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 50 08             	mov    0x8(%eax),%edx
  802bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcb:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802bce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd4:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 40 0c             	mov    0xc(%eax),%eax
  802bdd:	2b 45 08             	sub    0x8(%ebp),%eax
  802be0:	89 c2                	mov    %eax,%edx
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 50 08             	mov    0x8(%eax),%edx
  802bee:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf1:	01 c2                	add    %eax,%edx
  802bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf6:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802bf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfc:	e9 e5 00 00 00       	jmp    802ce6 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c04:	8b 50 0c             	mov    0xc(%eax),%edx
  802c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0a:	39 c2                	cmp    %eax,%edx
  802c0c:	0f 85 99 00 00 00    	jne    802cab <alloc_block_BF+0x21e>
  802c12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c15:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c18:	0f 85 8d 00 00 00    	jne    802cab <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802c24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c28:	75 17                	jne    802c41 <alloc_block_BF+0x1b4>
  802c2a:	83 ec 04             	sub    $0x4,%esp
  802c2d:	68 db 3f 80 00       	push   $0x803fdb
  802c32:	68 f7 00 00 00       	push   $0xf7
  802c37:	68 33 3f 80 00       	push   $0x803f33
  802c3c:	e8 18 db ff ff       	call   800759 <_panic>
  802c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c44:	8b 00                	mov    (%eax),%eax
  802c46:	85 c0                	test   %eax,%eax
  802c48:	74 10                	je     802c5a <alloc_block_BF+0x1cd>
  802c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4d:	8b 00                	mov    (%eax),%eax
  802c4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c52:	8b 52 04             	mov    0x4(%edx),%edx
  802c55:	89 50 04             	mov    %edx,0x4(%eax)
  802c58:	eb 0b                	jmp    802c65 <alloc_block_BF+0x1d8>
  802c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5d:	8b 40 04             	mov    0x4(%eax),%eax
  802c60:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 40 04             	mov    0x4(%eax),%eax
  802c6b:	85 c0                	test   %eax,%eax
  802c6d:	74 0f                	je     802c7e <alloc_block_BF+0x1f1>
  802c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c72:	8b 40 04             	mov    0x4(%eax),%eax
  802c75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c78:	8b 12                	mov    (%edx),%edx
  802c7a:	89 10                	mov    %edx,(%eax)
  802c7c:	eb 0a                	jmp    802c88 <alloc_block_BF+0x1fb>
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	8b 00                	mov    (%eax),%eax
  802c83:	a3 38 51 80 00       	mov    %eax,0x805138
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9b:	a1 44 51 80 00       	mov    0x805144,%eax
  802ca0:	48                   	dec    %eax
  802ca1:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  802ca6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca9:	eb 3b                	jmp    802ce6 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802cab:	a1 40 51 80 00       	mov    0x805140,%eax
  802cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb7:	74 07                	je     802cc0 <alloc_block_BF+0x233>
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	8b 00                	mov    (%eax),%eax
  802cbe:	eb 05                	jmp    802cc5 <alloc_block_BF+0x238>
  802cc0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc5:	a3 40 51 80 00       	mov    %eax,0x805140
  802cca:	a1 40 51 80 00       	mov    0x805140,%eax
  802ccf:	85 c0                	test   %eax,%eax
  802cd1:	0f 85 44 fe ff ff    	jne    802b1b <alloc_block_BF+0x8e>
  802cd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cdb:	0f 85 3a fe ff ff    	jne    802b1b <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce6:	c9                   	leave  
  802ce7:	c3                   	ret    

00802ce8 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ce8:	55                   	push   %ebp
  802ce9:	89 e5                	mov    %esp,%ebp
  802ceb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802cee:	83 ec 04             	sub    $0x4,%esp
  802cf1:	68 fc 3f 80 00       	push   $0x803ffc
  802cf6:	68 04 01 00 00       	push   $0x104
  802cfb:	68 33 3f 80 00       	push   $0x803f33
  802d00:	e8 54 da ff ff       	call   800759 <_panic>

00802d05 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802d05:	55                   	push   %ebp
  802d06:	89 e5                	mov    %esp,%ebp
  802d08:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802d0b:	a1 38 51 80 00       	mov    0x805138,%eax
  802d10:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802d13:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d18:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802d1b:	a1 38 51 80 00       	mov    0x805138,%eax
  802d20:	85 c0                	test   %eax,%eax
  802d22:	75 68                	jne    802d8c <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802d24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d28:	75 17                	jne    802d41 <insert_sorted_with_merge_freeList+0x3c>
  802d2a:	83 ec 04             	sub    $0x4,%esp
  802d2d:	68 10 3f 80 00       	push   $0x803f10
  802d32:	68 14 01 00 00       	push   $0x114
  802d37:	68 33 3f 80 00       	push   $0x803f33
  802d3c:	e8 18 da ff ff       	call   800759 <_panic>
  802d41:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	89 10                	mov    %edx,(%eax)
  802d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4f:	8b 00                	mov    (%eax),%eax
  802d51:	85 c0                	test   %eax,%eax
  802d53:	74 0d                	je     802d62 <insert_sorted_with_merge_freeList+0x5d>
  802d55:	a1 38 51 80 00       	mov    0x805138,%eax
  802d5a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5d:	89 50 04             	mov    %edx,0x4(%eax)
  802d60:	eb 08                	jmp    802d6a <insert_sorted_with_merge_freeList+0x65>
  802d62:	8b 45 08             	mov    0x8(%ebp),%eax
  802d65:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6d:	a3 38 51 80 00       	mov    %eax,0x805138
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7c:	a1 44 51 80 00       	mov    0x805144,%eax
  802d81:	40                   	inc    %eax
  802d82:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802d87:	e9 d2 06 00 00       	jmp    80345e <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	8b 50 08             	mov    0x8(%eax),%edx
  802d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d95:	8b 40 08             	mov    0x8(%eax),%eax
  802d98:	39 c2                	cmp    %eax,%edx
  802d9a:	0f 83 22 01 00 00    	jae    802ec2 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802da0:	8b 45 08             	mov    0x8(%ebp),%eax
  802da3:	8b 50 08             	mov    0x8(%eax),%edx
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dac:	01 c2                	add    %eax,%edx
  802dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db1:	8b 40 08             	mov    0x8(%eax),%eax
  802db4:	39 c2                	cmp    %eax,%edx
  802db6:	0f 85 9e 00 00 00    	jne    802e5a <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	8b 50 08             	mov    0x8(%eax),%edx
  802dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc5:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcb:	8b 50 0c             	mov    0xc(%eax),%edx
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd4:	01 c2                	add    %eax,%edx
  802dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd9:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802de6:	8b 45 08             	mov    0x8(%ebp),%eax
  802de9:	8b 50 08             	mov    0x8(%eax),%edx
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802df2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df6:	75 17                	jne    802e0f <insert_sorted_with_merge_freeList+0x10a>
  802df8:	83 ec 04             	sub    $0x4,%esp
  802dfb:	68 10 3f 80 00       	push   $0x803f10
  802e00:	68 21 01 00 00       	push   $0x121
  802e05:	68 33 3f 80 00       	push   $0x803f33
  802e0a:	e8 4a d9 ff ff       	call   800759 <_panic>
  802e0f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e15:	8b 45 08             	mov    0x8(%ebp),%eax
  802e18:	89 10                	mov    %edx,(%eax)
  802e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1d:	8b 00                	mov    (%eax),%eax
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	74 0d                	je     802e30 <insert_sorted_with_merge_freeList+0x12b>
  802e23:	a1 48 51 80 00       	mov    0x805148,%eax
  802e28:	8b 55 08             	mov    0x8(%ebp),%edx
  802e2b:	89 50 04             	mov    %edx,0x4(%eax)
  802e2e:	eb 08                	jmp    802e38 <insert_sorted_with_merge_freeList+0x133>
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	a3 48 51 80 00       	mov    %eax,0x805148
  802e40:	8b 45 08             	mov    0x8(%ebp),%eax
  802e43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4a:	a1 54 51 80 00       	mov    0x805154,%eax
  802e4f:	40                   	inc    %eax
  802e50:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802e55:	e9 04 06 00 00       	jmp    80345e <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802e5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e5e:	75 17                	jne    802e77 <insert_sorted_with_merge_freeList+0x172>
  802e60:	83 ec 04             	sub    $0x4,%esp
  802e63:	68 10 3f 80 00       	push   $0x803f10
  802e68:	68 26 01 00 00       	push   $0x126
  802e6d:	68 33 3f 80 00       	push   $0x803f33
  802e72:	e8 e2 d8 ff ff       	call   800759 <_panic>
  802e77:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e80:	89 10                	mov    %edx,(%eax)
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	8b 00                	mov    (%eax),%eax
  802e87:	85 c0                	test   %eax,%eax
  802e89:	74 0d                	je     802e98 <insert_sorted_with_merge_freeList+0x193>
  802e8b:	a1 38 51 80 00       	mov    0x805138,%eax
  802e90:	8b 55 08             	mov    0x8(%ebp),%edx
  802e93:	89 50 04             	mov    %edx,0x4(%eax)
  802e96:	eb 08                	jmp    802ea0 <insert_sorted_with_merge_freeList+0x19b>
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea3:	a3 38 51 80 00       	mov    %eax,0x805138
  802ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb2:	a1 44 51 80 00       	mov    0x805144,%eax
  802eb7:	40                   	inc    %eax
  802eb8:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802ebd:	e9 9c 05 00 00       	jmp    80345e <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	8b 50 08             	mov    0x8(%eax),%edx
  802ec8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ecb:	8b 40 08             	mov    0x8(%eax),%eax
  802ece:	39 c2                	cmp    %eax,%edx
  802ed0:	0f 86 16 01 00 00    	jbe    802fec <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed9:	8b 50 08             	mov    0x8(%eax),%edx
  802edc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802edf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee2:	01 c2                	add    %eax,%edx
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	8b 40 08             	mov    0x8(%eax),%eax
  802eea:	39 c2                	cmp    %eax,%edx
  802eec:	0f 85 92 00 00 00    	jne    802f84 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802ef2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef5:	8b 50 0c             	mov    0xc(%eax),%edx
  802ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  802efb:	8b 40 0c             	mov    0xc(%eax),%eax
  802efe:	01 c2                	add    %eax,%edx
  802f00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f03:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f10:	8b 45 08             	mov    0x8(%ebp),%eax
  802f13:	8b 50 08             	mov    0x8(%eax),%edx
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f20:	75 17                	jne    802f39 <insert_sorted_with_merge_freeList+0x234>
  802f22:	83 ec 04             	sub    $0x4,%esp
  802f25:	68 10 3f 80 00       	push   $0x803f10
  802f2a:	68 31 01 00 00       	push   $0x131
  802f2f:	68 33 3f 80 00       	push   $0x803f33
  802f34:	e8 20 d8 ff ff       	call   800759 <_panic>
  802f39:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f42:	89 10                	mov    %edx,(%eax)
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	8b 00                	mov    (%eax),%eax
  802f49:	85 c0                	test   %eax,%eax
  802f4b:	74 0d                	je     802f5a <insert_sorted_with_merge_freeList+0x255>
  802f4d:	a1 48 51 80 00       	mov    0x805148,%eax
  802f52:	8b 55 08             	mov    0x8(%ebp),%edx
  802f55:	89 50 04             	mov    %edx,0x4(%eax)
  802f58:	eb 08                	jmp    802f62 <insert_sorted_with_merge_freeList+0x25d>
  802f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f62:	8b 45 08             	mov    0x8(%ebp),%eax
  802f65:	a3 48 51 80 00       	mov    %eax,0x805148
  802f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f74:	a1 54 51 80 00       	mov    0x805154,%eax
  802f79:	40                   	inc    %eax
  802f7a:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802f7f:	e9 da 04 00 00       	jmp    80345e <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802f84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f88:	75 17                	jne    802fa1 <insert_sorted_with_merge_freeList+0x29c>
  802f8a:	83 ec 04             	sub    $0x4,%esp
  802f8d:	68 b8 3f 80 00       	push   $0x803fb8
  802f92:	68 37 01 00 00       	push   $0x137
  802f97:	68 33 3f 80 00       	push   $0x803f33
  802f9c:	e8 b8 d7 ff ff       	call   800759 <_panic>
  802fa1:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	89 50 04             	mov    %edx,0x4(%eax)
  802fad:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb0:	8b 40 04             	mov    0x4(%eax),%eax
  802fb3:	85 c0                	test   %eax,%eax
  802fb5:	74 0c                	je     802fc3 <insert_sorted_with_merge_freeList+0x2be>
  802fb7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fbc:	8b 55 08             	mov    0x8(%ebp),%edx
  802fbf:	89 10                	mov    %edx,(%eax)
  802fc1:	eb 08                	jmp    802fcb <insert_sorted_with_merge_freeList+0x2c6>
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	a3 38 51 80 00       	mov    %eax,0x805138
  802fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fce:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fdc:	a1 44 51 80 00       	mov    0x805144,%eax
  802fe1:	40                   	inc    %eax
  802fe2:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802fe7:	e9 72 04 00 00       	jmp    80345e <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802fec:	a1 38 51 80 00       	mov    0x805138,%eax
  802ff1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ff4:	e9 35 04 00 00       	jmp    80342e <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffc:	8b 00                	mov    (%eax),%eax
  802ffe:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  803001:	8b 45 08             	mov    0x8(%ebp),%eax
  803004:	8b 50 08             	mov    0x8(%eax),%edx
  803007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300a:	8b 40 08             	mov    0x8(%eax),%eax
  80300d:	39 c2                	cmp    %eax,%edx
  80300f:	0f 86 11 04 00 00    	jbe    803426 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	8b 50 08             	mov    0x8(%eax),%edx
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	8b 40 0c             	mov    0xc(%eax),%eax
  803021:	01 c2                	add    %eax,%edx
  803023:	8b 45 08             	mov    0x8(%ebp),%eax
  803026:	8b 40 08             	mov    0x8(%eax),%eax
  803029:	39 c2                	cmp    %eax,%edx
  80302b:	0f 83 8b 00 00 00    	jae    8030bc <insert_sorted_with_merge_freeList+0x3b7>
  803031:	8b 45 08             	mov    0x8(%ebp),%eax
  803034:	8b 50 08             	mov    0x8(%eax),%edx
  803037:	8b 45 08             	mov    0x8(%ebp),%eax
  80303a:	8b 40 0c             	mov    0xc(%eax),%eax
  80303d:	01 c2                	add    %eax,%edx
  80303f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803042:	8b 40 08             	mov    0x8(%eax),%eax
  803045:	39 c2                	cmp    %eax,%edx
  803047:	73 73                	jae    8030bc <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  803049:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80304d:	74 06                	je     803055 <insert_sorted_with_merge_freeList+0x350>
  80304f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803053:	75 17                	jne    80306c <insert_sorted_with_merge_freeList+0x367>
  803055:	83 ec 04             	sub    $0x4,%esp
  803058:	68 84 3f 80 00       	push   $0x803f84
  80305d:	68 48 01 00 00       	push   $0x148
  803062:	68 33 3f 80 00       	push   $0x803f33
  803067:	e8 ed d6 ff ff       	call   800759 <_panic>
  80306c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306f:	8b 10                	mov    (%eax),%edx
  803071:	8b 45 08             	mov    0x8(%ebp),%eax
  803074:	89 10                	mov    %edx,(%eax)
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	8b 00                	mov    (%eax),%eax
  80307b:	85 c0                	test   %eax,%eax
  80307d:	74 0b                	je     80308a <insert_sorted_with_merge_freeList+0x385>
  80307f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803082:	8b 00                	mov    (%eax),%eax
  803084:	8b 55 08             	mov    0x8(%ebp),%edx
  803087:	89 50 04             	mov    %edx,0x4(%eax)
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	8b 55 08             	mov    0x8(%ebp),%edx
  803090:	89 10                	mov    %edx,(%eax)
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803098:	89 50 04             	mov    %edx,0x4(%eax)
  80309b:	8b 45 08             	mov    0x8(%ebp),%eax
  80309e:	8b 00                	mov    (%eax),%eax
  8030a0:	85 c0                	test   %eax,%eax
  8030a2:	75 08                	jne    8030ac <insert_sorted_with_merge_freeList+0x3a7>
  8030a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ac:	a1 44 51 80 00       	mov    0x805144,%eax
  8030b1:	40                   	inc    %eax
  8030b2:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  8030b7:	e9 a2 03 00 00       	jmp    80345e <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8030bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bf:	8b 50 08             	mov    0x8(%eax),%edx
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c8:	01 c2                	add    %eax,%edx
  8030ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cd:	8b 40 08             	mov    0x8(%eax),%eax
  8030d0:	39 c2                	cmp    %eax,%edx
  8030d2:	0f 83 ae 00 00 00    	jae    803186 <insert_sorted_with_merge_freeList+0x481>
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	8b 50 08             	mov    0x8(%eax),%edx
  8030de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e1:	8b 48 08             	mov    0x8(%eax),%ecx
  8030e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ea:	01 c8                	add    %ecx,%eax
  8030ec:	39 c2                	cmp    %eax,%edx
  8030ee:	0f 85 92 00 00 00    	jne    803186 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  8030f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f7:	8b 50 0c             	mov    0xc(%eax),%edx
  8030fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803100:	01 c2                	add    %eax,%edx
  803102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803105:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  803108:	8b 45 08             	mov    0x8(%ebp),%eax
  80310b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	8b 50 08             	mov    0x8(%eax),%edx
  803118:	8b 45 08             	mov    0x8(%ebp),%eax
  80311b:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80311e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803122:	75 17                	jne    80313b <insert_sorted_with_merge_freeList+0x436>
  803124:	83 ec 04             	sub    $0x4,%esp
  803127:	68 10 3f 80 00       	push   $0x803f10
  80312c:	68 51 01 00 00       	push   $0x151
  803131:	68 33 3f 80 00       	push   $0x803f33
  803136:	e8 1e d6 ff ff       	call   800759 <_panic>
  80313b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	89 10                	mov    %edx,(%eax)
  803146:	8b 45 08             	mov    0x8(%ebp),%eax
  803149:	8b 00                	mov    (%eax),%eax
  80314b:	85 c0                	test   %eax,%eax
  80314d:	74 0d                	je     80315c <insert_sorted_with_merge_freeList+0x457>
  80314f:	a1 48 51 80 00       	mov    0x805148,%eax
  803154:	8b 55 08             	mov    0x8(%ebp),%edx
  803157:	89 50 04             	mov    %edx,0x4(%eax)
  80315a:	eb 08                	jmp    803164 <insert_sorted_with_merge_freeList+0x45f>
  80315c:	8b 45 08             	mov    0x8(%ebp),%eax
  80315f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	a3 48 51 80 00       	mov    %eax,0x805148
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803176:	a1 54 51 80 00       	mov    0x805154,%eax
  80317b:	40                   	inc    %eax
  80317c:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  803181:	e9 d8 02 00 00       	jmp    80345e <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	8b 50 08             	mov    0x8(%eax),%edx
  80318c:	8b 45 08             	mov    0x8(%ebp),%eax
  80318f:	8b 40 0c             	mov    0xc(%eax),%eax
  803192:	01 c2                	add    %eax,%edx
  803194:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803197:	8b 40 08             	mov    0x8(%eax),%eax
  80319a:	39 c2                	cmp    %eax,%edx
  80319c:	0f 85 ba 00 00 00    	jne    80325c <insert_sorted_with_merge_freeList+0x557>
  8031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a5:	8b 50 08             	mov    0x8(%eax),%edx
  8031a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ab:	8b 48 08             	mov    0x8(%eax),%ecx
  8031ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b4:	01 c8                	add    %ecx,%eax
  8031b6:	39 c2                	cmp    %eax,%edx
  8031b8:	0f 86 9e 00 00 00    	jbe    80325c <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  8031be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c1:	8b 50 0c             	mov    0xc(%eax),%edx
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ca:	01 c2                	add    %eax,%edx
  8031cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cf:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	8b 50 08             	mov    0x8(%eax),%edx
  8031d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031db:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8031e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031eb:	8b 50 08             	mov    0x8(%eax),%edx
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8031f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f8:	75 17                	jne    803211 <insert_sorted_with_merge_freeList+0x50c>
  8031fa:	83 ec 04             	sub    $0x4,%esp
  8031fd:	68 10 3f 80 00       	push   $0x803f10
  803202:	68 5b 01 00 00       	push   $0x15b
  803207:	68 33 3f 80 00       	push   $0x803f33
  80320c:	e8 48 d5 ff ff       	call   800759 <_panic>
  803211:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803217:	8b 45 08             	mov    0x8(%ebp),%eax
  80321a:	89 10                	mov    %edx,(%eax)
  80321c:	8b 45 08             	mov    0x8(%ebp),%eax
  80321f:	8b 00                	mov    (%eax),%eax
  803221:	85 c0                	test   %eax,%eax
  803223:	74 0d                	je     803232 <insert_sorted_with_merge_freeList+0x52d>
  803225:	a1 48 51 80 00       	mov    0x805148,%eax
  80322a:	8b 55 08             	mov    0x8(%ebp),%edx
  80322d:	89 50 04             	mov    %edx,0x4(%eax)
  803230:	eb 08                	jmp    80323a <insert_sorted_with_merge_freeList+0x535>
  803232:	8b 45 08             	mov    0x8(%ebp),%eax
  803235:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80323a:	8b 45 08             	mov    0x8(%ebp),%eax
  80323d:	a3 48 51 80 00       	mov    %eax,0x805148
  803242:	8b 45 08             	mov    0x8(%ebp),%eax
  803245:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324c:	a1 54 51 80 00       	mov    0x805154,%eax
  803251:	40                   	inc    %eax
  803252:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803257:	e9 02 02 00 00       	jmp    80345e <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	8b 50 08             	mov    0x8(%eax),%edx
  803262:	8b 45 08             	mov    0x8(%ebp),%eax
  803265:	8b 40 0c             	mov    0xc(%eax),%eax
  803268:	01 c2                	add    %eax,%edx
  80326a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326d:	8b 40 08             	mov    0x8(%eax),%eax
  803270:	39 c2                	cmp    %eax,%edx
  803272:	0f 85 ae 01 00 00    	jne    803426 <insert_sorted_with_merge_freeList+0x721>
  803278:	8b 45 08             	mov    0x8(%ebp),%eax
  80327b:	8b 50 08             	mov    0x8(%eax),%edx
  80327e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803281:	8b 48 08             	mov    0x8(%eax),%ecx
  803284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803287:	8b 40 0c             	mov    0xc(%eax),%eax
  80328a:	01 c8                	add    %ecx,%eax
  80328c:	39 c2                	cmp    %eax,%edx
  80328e:	0f 85 92 01 00 00    	jne    803426 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  803294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803297:	8b 50 0c             	mov    0xc(%eax),%edx
  80329a:	8b 45 08             	mov    0x8(%ebp),%eax
  80329d:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a0:	01 c2                	add    %eax,%edx
  8032a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a8:	01 c2                	add    %eax,%edx
  8032aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ad:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  8032b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bd:	8b 50 08             	mov    0x8(%eax),%edx
  8032c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c3:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  8032c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8032d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d3:	8b 50 08             	mov    0x8(%eax),%edx
  8032d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d9:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  8032dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032e0:	75 17                	jne    8032f9 <insert_sorted_with_merge_freeList+0x5f4>
  8032e2:	83 ec 04             	sub    $0x4,%esp
  8032e5:	68 db 3f 80 00       	push   $0x803fdb
  8032ea:	68 63 01 00 00       	push   $0x163
  8032ef:	68 33 3f 80 00       	push   $0x803f33
  8032f4:	e8 60 d4 ff ff       	call   800759 <_panic>
  8032f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fc:	8b 00                	mov    (%eax),%eax
  8032fe:	85 c0                	test   %eax,%eax
  803300:	74 10                	je     803312 <insert_sorted_with_merge_freeList+0x60d>
  803302:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803305:	8b 00                	mov    (%eax),%eax
  803307:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80330a:	8b 52 04             	mov    0x4(%edx),%edx
  80330d:	89 50 04             	mov    %edx,0x4(%eax)
  803310:	eb 0b                	jmp    80331d <insert_sorted_with_merge_freeList+0x618>
  803312:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803315:	8b 40 04             	mov    0x4(%eax),%eax
  803318:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80331d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803320:	8b 40 04             	mov    0x4(%eax),%eax
  803323:	85 c0                	test   %eax,%eax
  803325:	74 0f                	je     803336 <insert_sorted_with_merge_freeList+0x631>
  803327:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332a:	8b 40 04             	mov    0x4(%eax),%eax
  80332d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803330:	8b 12                	mov    (%edx),%edx
  803332:	89 10                	mov    %edx,(%eax)
  803334:	eb 0a                	jmp    803340 <insert_sorted_with_merge_freeList+0x63b>
  803336:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803339:	8b 00                	mov    (%eax),%eax
  80333b:	a3 38 51 80 00       	mov    %eax,0x805138
  803340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803343:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803349:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803353:	a1 44 51 80 00       	mov    0x805144,%eax
  803358:	48                   	dec    %eax
  803359:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  80335e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803362:	75 17                	jne    80337b <insert_sorted_with_merge_freeList+0x676>
  803364:	83 ec 04             	sub    $0x4,%esp
  803367:	68 10 3f 80 00       	push   $0x803f10
  80336c:	68 64 01 00 00       	push   $0x164
  803371:	68 33 3f 80 00       	push   $0x803f33
  803376:	e8 de d3 ff ff       	call   800759 <_panic>
  80337b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803381:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803384:	89 10                	mov    %edx,(%eax)
  803386:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803389:	8b 00                	mov    (%eax),%eax
  80338b:	85 c0                	test   %eax,%eax
  80338d:	74 0d                	je     80339c <insert_sorted_with_merge_freeList+0x697>
  80338f:	a1 48 51 80 00       	mov    0x805148,%eax
  803394:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803397:	89 50 04             	mov    %edx,0x4(%eax)
  80339a:	eb 08                	jmp    8033a4 <insert_sorted_with_merge_freeList+0x69f>
  80339c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a7:	a3 48 51 80 00       	mov    %eax,0x805148
  8033ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b6:	a1 54 51 80 00       	mov    0x805154,%eax
  8033bb:	40                   	inc    %eax
  8033bc:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8033c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033c5:	75 17                	jne    8033de <insert_sorted_with_merge_freeList+0x6d9>
  8033c7:	83 ec 04             	sub    $0x4,%esp
  8033ca:	68 10 3f 80 00       	push   $0x803f10
  8033cf:	68 65 01 00 00       	push   $0x165
  8033d4:	68 33 3f 80 00       	push   $0x803f33
  8033d9:	e8 7b d3 ff ff       	call   800759 <_panic>
  8033de:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e7:	89 10                	mov    %edx,(%eax)
  8033e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ec:	8b 00                	mov    (%eax),%eax
  8033ee:	85 c0                	test   %eax,%eax
  8033f0:	74 0d                	je     8033ff <insert_sorted_with_merge_freeList+0x6fa>
  8033f2:	a1 48 51 80 00       	mov    0x805148,%eax
  8033f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8033fa:	89 50 04             	mov    %edx,0x4(%eax)
  8033fd:	eb 08                	jmp    803407 <insert_sorted_with_merge_freeList+0x702>
  8033ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803402:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803407:	8b 45 08             	mov    0x8(%ebp),%eax
  80340a:	a3 48 51 80 00       	mov    %eax,0x805148
  80340f:	8b 45 08             	mov    0x8(%ebp),%eax
  803412:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803419:	a1 54 51 80 00       	mov    0x805154,%eax
  80341e:	40                   	inc    %eax
  80341f:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803424:	eb 38                	jmp    80345e <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803426:	a1 40 51 80 00       	mov    0x805140,%eax
  80342b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80342e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803432:	74 07                	je     80343b <insert_sorted_with_merge_freeList+0x736>
  803434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803437:	8b 00                	mov    (%eax),%eax
  803439:	eb 05                	jmp    803440 <insert_sorted_with_merge_freeList+0x73b>
  80343b:	b8 00 00 00 00       	mov    $0x0,%eax
  803440:	a3 40 51 80 00       	mov    %eax,0x805140
  803445:	a1 40 51 80 00       	mov    0x805140,%eax
  80344a:	85 c0                	test   %eax,%eax
  80344c:	0f 85 a7 fb ff ff    	jne    802ff9 <insert_sorted_with_merge_freeList+0x2f4>
  803452:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803456:	0f 85 9d fb ff ff    	jne    802ff9 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  80345c:	eb 00                	jmp    80345e <insert_sorted_with_merge_freeList+0x759>
  80345e:	90                   	nop
  80345f:	c9                   	leave  
  803460:	c3                   	ret    
  803461:	66 90                	xchg   %ax,%ax
  803463:	90                   	nop

00803464 <__udivdi3>:
  803464:	55                   	push   %ebp
  803465:	57                   	push   %edi
  803466:	56                   	push   %esi
  803467:	53                   	push   %ebx
  803468:	83 ec 1c             	sub    $0x1c,%esp
  80346b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80346f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803473:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803477:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80347b:	89 ca                	mov    %ecx,%edx
  80347d:	89 f8                	mov    %edi,%eax
  80347f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803483:	85 f6                	test   %esi,%esi
  803485:	75 2d                	jne    8034b4 <__udivdi3+0x50>
  803487:	39 cf                	cmp    %ecx,%edi
  803489:	77 65                	ja     8034f0 <__udivdi3+0x8c>
  80348b:	89 fd                	mov    %edi,%ebp
  80348d:	85 ff                	test   %edi,%edi
  80348f:	75 0b                	jne    80349c <__udivdi3+0x38>
  803491:	b8 01 00 00 00       	mov    $0x1,%eax
  803496:	31 d2                	xor    %edx,%edx
  803498:	f7 f7                	div    %edi
  80349a:	89 c5                	mov    %eax,%ebp
  80349c:	31 d2                	xor    %edx,%edx
  80349e:	89 c8                	mov    %ecx,%eax
  8034a0:	f7 f5                	div    %ebp
  8034a2:	89 c1                	mov    %eax,%ecx
  8034a4:	89 d8                	mov    %ebx,%eax
  8034a6:	f7 f5                	div    %ebp
  8034a8:	89 cf                	mov    %ecx,%edi
  8034aa:	89 fa                	mov    %edi,%edx
  8034ac:	83 c4 1c             	add    $0x1c,%esp
  8034af:	5b                   	pop    %ebx
  8034b0:	5e                   	pop    %esi
  8034b1:	5f                   	pop    %edi
  8034b2:	5d                   	pop    %ebp
  8034b3:	c3                   	ret    
  8034b4:	39 ce                	cmp    %ecx,%esi
  8034b6:	77 28                	ja     8034e0 <__udivdi3+0x7c>
  8034b8:	0f bd fe             	bsr    %esi,%edi
  8034bb:	83 f7 1f             	xor    $0x1f,%edi
  8034be:	75 40                	jne    803500 <__udivdi3+0x9c>
  8034c0:	39 ce                	cmp    %ecx,%esi
  8034c2:	72 0a                	jb     8034ce <__udivdi3+0x6a>
  8034c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034c8:	0f 87 9e 00 00 00    	ja     80356c <__udivdi3+0x108>
  8034ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8034d3:	89 fa                	mov    %edi,%edx
  8034d5:	83 c4 1c             	add    $0x1c,%esp
  8034d8:	5b                   	pop    %ebx
  8034d9:	5e                   	pop    %esi
  8034da:	5f                   	pop    %edi
  8034db:	5d                   	pop    %ebp
  8034dc:	c3                   	ret    
  8034dd:	8d 76 00             	lea    0x0(%esi),%esi
  8034e0:	31 ff                	xor    %edi,%edi
  8034e2:	31 c0                	xor    %eax,%eax
  8034e4:	89 fa                	mov    %edi,%edx
  8034e6:	83 c4 1c             	add    $0x1c,%esp
  8034e9:	5b                   	pop    %ebx
  8034ea:	5e                   	pop    %esi
  8034eb:	5f                   	pop    %edi
  8034ec:	5d                   	pop    %ebp
  8034ed:	c3                   	ret    
  8034ee:	66 90                	xchg   %ax,%ax
  8034f0:	89 d8                	mov    %ebx,%eax
  8034f2:	f7 f7                	div    %edi
  8034f4:	31 ff                	xor    %edi,%edi
  8034f6:	89 fa                	mov    %edi,%edx
  8034f8:	83 c4 1c             	add    $0x1c,%esp
  8034fb:	5b                   	pop    %ebx
  8034fc:	5e                   	pop    %esi
  8034fd:	5f                   	pop    %edi
  8034fe:	5d                   	pop    %ebp
  8034ff:	c3                   	ret    
  803500:	bd 20 00 00 00       	mov    $0x20,%ebp
  803505:	89 eb                	mov    %ebp,%ebx
  803507:	29 fb                	sub    %edi,%ebx
  803509:	89 f9                	mov    %edi,%ecx
  80350b:	d3 e6                	shl    %cl,%esi
  80350d:	89 c5                	mov    %eax,%ebp
  80350f:	88 d9                	mov    %bl,%cl
  803511:	d3 ed                	shr    %cl,%ebp
  803513:	89 e9                	mov    %ebp,%ecx
  803515:	09 f1                	or     %esi,%ecx
  803517:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80351b:	89 f9                	mov    %edi,%ecx
  80351d:	d3 e0                	shl    %cl,%eax
  80351f:	89 c5                	mov    %eax,%ebp
  803521:	89 d6                	mov    %edx,%esi
  803523:	88 d9                	mov    %bl,%cl
  803525:	d3 ee                	shr    %cl,%esi
  803527:	89 f9                	mov    %edi,%ecx
  803529:	d3 e2                	shl    %cl,%edx
  80352b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80352f:	88 d9                	mov    %bl,%cl
  803531:	d3 e8                	shr    %cl,%eax
  803533:	09 c2                	or     %eax,%edx
  803535:	89 d0                	mov    %edx,%eax
  803537:	89 f2                	mov    %esi,%edx
  803539:	f7 74 24 0c          	divl   0xc(%esp)
  80353d:	89 d6                	mov    %edx,%esi
  80353f:	89 c3                	mov    %eax,%ebx
  803541:	f7 e5                	mul    %ebp
  803543:	39 d6                	cmp    %edx,%esi
  803545:	72 19                	jb     803560 <__udivdi3+0xfc>
  803547:	74 0b                	je     803554 <__udivdi3+0xf0>
  803549:	89 d8                	mov    %ebx,%eax
  80354b:	31 ff                	xor    %edi,%edi
  80354d:	e9 58 ff ff ff       	jmp    8034aa <__udivdi3+0x46>
  803552:	66 90                	xchg   %ax,%ax
  803554:	8b 54 24 08          	mov    0x8(%esp),%edx
  803558:	89 f9                	mov    %edi,%ecx
  80355a:	d3 e2                	shl    %cl,%edx
  80355c:	39 c2                	cmp    %eax,%edx
  80355e:	73 e9                	jae    803549 <__udivdi3+0xe5>
  803560:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803563:	31 ff                	xor    %edi,%edi
  803565:	e9 40 ff ff ff       	jmp    8034aa <__udivdi3+0x46>
  80356a:	66 90                	xchg   %ax,%ax
  80356c:	31 c0                	xor    %eax,%eax
  80356e:	e9 37 ff ff ff       	jmp    8034aa <__udivdi3+0x46>
  803573:	90                   	nop

00803574 <__umoddi3>:
  803574:	55                   	push   %ebp
  803575:	57                   	push   %edi
  803576:	56                   	push   %esi
  803577:	53                   	push   %ebx
  803578:	83 ec 1c             	sub    $0x1c,%esp
  80357b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80357f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803583:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803587:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80358b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80358f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803593:	89 f3                	mov    %esi,%ebx
  803595:	89 fa                	mov    %edi,%edx
  803597:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80359b:	89 34 24             	mov    %esi,(%esp)
  80359e:	85 c0                	test   %eax,%eax
  8035a0:	75 1a                	jne    8035bc <__umoddi3+0x48>
  8035a2:	39 f7                	cmp    %esi,%edi
  8035a4:	0f 86 a2 00 00 00    	jbe    80364c <__umoddi3+0xd8>
  8035aa:	89 c8                	mov    %ecx,%eax
  8035ac:	89 f2                	mov    %esi,%edx
  8035ae:	f7 f7                	div    %edi
  8035b0:	89 d0                	mov    %edx,%eax
  8035b2:	31 d2                	xor    %edx,%edx
  8035b4:	83 c4 1c             	add    $0x1c,%esp
  8035b7:	5b                   	pop    %ebx
  8035b8:	5e                   	pop    %esi
  8035b9:	5f                   	pop    %edi
  8035ba:	5d                   	pop    %ebp
  8035bb:	c3                   	ret    
  8035bc:	39 f0                	cmp    %esi,%eax
  8035be:	0f 87 ac 00 00 00    	ja     803670 <__umoddi3+0xfc>
  8035c4:	0f bd e8             	bsr    %eax,%ebp
  8035c7:	83 f5 1f             	xor    $0x1f,%ebp
  8035ca:	0f 84 ac 00 00 00    	je     80367c <__umoddi3+0x108>
  8035d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8035d5:	29 ef                	sub    %ebp,%edi
  8035d7:	89 fe                	mov    %edi,%esi
  8035d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035dd:	89 e9                	mov    %ebp,%ecx
  8035df:	d3 e0                	shl    %cl,%eax
  8035e1:	89 d7                	mov    %edx,%edi
  8035e3:	89 f1                	mov    %esi,%ecx
  8035e5:	d3 ef                	shr    %cl,%edi
  8035e7:	09 c7                	or     %eax,%edi
  8035e9:	89 e9                	mov    %ebp,%ecx
  8035eb:	d3 e2                	shl    %cl,%edx
  8035ed:	89 14 24             	mov    %edx,(%esp)
  8035f0:	89 d8                	mov    %ebx,%eax
  8035f2:	d3 e0                	shl    %cl,%eax
  8035f4:	89 c2                	mov    %eax,%edx
  8035f6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035fa:	d3 e0                	shl    %cl,%eax
  8035fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803600:	8b 44 24 08          	mov    0x8(%esp),%eax
  803604:	89 f1                	mov    %esi,%ecx
  803606:	d3 e8                	shr    %cl,%eax
  803608:	09 d0                	or     %edx,%eax
  80360a:	d3 eb                	shr    %cl,%ebx
  80360c:	89 da                	mov    %ebx,%edx
  80360e:	f7 f7                	div    %edi
  803610:	89 d3                	mov    %edx,%ebx
  803612:	f7 24 24             	mull   (%esp)
  803615:	89 c6                	mov    %eax,%esi
  803617:	89 d1                	mov    %edx,%ecx
  803619:	39 d3                	cmp    %edx,%ebx
  80361b:	0f 82 87 00 00 00    	jb     8036a8 <__umoddi3+0x134>
  803621:	0f 84 91 00 00 00    	je     8036b8 <__umoddi3+0x144>
  803627:	8b 54 24 04          	mov    0x4(%esp),%edx
  80362b:	29 f2                	sub    %esi,%edx
  80362d:	19 cb                	sbb    %ecx,%ebx
  80362f:	89 d8                	mov    %ebx,%eax
  803631:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803635:	d3 e0                	shl    %cl,%eax
  803637:	89 e9                	mov    %ebp,%ecx
  803639:	d3 ea                	shr    %cl,%edx
  80363b:	09 d0                	or     %edx,%eax
  80363d:	89 e9                	mov    %ebp,%ecx
  80363f:	d3 eb                	shr    %cl,%ebx
  803641:	89 da                	mov    %ebx,%edx
  803643:	83 c4 1c             	add    $0x1c,%esp
  803646:	5b                   	pop    %ebx
  803647:	5e                   	pop    %esi
  803648:	5f                   	pop    %edi
  803649:	5d                   	pop    %ebp
  80364a:	c3                   	ret    
  80364b:	90                   	nop
  80364c:	89 fd                	mov    %edi,%ebp
  80364e:	85 ff                	test   %edi,%edi
  803650:	75 0b                	jne    80365d <__umoddi3+0xe9>
  803652:	b8 01 00 00 00       	mov    $0x1,%eax
  803657:	31 d2                	xor    %edx,%edx
  803659:	f7 f7                	div    %edi
  80365b:	89 c5                	mov    %eax,%ebp
  80365d:	89 f0                	mov    %esi,%eax
  80365f:	31 d2                	xor    %edx,%edx
  803661:	f7 f5                	div    %ebp
  803663:	89 c8                	mov    %ecx,%eax
  803665:	f7 f5                	div    %ebp
  803667:	89 d0                	mov    %edx,%eax
  803669:	e9 44 ff ff ff       	jmp    8035b2 <__umoddi3+0x3e>
  80366e:	66 90                	xchg   %ax,%ax
  803670:	89 c8                	mov    %ecx,%eax
  803672:	89 f2                	mov    %esi,%edx
  803674:	83 c4 1c             	add    $0x1c,%esp
  803677:	5b                   	pop    %ebx
  803678:	5e                   	pop    %esi
  803679:	5f                   	pop    %edi
  80367a:	5d                   	pop    %ebp
  80367b:	c3                   	ret    
  80367c:	3b 04 24             	cmp    (%esp),%eax
  80367f:	72 06                	jb     803687 <__umoddi3+0x113>
  803681:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803685:	77 0f                	ja     803696 <__umoddi3+0x122>
  803687:	89 f2                	mov    %esi,%edx
  803689:	29 f9                	sub    %edi,%ecx
  80368b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80368f:	89 14 24             	mov    %edx,(%esp)
  803692:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803696:	8b 44 24 04          	mov    0x4(%esp),%eax
  80369a:	8b 14 24             	mov    (%esp),%edx
  80369d:	83 c4 1c             	add    $0x1c,%esp
  8036a0:	5b                   	pop    %ebx
  8036a1:	5e                   	pop    %esi
  8036a2:	5f                   	pop    %edi
  8036a3:	5d                   	pop    %ebp
  8036a4:	c3                   	ret    
  8036a5:	8d 76 00             	lea    0x0(%esi),%esi
  8036a8:	2b 04 24             	sub    (%esp),%eax
  8036ab:	19 fa                	sbb    %edi,%edx
  8036ad:	89 d1                	mov    %edx,%ecx
  8036af:	89 c6                	mov    %eax,%esi
  8036b1:	e9 71 ff ff ff       	jmp    803627 <__umoddi3+0xb3>
  8036b6:	66 90                	xchg   %ax,%ax
  8036b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036bc:	72 ea                	jb     8036a8 <__umoddi3+0x134>
  8036be:	89 d9                	mov    %ebx,%ecx
  8036c0:	e9 62 ff ff ff       	jmp    803627 <__umoddi3+0xb3>
