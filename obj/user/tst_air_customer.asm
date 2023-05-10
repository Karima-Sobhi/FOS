
obj/user/tst_air_customer:     file format elf32-i386


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
  800031:	e8 dc 03 00 00       	call   800412 <libmain>
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
  80003e:	81 ec 8c 01 00 00    	sub    $0x18c,%esp
	int32 parentenvID = sys_getparentenvid();
  800044:	e8 2c 1c 00 00       	call   801c75 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb 09 35 80 00       	mov    $0x803509,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb 13 35 80 00       	mov    $0x803513,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb 1f 35 80 00       	mov    $0x80351f,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb 2e 35 80 00       	mov    $0x80352e,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb 3d 35 80 00       	mov    $0x80353d,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb 52 35 80 00       	mov    $0x803552,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb 67 35 80 00       	mov    $0x803567,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb 78 35 80 00       	mov    $0x803578,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb 89 35 80 00       	mov    $0x803589,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb 9a 35 80 00       	mov    $0x80359a,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb a3 35 80 00       	mov    $0x8035a3,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb ad 35 80 00       	mov    $0x8035ad,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb b8 35 80 00       	mov    $0x8035b8,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb c4 35 80 00       	mov    $0x8035c4,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb ce 35 80 00       	mov    $0x8035ce,%ebx
  800198:	ba 0a 00 00 00       	mov    $0xa,%edx
  80019d:	89 c7                	mov    %eax,%edi
  80019f:	89 de                	mov    %ebx,%esi
  8001a1:	89 d1                	mov    %edx,%ecx
  8001a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a5:	c7 85 f7 fe ff ff 63 	movl   $0x72656c63,-0x109(%ebp)
  8001ac:	6c 65 72 
  8001af:	66 c7 85 fb fe ff ff 	movw   $0x6b,-0x105(%ebp)
  8001b6:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001b8:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8001be:	bb d8 35 80 00       	mov    $0x8035d8,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb e6 35 80 00       	mov    $0x8035e6,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb f5 35 80 00       	mov    $0x8035f5,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb fc 35 80 00       	mov    $0x8035fc,%ebx
  80020b:	ba 07 00 00 00       	mov    $0x7,%edx
  800210:	89 c7                	mov    %eax,%edi
  800212:	89 de                	mov    %ebx,%esi
  800214:	89 d1                	mov    %edx,%ecx
  800216:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	// Get the shared variables from the main program ***********************************

	struct Customer * customers = sget(parentenvID, _customers);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80021e:	50                   	push   %eax
  80021f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800222:	e8 1f 15 00 00       	call   801746 <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 0a 15 00 00       	call   801746 <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 f2 14 00 00       	call   801746 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 da 14 00 00       	call   801746 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	// *********************************************************************************

	int custId, flightType;
	sys_waitSemaphore(parentenvID, _custCounterCS);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 92 18 00 00       	call   801b16 <sys_waitSemaphore>
  800284:	83 c4 10             	add    $0x10,%esp
	{
		custId = *custCounter;
  800287:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80028a:	8b 00                	mov    (%eax),%eax
  80028c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		//cprintf("custCounter= %d\n", *custCounter);
		*custCounter = *custCounter +1;
  80028f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800292:	8b 00                	mov    (%eax),%eax
  800294:	8d 50 01             	lea    0x1(%eax),%edx
  800297:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80029a:	89 10                	mov    %edx,(%eax)
	}
	sys_signalSemaphore(parentenvID, _custCounterCS);
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8002a5:	50                   	push   %eax
  8002a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a9:	e8 86 18 00 00       	call   801b34 <sys_signalSemaphore>
  8002ae:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	sys_waitSemaphore(parentenvID, _clerk);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	8d 85 f7 fe ff ff    	lea    -0x109(%ebp),%eax
  8002ba:	50                   	push   %eax
  8002bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002be:	e8 53 18 00 00       	call   801b16 <sys_waitSemaphore>
  8002c3:	83 c4 10             	add    $0x10,%esp

	//enqueue the request
	flightType = customers[custId].flightType;
  8002c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d3:	01 d0                	add    %edx,%eax
  8002d5:	8b 00                	mov    (%eax),%eax
  8002d7:	89 45 cc             	mov    %eax,-0x34(%ebp)
	sys_waitSemaphore(parentenvID, _custQueueCS);
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  8002e3:	50                   	push   %eax
  8002e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e7:	e8 2a 18 00 00       	call   801b16 <sys_waitSemaphore>
  8002ec:	83 c4 10             	add    $0x10,%esp
	{
		cust_ready_queue[*queue_in] = custId;
  8002ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002f2:	8b 00                	mov    (%eax),%eax
  8002f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002fe:	01 c2                	add    %eax,%edx
  800300:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800303:	89 02                	mov    %eax,(%edx)
		*queue_in = *queue_in +1;
  800305:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800308:	8b 00                	mov    (%eax),%eax
  80030a:	8d 50 01             	lea    0x1(%eax),%edx
  80030d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800310:	89 10                	mov    %edx,(%eax)
	}
	sys_signalSemaphore(parentenvID, _custQueueCS);
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  80031b:	50                   	push   %eax
  80031c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80031f:	e8 10 18 00 00       	call   801b34 <sys_signalSemaphore>
  800324:	83 c4 10             	add    $0x10,%esp

	//signal ready
	sys_signalSemaphore(parentenvID, _cust_ready);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  800330:	50                   	push   %eax
  800331:	ff 75 e4             	pushl  -0x1c(%ebp)
  800334:	e8 fb 17 00 00       	call   801b34 <sys_signalSemaphore>
  800339:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  80033c:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800342:	bb 03 36 80 00       	mov    $0x803603,%ebx
  800347:	ba 0e 00 00 00       	mov    $0xe,%edx
  80034c:	89 c7                	mov    %eax,%edi
  80034e:	89 de                	mov    %ebx,%esi
  800350:	89 d1                	mov    %edx,%ecx
  800352:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800354:	8d 95 bc fe ff ff    	lea    -0x144(%ebp),%edx
  80035a:	b9 04 00 00 00       	mov    $0x4,%ecx
  80035f:	b8 00 00 00 00       	mov    $0x0,%eax
  800364:	89 d7                	mov    %edx,%edi
  800366:	f3 ab                	rep stos %eax,%es:(%edi)
	char id[5]; char sname[50];
	ltostr(custId, id);
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  800371:	50                   	push   %eax
  800372:	ff 75 d0             	pushl  -0x30(%ebp)
  800375:	e8 d0 0d 00 00       	call   80114a <ltostr>
  80037a:	83 c4 10             	add    $0x10,%esp
	strcconcat(prefix, id, sname);
  80037d:	83 ec 04             	sub    $0x4,%esp
  800380:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800386:	50                   	push   %eax
  800387:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  80038d:	50                   	push   %eax
  80038e:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800394:	50                   	push   %eax
  800395:	e8 a8 0e 00 00       	call   801242 <strcconcat>
  80039a:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(parentenvID, sname);
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  8003a6:	50                   	push   %eax
  8003a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003aa:	e8 67 17 00 00       	call   801b16 <sys_waitSemaphore>
  8003af:	83 c4 10             	add    $0x10,%esp

	//print the customer status
	if(customers[custId].booked == 1)
  8003b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bf:	01 d0                	add    %edx,%eax
  8003c1:	8b 40 04             	mov    0x4(%eax),%eax
  8003c4:	83 f8 01             	cmp    $0x1,%eax
  8003c7:	75 18                	jne    8003e1 <_main+0x3a9>
	{
		cprintf("cust %d: finished (BOOKED flight %d) \n", custId, flightType);
  8003c9:	83 ec 04             	sub    $0x4,%esp
  8003cc:	ff 75 cc             	pushl  -0x34(%ebp)
  8003cf:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d2:	68 c0 34 80 00       	push   $0x8034c0
  8003d7:	e8 46 02 00 00       	call   800622 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	eb 13                	jmp    8003f4 <_main+0x3bc>
	}
	else
	{
		cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  8003e1:	83 ec 08             	sub    $0x8,%esp
  8003e4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e7:	68 e8 34 80 00       	push   $0x8034e8
  8003ec:	e8 31 02 00 00       	call   800622 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	sys_signalSemaphore(parentenvID, _custTerminated);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8003fd:	50                   	push   %eax
  8003fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800401:	e8 2e 17 00 00       	call   801b34 <sys_signalSemaphore>
  800406:	83 c4 10             	add    $0x10,%esp

	return;
  800409:	90                   	nop
}
  80040a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80040d:	5b                   	pop    %ebx
  80040e:	5e                   	pop    %esi
  80040f:	5f                   	pop    %edi
  800410:	5d                   	pop    %ebp
  800411:	c3                   	ret    

00800412 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800418:	e8 3f 18 00 00       	call   801c5c <sys_getenvindex>
  80041d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800420:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800423:	89 d0                	mov    %edx,%eax
  800425:	c1 e0 03             	shl    $0x3,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	01 c0                	add    %eax,%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800435:	01 d0                	add    %edx,%eax
  800437:	c1 e0 04             	shl    $0x4,%eax
  80043a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043f:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800444:	a1 20 40 80 00       	mov    0x804020,%eax
  800449:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80044f:	84 c0                	test   %al,%al
  800451:	74 0f                	je     800462 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800453:	a1 20 40 80 00       	mov    0x804020,%eax
  800458:	05 5c 05 00 00       	add    $0x55c,%eax
  80045d:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800462:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800466:	7e 0a                	jle    800472 <libmain+0x60>
		binaryname = argv[0];
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 0c             	pushl  0xc(%ebp)
  800478:	ff 75 08             	pushl  0x8(%ebp)
  80047b:	e8 b8 fb ff ff       	call   800038 <_main>
  800480:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800483:	e8 e1 15 00 00       	call   801a69 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800488:	83 ec 0c             	sub    $0xc,%esp
  80048b:	68 3c 36 80 00       	push   $0x80363c
  800490:	e8 8d 01 00 00       	call   800622 <cprintf>
  800495:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800498:	a1 20 40 80 00       	mov    0x804020,%eax
  80049d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8004a3:	a1 20 40 80 00       	mov    0x804020,%eax
  8004a8:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8004ae:	83 ec 04             	sub    $0x4,%esp
  8004b1:	52                   	push   %edx
  8004b2:	50                   	push   %eax
  8004b3:	68 64 36 80 00       	push   $0x803664
  8004b8:	e8 65 01 00 00       	call   800622 <cprintf>
  8004bd:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004c0:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c5:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8004cb:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8004d6:	a1 20 40 80 00       	mov    0x804020,%eax
  8004db:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8004e1:	51                   	push   %ecx
  8004e2:	52                   	push   %edx
  8004e3:	50                   	push   %eax
  8004e4:	68 8c 36 80 00       	push   $0x80368c
  8004e9:	e8 34 01 00 00       	call   800622 <cprintf>
  8004ee:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	50                   	push   %eax
  800500:	68 e4 36 80 00       	push   $0x8036e4
  800505:	e8 18 01 00 00       	call   800622 <cprintf>
  80050a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80050d:	83 ec 0c             	sub    $0xc,%esp
  800510:	68 3c 36 80 00       	push   $0x80363c
  800515:	e8 08 01 00 00       	call   800622 <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80051d:	e8 61 15 00 00       	call   801a83 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800522:	e8 19 00 00 00       	call   800540 <exit>
}
  800527:	90                   	nop
  800528:	c9                   	leave  
  800529:	c3                   	ret    

0080052a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80052a:	55                   	push   %ebp
  80052b:	89 e5                	mov    %esp,%ebp
  80052d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800530:	83 ec 0c             	sub    $0xc,%esp
  800533:	6a 00                	push   $0x0
  800535:	e8 ee 16 00 00       	call   801c28 <sys_destroy_env>
  80053a:	83 c4 10             	add    $0x10,%esp
}
  80053d:	90                   	nop
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <exit>:

void
exit(void)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800546:	e8 43 17 00 00       	call   801c8e <sys_exit_env>
}
  80054b:	90                   	nop
  80054c:	c9                   	leave  
  80054d:	c3                   	ret    

0080054e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80054e:	55                   	push   %ebp
  80054f:	89 e5                	mov    %esp,%ebp
  800551:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	8d 48 01             	lea    0x1(%eax),%ecx
  80055c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055f:	89 0a                	mov    %ecx,(%edx)
  800561:	8b 55 08             	mov    0x8(%ebp),%edx
  800564:	88 d1                	mov    %dl,%cl
  800566:	8b 55 0c             	mov    0xc(%ebp),%edx
  800569:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80056d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800570:	8b 00                	mov    (%eax),%eax
  800572:	3d ff 00 00 00       	cmp    $0xff,%eax
  800577:	75 2c                	jne    8005a5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800579:	a0 24 40 80 00       	mov    0x804024,%al
  80057e:	0f b6 c0             	movzbl %al,%eax
  800581:	8b 55 0c             	mov    0xc(%ebp),%edx
  800584:	8b 12                	mov    (%edx),%edx
  800586:	89 d1                	mov    %edx,%ecx
  800588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058b:	83 c2 08             	add    $0x8,%edx
  80058e:	83 ec 04             	sub    $0x4,%esp
  800591:	50                   	push   %eax
  800592:	51                   	push   %ecx
  800593:	52                   	push   %edx
  800594:	e8 22 13 00 00       	call   8018bb <sys_cputs>
  800599:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a8:	8b 40 04             	mov    0x4(%eax),%eax
  8005ab:	8d 50 01             	lea    0x1(%eax),%edx
  8005ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005b4:	90                   	nop
  8005b5:	c9                   	leave  
  8005b6:	c3                   	ret    

008005b7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005b7:	55                   	push   %ebp
  8005b8:	89 e5                	mov    %esp,%ebp
  8005ba:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c7:	00 00 00 
	b.cnt = 0;
  8005ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005d1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005d4:	ff 75 0c             	pushl  0xc(%ebp)
  8005d7:	ff 75 08             	pushl  0x8(%ebp)
  8005da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005e0:	50                   	push   %eax
  8005e1:	68 4e 05 80 00       	push   $0x80054e
  8005e6:	e8 11 02 00 00       	call   8007fc <vprintfmt>
  8005eb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005ee:	a0 24 40 80 00       	mov    0x804024,%al
  8005f3:	0f b6 c0             	movzbl %al,%eax
  8005f6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005fc:	83 ec 04             	sub    $0x4,%esp
  8005ff:	50                   	push   %eax
  800600:	52                   	push   %edx
  800601:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800607:	83 c0 08             	add    $0x8,%eax
  80060a:	50                   	push   %eax
  80060b:	e8 ab 12 00 00       	call   8018bb <sys_cputs>
  800610:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800613:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80061a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800620:	c9                   	leave  
  800621:	c3                   	ret    

00800622 <cprintf>:

int cprintf(const char *fmt, ...) {
  800622:	55                   	push   %ebp
  800623:	89 e5                	mov    %esp,%ebp
  800625:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800628:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80062f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800632:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800635:	8b 45 08             	mov    0x8(%ebp),%eax
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 f4             	pushl  -0xc(%ebp)
  80063e:	50                   	push   %eax
  80063f:	e8 73 ff ff ff       	call   8005b7 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80064a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80064d:	c9                   	leave  
  80064e:	c3                   	ret    

0080064f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80064f:	55                   	push   %ebp
  800650:	89 e5                	mov    %esp,%ebp
  800652:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800655:	e8 0f 14 00 00       	call   801a69 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80065a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80065d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	83 ec 08             	sub    $0x8,%esp
  800666:	ff 75 f4             	pushl  -0xc(%ebp)
  800669:	50                   	push   %eax
  80066a:	e8 48 ff ff ff       	call   8005b7 <vcprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
  800672:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800675:	e8 09 14 00 00       	call   801a83 <sys_enable_interrupt>
	return cnt;
  80067a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80067d:	c9                   	leave  
  80067e:	c3                   	ret    

0080067f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80067f:	55                   	push   %ebp
  800680:	89 e5                	mov    %esp,%ebp
  800682:	53                   	push   %ebx
  800683:	83 ec 14             	sub    $0x14,%esp
  800686:	8b 45 10             	mov    0x10(%ebp),%eax
  800689:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800692:	8b 45 18             	mov    0x18(%ebp),%eax
  800695:	ba 00 00 00 00       	mov    $0x0,%edx
  80069a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069d:	77 55                	ja     8006f4 <printnum+0x75>
  80069f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006a2:	72 05                	jb     8006a9 <printnum+0x2a>
  8006a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a7:	77 4b                	ja     8006f4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ac:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006af:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b7:	52                   	push   %edx
  8006b8:	50                   	push   %eax
  8006b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8006bf:	e8 94 2b 00 00       	call   803258 <__udivdi3>
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	83 ec 04             	sub    $0x4,%esp
  8006ca:	ff 75 20             	pushl  0x20(%ebp)
  8006cd:	53                   	push   %ebx
  8006ce:	ff 75 18             	pushl  0x18(%ebp)
  8006d1:	52                   	push   %edx
  8006d2:	50                   	push   %eax
  8006d3:	ff 75 0c             	pushl  0xc(%ebp)
  8006d6:	ff 75 08             	pushl  0x8(%ebp)
  8006d9:	e8 a1 ff ff ff       	call   80067f <printnum>
  8006de:	83 c4 20             	add    $0x20,%esp
  8006e1:	eb 1a                	jmp    8006fd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 20             	pushl  0x20(%ebp)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	ff d0                	call   *%eax
  8006f1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f4:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006fb:	7f e6                	jg     8006e3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006fd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800700:	bb 00 00 00 00       	mov    $0x0,%ebx
  800705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80070b:	53                   	push   %ebx
  80070c:	51                   	push   %ecx
  80070d:	52                   	push   %edx
  80070e:	50                   	push   %eax
  80070f:	e8 54 2c 00 00       	call   803368 <__umoddi3>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	05 14 39 80 00       	add    $0x803914,%eax
  80071c:	8a 00                	mov    (%eax),%al
  80071e:	0f be c0             	movsbl %al,%eax
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	50                   	push   %eax
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
}
  800730:	90                   	nop
  800731:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800739:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80073d:	7e 1c                	jle    80075b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	8d 50 08             	lea    0x8(%eax),%edx
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	89 10                	mov    %edx,(%eax)
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	83 e8 08             	sub    $0x8,%eax
  800754:	8b 50 04             	mov    0x4(%eax),%edx
  800757:	8b 00                	mov    (%eax),%eax
  800759:	eb 40                	jmp    80079b <getuint+0x65>
	else if (lflag)
  80075b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80075f:	74 1e                	je     80077f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	8d 50 04             	lea    0x4(%eax),%edx
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	89 10                	mov    %edx,(%eax)
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	ba 00 00 00 00       	mov    $0x0,%edx
  80077d:	eb 1c                	jmp    80079b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	8d 50 04             	lea    0x4(%eax),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	89 10                	mov    %edx,(%eax)
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	83 e8 04             	sub    $0x4,%eax
  800794:	8b 00                	mov    (%eax),%eax
  800796:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80079b:	5d                   	pop    %ebp
  80079c:	c3                   	ret    

0080079d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007a0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a4:	7e 1c                	jle    8007c2 <getint+0x25>
		return va_arg(*ap, long long);
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	8d 50 08             	lea    0x8(%eax),%edx
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	89 10                	mov    %edx,(%eax)
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	83 e8 08             	sub    $0x8,%eax
  8007bb:	8b 50 04             	mov    0x4(%eax),%edx
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	eb 38                	jmp    8007fa <getint+0x5d>
	else if (lflag)
  8007c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c6:	74 1a                	je     8007e2 <getint+0x45>
		return va_arg(*ap, long);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	8d 50 04             	lea    0x4(%eax),%edx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	89 10                	mov    %edx,(%eax)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	83 e8 04             	sub    $0x4,%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	99                   	cltd   
  8007e0:	eb 18                	jmp    8007fa <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	89 10                	mov    %edx,(%eax)
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	83 e8 04             	sub    $0x4,%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	99                   	cltd   
}
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	56                   	push   %esi
  800800:	53                   	push   %ebx
  800801:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800804:	eb 17                	jmp    80081d <vprintfmt+0x21>
			if (ch == '\0')
  800806:	85 db                	test   %ebx,%ebx
  800808:	0f 84 af 03 00 00    	je     800bbd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	53                   	push   %ebx
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80081d:	8b 45 10             	mov    0x10(%ebp),%eax
  800820:	8d 50 01             	lea    0x1(%eax),%edx
  800823:	89 55 10             	mov    %edx,0x10(%ebp)
  800826:	8a 00                	mov    (%eax),%al
  800828:	0f b6 d8             	movzbl %al,%ebx
  80082b:	83 fb 25             	cmp    $0x25,%ebx
  80082e:	75 d6                	jne    800806 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800830:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800834:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80083b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800842:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800849:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800850:	8b 45 10             	mov    0x10(%ebp),%eax
  800853:	8d 50 01             	lea    0x1(%eax),%edx
  800856:	89 55 10             	mov    %edx,0x10(%ebp)
  800859:	8a 00                	mov    (%eax),%al
  80085b:	0f b6 d8             	movzbl %al,%ebx
  80085e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800861:	83 f8 55             	cmp    $0x55,%eax
  800864:	0f 87 2b 03 00 00    	ja     800b95 <vprintfmt+0x399>
  80086a:	8b 04 85 38 39 80 00 	mov    0x803938(,%eax,4),%eax
  800871:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800873:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800877:	eb d7                	jmp    800850 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800879:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80087d:	eb d1                	jmp    800850 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800886:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800889:	89 d0                	mov    %edx,%eax
  80088b:	c1 e0 02             	shl    $0x2,%eax
  80088e:	01 d0                	add    %edx,%eax
  800890:	01 c0                	add    %eax,%eax
  800892:	01 d8                	add    %ebx,%eax
  800894:	83 e8 30             	sub    $0x30,%eax
  800897:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80089a:	8b 45 10             	mov    0x10(%ebp),%eax
  80089d:	8a 00                	mov    (%eax),%al
  80089f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008a2:	83 fb 2f             	cmp    $0x2f,%ebx
  8008a5:	7e 3e                	jle    8008e5 <vprintfmt+0xe9>
  8008a7:	83 fb 39             	cmp    $0x39,%ebx
  8008aa:	7f 39                	jg     8008e5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ac:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008af:	eb d5                	jmp    800886 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 c0 04             	add    $0x4,%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008c5:	eb 1f                	jmp    8008e6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008cb:	79 83                	jns    800850 <vprintfmt+0x54>
				width = 0;
  8008cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008d4:	e9 77 ff ff ff       	jmp    800850 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008e0:	e9 6b ff ff ff       	jmp    800850 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008e5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ea:	0f 89 60 ff ff ff    	jns    800850 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008fd:	e9 4e ff ff ff       	jmp    800850 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800902:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800905:	e9 46 ff ff ff       	jmp    800850 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80090a:	8b 45 14             	mov    0x14(%ebp),%eax
  80090d:	83 c0 04             	add    $0x4,%eax
  800910:	89 45 14             	mov    %eax,0x14(%ebp)
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	83 e8 04             	sub    $0x4,%eax
  800919:	8b 00                	mov    (%eax),%eax
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	ff 75 0c             	pushl  0xc(%ebp)
  800921:	50                   	push   %eax
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	ff d0                	call   *%eax
  800927:	83 c4 10             	add    $0x10,%esp
			break;
  80092a:	e9 89 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 c0 04             	add    $0x4,%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 e8 04             	sub    $0x4,%eax
  80093e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800940:	85 db                	test   %ebx,%ebx
  800942:	79 02                	jns    800946 <vprintfmt+0x14a>
				err = -err;
  800944:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800946:	83 fb 64             	cmp    $0x64,%ebx
  800949:	7f 0b                	jg     800956 <vprintfmt+0x15a>
  80094b:	8b 34 9d 80 37 80 00 	mov    0x803780(,%ebx,4),%esi
  800952:	85 f6                	test   %esi,%esi
  800954:	75 19                	jne    80096f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800956:	53                   	push   %ebx
  800957:	68 25 39 80 00       	push   $0x803925
  80095c:	ff 75 0c             	pushl  0xc(%ebp)
  80095f:	ff 75 08             	pushl  0x8(%ebp)
  800962:	e8 5e 02 00 00       	call   800bc5 <printfmt>
  800967:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80096a:	e9 49 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80096f:	56                   	push   %esi
  800970:	68 2e 39 80 00       	push   $0x80392e
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	ff 75 08             	pushl  0x8(%ebp)
  80097b:	e8 45 02 00 00       	call   800bc5 <printfmt>
  800980:	83 c4 10             	add    $0x10,%esp
			break;
  800983:	e9 30 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	83 c0 04             	add    $0x4,%eax
  80098e:	89 45 14             	mov    %eax,0x14(%ebp)
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	83 e8 04             	sub    $0x4,%eax
  800997:	8b 30                	mov    (%eax),%esi
  800999:	85 f6                	test   %esi,%esi
  80099b:	75 05                	jne    8009a2 <vprintfmt+0x1a6>
				p = "(null)";
  80099d:	be 31 39 80 00       	mov    $0x803931,%esi
			if (width > 0 && padc != '-')
  8009a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a6:	7e 6d                	jle    800a15 <vprintfmt+0x219>
  8009a8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ac:	74 67                	je     800a15 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b1:	83 ec 08             	sub    $0x8,%esp
  8009b4:	50                   	push   %eax
  8009b5:	56                   	push   %esi
  8009b6:	e8 0c 03 00 00       	call   800cc7 <strnlen>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009c1:	eb 16                	jmp    8009d9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009c3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c7:	83 ec 08             	sub    $0x8,%esp
  8009ca:	ff 75 0c             	pushl  0xc(%ebp)
  8009cd:	50                   	push   %eax
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	ff d0                	call   *%eax
  8009d3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009dd:	7f e4                	jg     8009c3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009df:	eb 34                	jmp    800a15 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009e5:	74 1c                	je     800a03 <vprintfmt+0x207>
  8009e7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009ea:	7e 05                	jle    8009f1 <vprintfmt+0x1f5>
  8009ec:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ef:	7e 12                	jle    800a03 <vprintfmt+0x207>
					putch('?', putdat);
  8009f1:	83 ec 08             	sub    $0x8,%esp
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	6a 3f                	push   $0x3f
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	ff d0                	call   *%eax
  8009fe:	83 c4 10             	add    $0x10,%esp
  800a01:	eb 0f                	jmp    800a12 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	53                   	push   %ebx
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	ff d0                	call   *%eax
  800a0f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a12:	ff 4d e4             	decl   -0x1c(%ebp)
  800a15:	89 f0                	mov    %esi,%eax
  800a17:	8d 70 01             	lea    0x1(%eax),%esi
  800a1a:	8a 00                	mov    (%eax),%al
  800a1c:	0f be d8             	movsbl %al,%ebx
  800a1f:	85 db                	test   %ebx,%ebx
  800a21:	74 24                	je     800a47 <vprintfmt+0x24b>
  800a23:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a27:	78 b8                	js     8009e1 <vprintfmt+0x1e5>
  800a29:	ff 4d e0             	decl   -0x20(%ebp)
  800a2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a30:	79 af                	jns    8009e1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a32:	eb 13                	jmp    800a47 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a34:	83 ec 08             	sub    $0x8,%esp
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	6a 20                	push   $0x20
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	ff d0                	call   *%eax
  800a41:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a44:	ff 4d e4             	decl   -0x1c(%ebp)
  800a47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4b:	7f e7                	jg     800a34 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a4d:	e9 66 01 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 e8             	pushl  -0x18(%ebp)
  800a58:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5b:	50                   	push   %eax
  800a5c:	e8 3c fd ff ff       	call   80079d <getint>
  800a61:	83 c4 10             	add    $0x10,%esp
  800a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a70:	85 d2                	test   %edx,%edx
  800a72:	79 23                	jns    800a97 <vprintfmt+0x29b>
				putch('-', putdat);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	6a 2d                	push   $0x2d
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	ff d0                	call   *%eax
  800a81:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8a:	f7 d8                	neg    %eax
  800a8c:	83 d2 00             	adc    $0x0,%edx
  800a8f:	f7 da                	neg    %edx
  800a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a97:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9e:	e9 bc 00 00 00       	jmp    800b5f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa9:	8d 45 14             	lea    0x14(%ebp),%eax
  800aac:	50                   	push   %eax
  800aad:	e8 84 fc ff ff       	call   800736 <getuint>
  800ab2:	83 c4 10             	add    $0x10,%esp
  800ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800abb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac2:	e9 98 00 00 00       	jmp    800b5f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac7:	83 ec 08             	sub    $0x8,%esp
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	6a 58                	push   $0x58
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	ff d0                	call   *%eax
  800ad4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	6a 58                	push   $0x58
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	ff d0                	call   *%eax
  800ae4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	6a 58                	push   $0x58
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	ff d0                	call   *%eax
  800af4:	83 c4 10             	add    $0x10,%esp
			break;
  800af7:	e9 bc 00 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800afc:	83 ec 08             	sub    $0x8,%esp
  800aff:	ff 75 0c             	pushl  0xc(%ebp)
  800b02:	6a 30                	push   $0x30
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	ff d0                	call   *%eax
  800b09:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 78                	push   $0x78
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1f:	83 c0 04             	add    $0x4,%eax
  800b22:	89 45 14             	mov    %eax,0x14(%ebp)
  800b25:	8b 45 14             	mov    0x14(%ebp),%eax
  800b28:	83 e8 04             	sub    $0x4,%eax
  800b2b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b37:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b3e:	eb 1f                	jmp    800b5f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	ff 75 e8             	pushl  -0x18(%ebp)
  800b46:	8d 45 14             	lea    0x14(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	e8 e7 fb ff ff       	call   800736 <getuint>
  800b4f:	83 c4 10             	add    $0x10,%esp
  800b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b55:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b58:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b5f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b66:	83 ec 04             	sub    $0x4,%esp
  800b69:	52                   	push   %edx
  800b6a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b6d:	50                   	push   %eax
  800b6e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b71:	ff 75 f0             	pushl  -0x10(%ebp)
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	ff 75 08             	pushl  0x8(%ebp)
  800b7a:	e8 00 fb ff ff       	call   80067f <printnum>
  800b7f:	83 c4 20             	add    $0x20,%esp
			break;
  800b82:	eb 34                	jmp    800bb8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	53                   	push   %ebx
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	ff d0                	call   *%eax
  800b90:	83 c4 10             	add    $0x10,%esp
			break;
  800b93:	eb 23                	jmp    800bb8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	6a 25                	push   $0x25
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	ff d0                	call   *%eax
  800ba2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba5:	ff 4d 10             	decl   0x10(%ebp)
  800ba8:	eb 03                	jmp    800bad <vprintfmt+0x3b1>
  800baa:	ff 4d 10             	decl   0x10(%ebp)
  800bad:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb0:	48                   	dec    %eax
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	3c 25                	cmp    $0x25,%al
  800bb5:	75 f3                	jne    800baa <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bb7:	90                   	nop
		}
	}
  800bb8:	e9 47 fc ff ff       	jmp    800804 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bbd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bce:	83 c0 04             	add    $0x4,%eax
  800bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bda:	50                   	push   %eax
  800bdb:	ff 75 0c             	pushl  0xc(%ebp)
  800bde:	ff 75 08             	pushl  0x8(%ebp)
  800be1:	e8 16 fc ff ff       	call   8007fc <vprintfmt>
  800be6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be9:	90                   	nop
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf2:	8b 40 08             	mov    0x8(%eax),%eax
  800bf5:	8d 50 01             	lea    0x1(%eax),%edx
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	8b 10                	mov    (%eax),%edx
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	8b 40 04             	mov    0x4(%eax),%eax
  800c09:	39 c2                	cmp    %eax,%edx
  800c0b:	73 12                	jae    800c1f <sprintputch+0x33>
		*b->buf++ = ch;
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	8d 48 01             	lea    0x1(%eax),%ecx
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	89 0a                	mov    %ecx,(%edx)
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	88 10                	mov    %dl,(%eax)
}
  800c1f:	90                   	nop
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	01 d0                	add    %edx,%eax
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c47:	74 06                	je     800c4f <vsnprintf+0x2d>
  800c49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4d:	7f 07                	jg     800c56 <vsnprintf+0x34>
		return -E_INVAL;
  800c4f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c54:	eb 20                	jmp    800c76 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c56:	ff 75 14             	pushl  0x14(%ebp)
  800c59:	ff 75 10             	pushl  0x10(%ebp)
  800c5c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c5f:	50                   	push   %eax
  800c60:	68 ec 0b 80 00       	push   $0x800bec
  800c65:	e8 92 fb ff ff       	call   8007fc <vprintfmt>
  800c6a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c70:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c7e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c81:	83 c0 04             	add    $0x4,%eax
  800c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c87:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8d:	50                   	push   %eax
  800c8e:	ff 75 0c             	pushl  0xc(%ebp)
  800c91:	ff 75 08             	pushl  0x8(%ebp)
  800c94:	e8 89 ff ff ff       	call   800c22 <vsnprintf>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800caa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb1:	eb 06                	jmp    800cb9 <strlen+0x15>
		n++;
  800cb3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 f1                	jne    800cb3 <strlen+0xf>
		n++;
	return n;
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc5:	c9                   	leave  
  800cc6:	c3                   	ret    

00800cc7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ccd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd4:	eb 09                	jmp    800cdf <strnlen+0x18>
		n++;
  800cd6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd9:	ff 45 08             	incl   0x8(%ebp)
  800cdc:	ff 4d 0c             	decl   0xc(%ebp)
  800cdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce3:	74 09                	je     800cee <strnlen+0x27>
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	84 c0                	test   %al,%al
  800cec:	75 e8                	jne    800cd6 <strnlen+0xf>
		n++;
	return n;
  800cee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cff:	90                   	nop
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8d 50 01             	lea    0x1(%eax),%edx
  800d06:	89 55 08             	mov    %edx,0x8(%ebp)
  800d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d12:	8a 12                	mov    (%edx),%dl
  800d14:	88 10                	mov    %dl,(%eax)
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	84 c0                	test   %al,%al
  800d1a:	75 e4                	jne    800d00 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1f:	c9                   	leave  
  800d20:	c3                   	ret    

00800d21 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d34:	eb 1f                	jmp    800d55 <strncpy+0x34>
		*dst++ = *src;
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8d 50 01             	lea    0x1(%eax),%edx
  800d3c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d42:	8a 12                	mov    (%edx),%dl
  800d44:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	74 03                	je     800d52 <strncpy+0x31>
			src++;
  800d4f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d52:	ff 45 fc             	incl   -0x4(%ebp)
  800d55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d58:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d5b:	72 d9                	jb     800d36 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d72:	74 30                	je     800da4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d74:	eb 16                	jmp    800d8c <strlcpy+0x2a>
			*dst++ = *src++;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d82:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d85:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d88:	8a 12                	mov    (%edx),%dl
  800d8a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d8c:	ff 4d 10             	decl   0x10(%ebp)
  800d8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d93:	74 09                	je     800d9e <strlcpy+0x3c>
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 d8                	jne    800d76 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800daa:	29 c2                	sub    %eax,%edx
  800dac:	89 d0                	mov    %edx,%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800db3:	eb 06                	jmp    800dbb <strcmp+0xb>
		p++, q++;
  800db5:	ff 45 08             	incl   0x8(%ebp)
  800db8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	84 c0                	test   %al,%al
  800dc2:	74 0e                	je     800dd2 <strcmp+0x22>
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8a 10                	mov    (%eax),%dl
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	38 c2                	cmp    %al,%dl
  800dd0:	74 e3                	je     800db5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f b6 d0             	movzbl %al,%edx
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	0f b6 c0             	movzbl %al,%eax
  800de2:	29 c2                	sub    %eax,%edx
  800de4:	89 d0                	mov    %edx,%eax
}
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800deb:	eb 09                	jmp    800df6 <strncmp+0xe>
		n--, p++, q++;
  800ded:	ff 4d 10             	decl   0x10(%ebp)
  800df0:	ff 45 08             	incl   0x8(%ebp)
  800df3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfa:	74 17                	je     800e13 <strncmp+0x2b>
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	74 0e                	je     800e13 <strncmp+0x2b>
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 10                	mov    (%eax),%dl
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	38 c2                	cmp    %al,%dl
  800e11:	74 da                	je     800ded <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e17:	75 07                	jne    800e20 <strncmp+0x38>
		return 0;
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1e:	eb 14                	jmp    800e34 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f b6 d0             	movzbl %al,%edx
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	0f b6 c0             	movzbl %al,%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
}
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 04             	sub    $0x4,%esp
  800e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e42:	eb 12                	jmp    800e56 <strchr+0x20>
		if (*s == c)
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e4c:	75 05                	jne    800e53 <strchr+0x1d>
			return (char *) s;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	eb 11                	jmp    800e64 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e53:	ff 45 08             	incl   0x8(%ebp)
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	84 c0                	test   %al,%al
  800e5d:	75 e5                	jne    800e44 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 04             	sub    $0x4,%esp
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e72:	eb 0d                	jmp    800e81 <strfind+0x1b>
		if (*s == c)
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7c:	74 0e                	je     800e8c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	84 c0                	test   %al,%al
  800e88:	75 ea                	jne    800e74 <strfind+0xe>
  800e8a:	eb 01                	jmp    800e8d <strfind+0x27>
		if (*s == c)
			break;
  800e8c:	90                   	nop
	return (char *) s;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ea4:	eb 0e                	jmp    800eb4 <memset+0x22>
		*p++ = c;
  800ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea9:	8d 50 01             	lea    0x1(%eax),%edx
  800eac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800eb4:	ff 4d f8             	decl   -0x8(%ebp)
  800eb7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ebb:	79 e9                	jns    800ea6 <memset+0x14>
		*p++ = c;

	return v;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ed4:	eb 16                	jmp    800eec <memcpy+0x2a>
		*d++ = *s++;
  800ed6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ee8:	8a 12                	mov    (%edx),%dl
  800eea:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	75 dd                	jne    800ed6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efc:	c9                   	leave  
  800efd:	c3                   	ret    

00800efe <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f13:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f16:	73 50                	jae    800f68 <memmove+0x6a>
  800f18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	01 d0                	add    %edx,%eax
  800f20:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f23:	76 43                	jbe    800f68 <memmove+0x6a>
		s += n;
  800f25:	8b 45 10             	mov    0x10(%ebp),%eax
  800f28:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f31:	eb 10                	jmp    800f43 <memmove+0x45>
			*--d = *--s;
  800f33:	ff 4d f8             	decl   -0x8(%ebp)
  800f36:	ff 4d fc             	decl   -0x4(%ebp)
  800f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3c:	8a 10                	mov    (%eax),%dl
  800f3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f41:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f43:	8b 45 10             	mov    0x10(%ebp),%eax
  800f46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f49:	89 55 10             	mov    %edx,0x10(%ebp)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	75 e3                	jne    800f33 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f50:	eb 23                	jmp    800f75 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f55:	8d 50 01             	lea    0x1(%eax),%edx
  800f58:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f5b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f61:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f64:	8a 12                	mov    (%edx),%dl
  800f66:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f68:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f71:	85 c0                	test   %eax,%eax
  800f73:	75 dd                	jne    800f52 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f78:	c9                   	leave  
  800f79:	c3                   	ret    

00800f7a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f89:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f8c:	eb 2a                	jmp    800fb8 <memcmp+0x3e>
		if (*s1 != *s2)
  800f8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f91:	8a 10                	mov    (%eax),%dl
  800f93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	38 c2                	cmp    %al,%dl
  800f9a:	74 16                	je     800fb2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f b6 d0             	movzbl %al,%edx
  800fa4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 c0             	movzbl %al,%eax
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	eb 18                	jmp    800fca <memcmp+0x50>
		s1++, s2++;
  800fb2:	ff 45 fc             	incl   -0x4(%ebp)
  800fb5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fbe:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	75 c9                	jne    800f8e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    

00800fcc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	01 d0                	add    %edx,%eax
  800fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fdd:	eb 15                	jmp    800ff4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	0f b6 d0             	movzbl %al,%edx
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	0f b6 c0             	movzbl %al,%eax
  800fed:	39 c2                	cmp    %eax,%edx
  800fef:	74 0d                	je     800ffe <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ff1:	ff 45 08             	incl   0x8(%ebp)
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ffa:	72 e3                	jb     800fdf <memfind+0x13>
  800ffc:	eb 01                	jmp    800fff <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ffe:	90                   	nop
	return (void *) s;
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801002:	c9                   	leave  
  801003:	c3                   	ret    

00801004 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80100a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801011:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801018:	eb 03                	jmp    80101d <strtol+0x19>
		s++;
  80101a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	3c 20                	cmp    $0x20,%al
  801024:	74 f4                	je     80101a <strtol+0x16>
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 09                	cmp    $0x9,%al
  80102d:	74 eb                	je     80101a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 2b                	cmp    $0x2b,%al
  801036:	75 05                	jne    80103d <strtol+0x39>
		s++;
  801038:	ff 45 08             	incl   0x8(%ebp)
  80103b:	eb 13                	jmp    801050 <strtol+0x4c>
	else if (*s == '-')
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	3c 2d                	cmp    $0x2d,%al
  801044:	75 0a                	jne    801050 <strtol+0x4c>
		s++, neg = 1;
  801046:	ff 45 08             	incl   0x8(%ebp)
  801049:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801050:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801054:	74 06                	je     80105c <strtol+0x58>
  801056:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80105a:	75 20                	jne    80107c <strtol+0x78>
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 30                	cmp    $0x30,%al
  801063:	75 17                	jne    80107c <strtol+0x78>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	40                   	inc    %eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	3c 78                	cmp    $0x78,%al
  80106d:	75 0d                	jne    80107c <strtol+0x78>
		s += 2, base = 16;
  80106f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801073:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80107a:	eb 28                	jmp    8010a4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80107c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801080:	75 15                	jne    801097 <strtol+0x93>
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	3c 30                	cmp    $0x30,%al
  801089:	75 0c                	jne    801097 <strtol+0x93>
		s++, base = 8;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801095:	eb 0d                	jmp    8010a4 <strtol+0xa0>
	else if (base == 0)
  801097:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109b:	75 07                	jne    8010a4 <strtol+0xa0>
		base = 10;
  80109d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 2f                	cmp    $0x2f,%al
  8010ab:	7e 19                	jle    8010c6 <strtol+0xc2>
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	3c 39                	cmp    $0x39,%al
  8010b4:	7f 10                	jg     8010c6 <strtol+0xc2>
			dig = *s - '0';
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	0f be c0             	movsbl %al,%eax
  8010be:	83 e8 30             	sub    $0x30,%eax
  8010c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010c4:	eb 42                	jmp    801108 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 60                	cmp    $0x60,%al
  8010cd:	7e 19                	jle    8010e8 <strtol+0xe4>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 7a                	cmp    $0x7a,%al
  8010d6:	7f 10                	jg     8010e8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f be c0             	movsbl %al,%eax
  8010e0:	83 e8 57             	sub    $0x57,%eax
  8010e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e6:	eb 20                	jmp    801108 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 40                	cmp    $0x40,%al
  8010ef:	7e 39                	jle    80112a <strtol+0x126>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 5a                	cmp    $0x5a,%al
  8010f8:	7f 30                	jg     80112a <strtol+0x126>
			dig = *s - 'A' + 10;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f be c0             	movsbl %al,%eax
  801102:	83 e8 37             	sub    $0x37,%eax
  801105:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110e:	7d 19                	jge    801129 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801110:	ff 45 08             	incl   0x8(%ebp)
  801113:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801116:	0f af 45 10          	imul   0x10(%ebp),%eax
  80111a:	89 c2                	mov    %eax,%edx
  80111c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111f:	01 d0                	add    %edx,%eax
  801121:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801124:	e9 7b ff ff ff       	jmp    8010a4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801129:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80112a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112e:	74 08                	je     801138 <strtol+0x134>
		*endptr = (char *) s;
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	8b 55 08             	mov    0x8(%ebp),%edx
  801136:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801138:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80113c:	74 07                	je     801145 <strtol+0x141>
  80113e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801141:	f7 d8                	neg    %eax
  801143:	eb 03                	jmp    801148 <strtol+0x144>
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <ltostr>:

void
ltostr(long value, char *str)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801150:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801157:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80115e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801162:	79 13                	jns    801177 <ltostr+0x2d>
	{
		neg = 1;
  801164:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801171:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801174:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80117f:	99                   	cltd   
  801180:	f7 f9                	idiv   %ecx
  801182:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801185:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801188:	8d 50 01             	lea    0x1(%eax),%edx
  80118b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118e:	89 c2                	mov    %eax,%edx
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801198:	83 c2 30             	add    $0x30,%edx
  80119b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80119d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011a5:	f7 e9                	imul   %ecx
  8011a7:	c1 fa 02             	sar    $0x2,%edx
  8011aa:	89 c8                	mov    %ecx,%eax
  8011ac:	c1 f8 1f             	sar    $0x1f,%eax
  8011af:	29 c2                	sub    %eax,%edx
  8011b1:	89 d0                	mov    %edx,%eax
  8011b3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011be:	f7 e9                	imul   %ecx
  8011c0:	c1 fa 02             	sar    $0x2,%edx
  8011c3:	89 c8                	mov    %ecx,%eax
  8011c5:	c1 f8 1f             	sar    $0x1f,%eax
  8011c8:	29 c2                	sub    %eax,%edx
  8011ca:	89 d0                	mov    %edx,%eax
  8011cc:	c1 e0 02             	shl    $0x2,%eax
  8011cf:	01 d0                	add    %edx,%eax
  8011d1:	01 c0                	add    %eax,%eax
  8011d3:	29 c1                	sub    %eax,%ecx
  8011d5:	89 ca                	mov    %ecx,%edx
  8011d7:	85 d2                	test   %edx,%edx
  8011d9:	75 9c                	jne    801177 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e5:	48                   	dec    %eax
  8011e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ed:	74 3d                	je     80122c <ltostr+0xe2>
		start = 1 ;
  8011ef:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011f6:	eb 34                	jmp    80122c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801205:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	01 c2                	add    %eax,%edx
  80120d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801210:	8b 45 0c             	mov    0xc(%ebp),%eax
  801213:	01 c8                	add    %ecx,%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801219:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	01 c2                	add    %eax,%edx
  801221:	8a 45 eb             	mov    -0x15(%ebp),%al
  801224:	88 02                	mov    %al,(%edx)
		start++ ;
  801226:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801229:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80122c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801232:	7c c4                	jl     8011f8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801234:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80123f:	90                   	nop
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801248:	ff 75 08             	pushl  0x8(%ebp)
  80124b:	e8 54 fa ff ff       	call   800ca4 <strlen>
  801250:	83 c4 04             	add    $0x4,%esp
  801253:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801256:	ff 75 0c             	pushl  0xc(%ebp)
  801259:	e8 46 fa ff ff       	call   800ca4 <strlen>
  80125e:	83 c4 04             	add    $0x4,%esp
  801261:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801264:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801272:	eb 17                	jmp    80128b <strcconcat+0x49>
		final[s] = str1[s] ;
  801274:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801277:	8b 45 10             	mov    0x10(%ebp),%eax
  80127a:	01 c2                	add    %eax,%edx
  80127c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	01 c8                	add    %ecx,%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801288:	ff 45 fc             	incl   -0x4(%ebp)
  80128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801291:	7c e1                	jl     801274 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801293:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80129a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012a1:	eb 1f                	jmp    8012c2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a6:	8d 50 01             	lea    0x1(%eax),%edx
  8012a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ac:	89 c2                	mov    %eax,%edx
  8012ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b1:	01 c2                	add    %eax,%edx
  8012b3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	01 c8                	add    %ecx,%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012bf:	ff 45 f8             	incl   -0x8(%ebp)
  8012c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c8:	7c d9                	jl     8012a3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d0:	01 d0                	add    %edx,%eax
  8012d2:	c6 00 00             	movb   $0x0,(%eax)
}
  8012d5:	90                   	nop
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012db:	8b 45 14             	mov    0x14(%ebp),%eax
  8012de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e7:	8b 00                	mov    (%eax),%eax
  8012e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	01 d0                	add    %edx,%eax
  8012f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012fb:	eb 0c                	jmp    801309 <strsplit+0x31>
			*string++ = 0;
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8d 50 01             	lea    0x1(%eax),%edx
  801303:	89 55 08             	mov    %edx,0x8(%ebp)
  801306:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	84 c0                	test   %al,%al
  801310:	74 18                	je     80132a <strsplit+0x52>
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	0f be c0             	movsbl %al,%eax
  80131a:	50                   	push   %eax
  80131b:	ff 75 0c             	pushl  0xc(%ebp)
  80131e:	e8 13 fb ff ff       	call   800e36 <strchr>
  801323:	83 c4 08             	add    $0x8,%esp
  801326:	85 c0                	test   %eax,%eax
  801328:	75 d3                	jne    8012fd <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	8a 00                	mov    (%eax),%al
  80132f:	84 c0                	test   %al,%al
  801331:	74 5a                	je     80138d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801333:	8b 45 14             	mov    0x14(%ebp),%eax
  801336:	8b 00                	mov    (%eax),%eax
  801338:	83 f8 0f             	cmp    $0xf,%eax
  80133b:	75 07                	jne    801344 <strsplit+0x6c>
		{
			return 0;
  80133d:	b8 00 00 00 00       	mov    $0x0,%eax
  801342:	eb 66                	jmp    8013aa <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801344:	8b 45 14             	mov    0x14(%ebp),%eax
  801347:	8b 00                	mov    (%eax),%eax
  801349:	8d 48 01             	lea    0x1(%eax),%ecx
  80134c:	8b 55 14             	mov    0x14(%ebp),%edx
  80134f:	89 0a                	mov    %ecx,(%edx)
  801351:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	01 c2                	add    %eax,%edx
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801362:	eb 03                	jmp    801367 <strsplit+0x8f>
			string++;
  801364:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	84 c0                	test   %al,%al
  80136e:	74 8b                	je     8012fb <strsplit+0x23>
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	0f be c0             	movsbl %al,%eax
  801378:	50                   	push   %eax
  801379:	ff 75 0c             	pushl  0xc(%ebp)
  80137c:	e8 b5 fa ff ff       	call   800e36 <strchr>
  801381:	83 c4 08             	add    $0x8,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	74 dc                	je     801364 <strsplit+0x8c>
			string++;
	}
  801388:	e9 6e ff ff ff       	jmp    8012fb <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80138d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80138e:	8b 45 14             	mov    0x14(%ebp),%eax
  801391:	8b 00                	mov    (%eax),%eax
  801393:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80139a:	8b 45 10             	mov    0x10(%ebp),%eax
  80139d:	01 d0                	add    %edx,%eax
  80139f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013a5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013b2:	a1 04 40 80 00       	mov    0x804004,%eax
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	74 1f                	je     8013da <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013bb:	e8 1d 00 00 00       	call   8013dd <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013c0:	83 ec 0c             	sub    $0xc,%esp
  8013c3:	68 90 3a 80 00       	push   $0x803a90
  8013c8:	e8 55 f2 ff ff       	call   800622 <cprintf>
  8013cd:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013d0:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013d7:	00 00 00 
	}
}
  8013da:	90                   	nop
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8013e3:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013ea:	00 00 00 
  8013ed:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013f4:	00 00 00 
  8013f7:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013fe:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801401:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801408:	00 00 00 
  80140b:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801412:	00 00 00 
  801415:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80141c:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  80141f:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801426:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801429:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801433:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801438:	2d 00 10 00 00       	sub    $0x1000,%eax
  80143d:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801442:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801449:	a1 20 41 80 00       	mov    0x804120,%eax
  80144e:	c1 e0 04             	shl    $0x4,%eax
  801451:	89 c2                	mov    %eax,%edx
  801453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801456:	01 d0                	add    %edx,%eax
  801458:	48                   	dec    %eax
  801459:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80145c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80145f:	ba 00 00 00 00       	mov    $0x0,%edx
  801464:	f7 75 f0             	divl   -0x10(%ebp)
  801467:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80146a:	29 d0                	sub    %edx,%eax
  80146c:	89 c2                	mov    %eax,%edx
  80146e:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801478:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80147d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801482:	83 ec 04             	sub    $0x4,%esp
  801485:	6a 06                	push   $0x6
  801487:	52                   	push   %edx
  801488:	50                   	push   %eax
  801489:	e8 71 05 00 00       	call   8019ff <sys_allocate_chunk>
  80148e:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801491:	a1 20 41 80 00       	mov    0x804120,%eax
  801496:	83 ec 0c             	sub    $0xc,%esp
  801499:	50                   	push   %eax
  80149a:	e8 e6 0b 00 00       	call   802085 <initialize_MemBlocksList>
  80149f:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8014a2:	a1 48 41 80 00       	mov    0x804148,%eax
  8014a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8014aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014ae:	75 14                	jne    8014c4 <initialize_dyn_block_system+0xe7>
  8014b0:	83 ec 04             	sub    $0x4,%esp
  8014b3:	68 b5 3a 80 00       	push   $0x803ab5
  8014b8:	6a 2b                	push   $0x2b
  8014ba:	68 d3 3a 80 00       	push   $0x803ad3
  8014bf:	e8 b2 1b 00 00       	call   803076 <_panic>
  8014c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014c7:	8b 00                	mov    (%eax),%eax
  8014c9:	85 c0                	test   %eax,%eax
  8014cb:	74 10                	je     8014dd <initialize_dyn_block_system+0x100>
  8014cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014d0:	8b 00                	mov    (%eax),%eax
  8014d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014d5:	8b 52 04             	mov    0x4(%edx),%edx
  8014d8:	89 50 04             	mov    %edx,0x4(%eax)
  8014db:	eb 0b                	jmp    8014e8 <initialize_dyn_block_system+0x10b>
  8014dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014e0:	8b 40 04             	mov    0x4(%eax),%eax
  8014e3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014eb:	8b 40 04             	mov    0x4(%eax),%eax
  8014ee:	85 c0                	test   %eax,%eax
  8014f0:	74 0f                	je     801501 <initialize_dyn_block_system+0x124>
  8014f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014f5:	8b 40 04             	mov    0x4(%eax),%eax
  8014f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014fb:	8b 12                	mov    (%edx),%edx
  8014fd:	89 10                	mov    %edx,(%eax)
  8014ff:	eb 0a                	jmp    80150b <initialize_dyn_block_system+0x12e>
  801501:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801504:	8b 00                	mov    (%eax),%eax
  801506:	a3 48 41 80 00       	mov    %eax,0x804148
  80150b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80150e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801514:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801517:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80151e:	a1 54 41 80 00       	mov    0x804154,%eax
  801523:	48                   	dec    %eax
  801524:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  801529:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80152c:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801536:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  80153d:	83 ec 0c             	sub    $0xc,%esp
  801540:	ff 75 e4             	pushl  -0x1c(%ebp)
  801543:	e8 d2 13 00 00       	call   80291a <insert_sorted_with_merge_freeList>
  801548:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80154b:	90                   	nop
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801554:	e8 53 fe ff ff       	call   8013ac <InitializeUHeap>
	if (size == 0) return NULL ;
  801559:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80155d:	75 07                	jne    801566 <malloc+0x18>
  80155f:	b8 00 00 00 00       	mov    $0x0,%eax
  801564:	eb 61                	jmp    8015c7 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801566:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80156d:	8b 55 08             	mov    0x8(%ebp),%edx
  801570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801573:	01 d0                	add    %edx,%eax
  801575:	48                   	dec    %eax
  801576:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801579:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157c:	ba 00 00 00 00       	mov    $0x0,%edx
  801581:	f7 75 f4             	divl   -0xc(%ebp)
  801584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801587:	29 d0                	sub    %edx,%eax
  801589:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80158c:	e8 3c 08 00 00       	call   801dcd <sys_isUHeapPlacementStrategyFIRSTFIT>
  801591:	85 c0                	test   %eax,%eax
  801593:	74 2d                	je     8015c2 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801595:	83 ec 0c             	sub    $0xc,%esp
  801598:	ff 75 08             	pushl  0x8(%ebp)
  80159b:	e8 3e 0f 00 00       	call   8024de <alloc_block_FF>
  8015a0:	83 c4 10             	add    $0x10,%esp
  8015a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8015a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015aa:	74 16                	je     8015c2 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8015ac:	83 ec 0c             	sub    $0xc,%esp
  8015af:	ff 75 ec             	pushl  -0x14(%ebp)
  8015b2:	e8 48 0c 00 00       	call   8021ff <insert_sorted_allocList>
  8015b7:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8015ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015bd:	8b 40 08             	mov    0x8(%eax),%eax
  8015c0:	eb 05                	jmp    8015c7 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8015c2:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015dd:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	83 ec 08             	sub    $0x8,%esp
  8015e6:	50                   	push   %eax
  8015e7:	68 40 40 80 00       	push   $0x804040
  8015ec:	e8 71 0b 00 00       	call   802162 <find_block>
  8015f1:	83 c4 10             	add    $0x10,%esp
  8015f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  8015f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fa:	8b 50 0c             	mov    0xc(%eax),%edx
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	83 ec 08             	sub    $0x8,%esp
  801603:	52                   	push   %edx
  801604:	50                   	push   %eax
  801605:	e8 bd 03 00 00       	call   8019c7 <sys_free_user_mem>
  80160a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  80160d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801611:	75 14                	jne    801627 <free+0x5e>
  801613:	83 ec 04             	sub    $0x4,%esp
  801616:	68 b5 3a 80 00       	push   $0x803ab5
  80161b:	6a 71                	push   $0x71
  80161d:	68 d3 3a 80 00       	push   $0x803ad3
  801622:	e8 4f 1a 00 00       	call   803076 <_panic>
  801627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162a:	8b 00                	mov    (%eax),%eax
  80162c:	85 c0                	test   %eax,%eax
  80162e:	74 10                	je     801640 <free+0x77>
  801630:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801633:	8b 00                	mov    (%eax),%eax
  801635:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801638:	8b 52 04             	mov    0x4(%edx),%edx
  80163b:	89 50 04             	mov    %edx,0x4(%eax)
  80163e:	eb 0b                	jmp    80164b <free+0x82>
  801640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801643:	8b 40 04             	mov    0x4(%eax),%eax
  801646:	a3 44 40 80 00       	mov    %eax,0x804044
  80164b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164e:	8b 40 04             	mov    0x4(%eax),%eax
  801651:	85 c0                	test   %eax,%eax
  801653:	74 0f                	je     801664 <free+0x9b>
  801655:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801658:	8b 40 04             	mov    0x4(%eax),%eax
  80165b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80165e:	8b 12                	mov    (%edx),%edx
  801660:	89 10                	mov    %edx,(%eax)
  801662:	eb 0a                	jmp    80166e <free+0xa5>
  801664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801667:	8b 00                	mov    (%eax),%eax
  801669:	a3 40 40 80 00       	mov    %eax,0x804040
  80166e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801671:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801681:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801686:	48                   	dec    %eax
  801687:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  80168c:	83 ec 0c             	sub    $0xc,%esp
  80168f:	ff 75 f0             	pushl  -0x10(%ebp)
  801692:	e8 83 12 00 00       	call   80291a <insert_sorted_with_merge_freeList>
  801697:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80169a:	90                   	nop
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	83 ec 28             	sub    $0x28,%esp
  8016a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a6:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016a9:	e8 fe fc ff ff       	call   8013ac <InitializeUHeap>
	if (size == 0) return NULL ;
  8016ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016b2:	75 0a                	jne    8016be <smalloc+0x21>
  8016b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b9:	e9 86 00 00 00       	jmp    801744 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8016be:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016cb:	01 d0                	add    %edx,%eax
  8016cd:	48                   	dec    %eax
  8016ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d9:	f7 75 f4             	divl   -0xc(%ebp)
  8016dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016df:	29 d0                	sub    %edx,%eax
  8016e1:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016e4:	e8 e4 06 00 00       	call   801dcd <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	74 52                	je     80173f <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  8016ed:	83 ec 0c             	sub    $0xc,%esp
  8016f0:	ff 75 0c             	pushl  0xc(%ebp)
  8016f3:	e8 e6 0d 00 00       	call   8024de <alloc_block_FF>
  8016f8:	83 c4 10             	add    $0x10,%esp
  8016fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  8016fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801702:	75 07                	jne    80170b <smalloc+0x6e>
			return NULL ;
  801704:	b8 00 00 00 00       	mov    $0x0,%eax
  801709:	eb 39                	jmp    801744 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  80170b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170e:	8b 40 08             	mov    0x8(%eax),%eax
  801711:	89 c2                	mov    %eax,%edx
  801713:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801717:	52                   	push   %edx
  801718:	50                   	push   %eax
  801719:	ff 75 0c             	pushl  0xc(%ebp)
  80171c:	ff 75 08             	pushl  0x8(%ebp)
  80171f:	e8 2e 04 00 00       	call   801b52 <sys_createSharedObject>
  801724:	83 c4 10             	add    $0x10,%esp
  801727:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  80172a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80172e:	79 07                	jns    801737 <smalloc+0x9a>
			return (void*)NULL ;
  801730:	b8 00 00 00 00       	mov    $0x0,%eax
  801735:	eb 0d                	jmp    801744 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801737:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80173a:	8b 40 08             	mov    0x8(%eax),%eax
  80173d:	eb 05                	jmp    801744 <smalloc+0xa7>
		}
		return (void*)NULL ;
  80173f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80174c:	e8 5b fc ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801751:	83 ec 08             	sub    $0x8,%esp
  801754:	ff 75 0c             	pushl  0xc(%ebp)
  801757:	ff 75 08             	pushl  0x8(%ebp)
  80175a:	e8 1d 04 00 00       	call   801b7c <sys_getSizeOfSharedObject>
  80175f:	83 c4 10             	add    $0x10,%esp
  801762:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801765:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801769:	75 0a                	jne    801775 <sget+0x2f>
			return NULL ;
  80176b:	b8 00 00 00 00       	mov    $0x0,%eax
  801770:	e9 83 00 00 00       	jmp    8017f8 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801775:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80177c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80177f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801782:	01 d0                	add    %edx,%eax
  801784:	48                   	dec    %eax
  801785:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801788:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80178b:	ba 00 00 00 00       	mov    $0x0,%edx
  801790:	f7 75 f0             	divl   -0x10(%ebp)
  801793:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801796:	29 d0                	sub    %edx,%eax
  801798:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80179b:	e8 2d 06 00 00       	call   801dcd <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017a0:	85 c0                	test   %eax,%eax
  8017a2:	74 4f                	je     8017f3 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8017a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a7:	83 ec 0c             	sub    $0xc,%esp
  8017aa:	50                   	push   %eax
  8017ab:	e8 2e 0d 00 00       	call   8024de <alloc_block_FF>
  8017b0:	83 c4 10             	add    $0x10,%esp
  8017b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8017b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017ba:	75 07                	jne    8017c3 <sget+0x7d>
					return (void*)NULL ;
  8017bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c1:	eb 35                	jmp    8017f8 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8017c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017c6:	8b 40 08             	mov    0x8(%eax),%eax
  8017c9:	83 ec 04             	sub    $0x4,%esp
  8017cc:	50                   	push   %eax
  8017cd:	ff 75 0c             	pushl  0xc(%ebp)
  8017d0:	ff 75 08             	pushl  0x8(%ebp)
  8017d3:	e8 c1 03 00 00       	call   801b99 <sys_getSharedObject>
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  8017de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017e2:	79 07                	jns    8017eb <sget+0xa5>
				return (void*)NULL ;
  8017e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e9:	eb 0d                	jmp    8017f8 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  8017eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017ee:	8b 40 08             	mov    0x8(%eax),%eax
  8017f1:	eb 05                	jmp    8017f8 <sget+0xb2>


		}
	return (void*)NULL ;
  8017f3:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801800:	e8 a7 fb ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801805:	83 ec 04             	sub    $0x4,%esp
  801808:	68 e0 3a 80 00       	push   $0x803ae0
  80180d:	68 f9 00 00 00       	push   $0xf9
  801812:	68 d3 3a 80 00       	push   $0x803ad3
  801817:	e8 5a 18 00 00       	call   803076 <_panic>

0080181c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801822:	83 ec 04             	sub    $0x4,%esp
  801825:	68 08 3b 80 00       	push   $0x803b08
  80182a:	68 0d 01 00 00       	push   $0x10d
  80182f:	68 d3 3a 80 00       	push   $0x803ad3
  801834:	e8 3d 18 00 00       	call   803076 <_panic>

00801839 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80183f:	83 ec 04             	sub    $0x4,%esp
  801842:	68 2c 3b 80 00       	push   $0x803b2c
  801847:	68 18 01 00 00       	push   $0x118
  80184c:	68 d3 3a 80 00       	push   $0x803ad3
  801851:	e8 20 18 00 00       	call   803076 <_panic>

00801856 <shrink>:

}
void shrink(uint32 newSize)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80185c:	83 ec 04             	sub    $0x4,%esp
  80185f:	68 2c 3b 80 00       	push   $0x803b2c
  801864:	68 1d 01 00 00       	push   $0x11d
  801869:	68 d3 3a 80 00       	push   $0x803ad3
  80186e:	e8 03 18 00 00       	call   803076 <_panic>

00801873 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801879:	83 ec 04             	sub    $0x4,%esp
  80187c:	68 2c 3b 80 00       	push   $0x803b2c
  801881:	68 22 01 00 00       	push   $0x122
  801886:	68 d3 3a 80 00       	push   $0x803ad3
  80188b:	e8 e6 17 00 00       	call   803076 <_panic>

00801890 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	57                   	push   %edi
  801894:	56                   	push   %esi
  801895:	53                   	push   %ebx
  801896:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018a8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018ab:	cd 30                	int    $0x30
  8018ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018b3:	83 c4 10             	add    $0x10,%esp
  8018b6:	5b                   	pop    %ebx
  8018b7:	5e                   	pop    %esi
  8018b8:	5f                   	pop    %edi
  8018b9:	5d                   	pop    %ebp
  8018ba:	c3                   	ret    

008018bb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 04             	sub    $0x4,%esp
  8018c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018c7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	52                   	push   %edx
  8018d3:	ff 75 0c             	pushl  0xc(%ebp)
  8018d6:	50                   	push   %eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	e8 b2 ff ff ff       	call   801890 <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
}
  8018e1:	90                   	nop
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 01                	push   $0x1
  8018f3:	e8 98 ff ff ff       	call   801890 <syscall>
  8018f8:	83 c4 18             	add    $0x18,%esp
}
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801900:	8b 55 0c             	mov    0xc(%ebp),%edx
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	52                   	push   %edx
  80190d:	50                   	push   %eax
  80190e:	6a 05                	push   $0x5
  801910:	e8 7b ff ff ff       	call   801890 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	56                   	push   %esi
  80191e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80191f:	8b 75 18             	mov    0x18(%ebp),%esi
  801922:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801925:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801928:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	56                   	push   %esi
  80192f:	53                   	push   %ebx
  801930:	51                   	push   %ecx
  801931:	52                   	push   %edx
  801932:	50                   	push   %eax
  801933:	6a 06                	push   $0x6
  801935:	e8 56 ff ff ff       	call   801890 <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801940:	5b                   	pop    %ebx
  801941:	5e                   	pop    %esi
  801942:	5d                   	pop    %ebp
  801943:	c3                   	ret    

00801944 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194a:	8b 45 08             	mov    0x8(%ebp),%eax
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	52                   	push   %edx
  801954:	50                   	push   %eax
  801955:	6a 07                	push   $0x7
  801957:	e8 34 ff ff ff       	call   801890 <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	ff 75 0c             	pushl  0xc(%ebp)
  80196d:	ff 75 08             	pushl  0x8(%ebp)
  801970:	6a 08                	push   $0x8
  801972:	e8 19 ff ff ff       	call   801890 <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 09                	push   $0x9
  80198b:	e8 00 ff ff ff       	call   801890 <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 0a                	push   $0xa
  8019a4:	e8 e7 fe ff ff       	call   801890 <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 0b                	push   $0xb
  8019bd:	e8 ce fe ff ff       	call   801890 <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	ff 75 0c             	pushl  0xc(%ebp)
  8019d3:	ff 75 08             	pushl  0x8(%ebp)
  8019d6:	6a 0f                	push   $0xf
  8019d8:	e8 b3 fe ff ff       	call   801890 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
	return;
  8019e0:	90                   	nop
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	ff 75 0c             	pushl  0xc(%ebp)
  8019ef:	ff 75 08             	pushl  0x8(%ebp)
  8019f2:	6a 10                	push   $0x10
  8019f4:	e8 97 fe ff ff       	call   801890 <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fc:	90                   	nop
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	ff 75 10             	pushl  0x10(%ebp)
  801a09:	ff 75 0c             	pushl  0xc(%ebp)
  801a0c:	ff 75 08             	pushl  0x8(%ebp)
  801a0f:	6a 11                	push   $0x11
  801a11:	e8 7a fe ff ff       	call   801890 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
	return ;
  801a19:	90                   	nop
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 0c                	push   $0xc
  801a2b:	e8 60 fe ff ff       	call   801890 <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	ff 75 08             	pushl  0x8(%ebp)
  801a43:	6a 0d                	push   $0xd
  801a45:	e8 46 fe ff ff       	call   801890 <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
}
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 0e                	push   $0xe
  801a5e:	e8 2d fe ff ff       	call   801890 <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
}
  801a66:	90                   	nop
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 13                	push   $0x13
  801a78:	e8 13 fe ff ff       	call   801890 <syscall>
  801a7d:	83 c4 18             	add    $0x18,%esp
}
  801a80:	90                   	nop
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 14                	push   $0x14
  801a92:	e8 f9 fd ff ff       	call   801890 <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
}
  801a9a:	90                   	nop
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_cputc>:


void
sys_cputc(const char c)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 04             	sub    $0x4,%esp
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aa9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	50                   	push   %eax
  801ab6:	6a 15                	push   $0x15
  801ab8:	e8 d3 fd ff ff       	call   801890 <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
}
  801ac0:	90                   	nop
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 16                	push   $0x16
  801ad2:	e8 b9 fd ff ff       	call   801890 <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	90                   	nop
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	ff 75 0c             	pushl  0xc(%ebp)
  801aec:	50                   	push   %eax
  801aed:	6a 17                	push   $0x17
  801aef:	e8 9c fd ff ff       	call   801890 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801afc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	52                   	push   %edx
  801b09:	50                   	push   %eax
  801b0a:	6a 1a                	push   $0x1a
  801b0c:	e8 7f fd ff ff       	call   801890 <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	52                   	push   %edx
  801b26:	50                   	push   %eax
  801b27:	6a 18                	push   $0x18
  801b29:	e8 62 fd ff ff       	call   801890 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	90                   	nop
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	52                   	push   %edx
  801b44:	50                   	push   %eax
  801b45:	6a 19                	push   $0x19
  801b47:	e8 44 fd ff ff       	call   801890 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	90                   	nop
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 04             	sub    $0x4,%esp
  801b58:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b5e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b61:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	6a 00                	push   $0x0
  801b6a:	51                   	push   %ecx
  801b6b:	52                   	push   %edx
  801b6c:	ff 75 0c             	pushl  0xc(%ebp)
  801b6f:	50                   	push   %eax
  801b70:	6a 1b                	push   $0x1b
  801b72:	e8 19 fd ff ff       	call   801890 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	52                   	push   %edx
  801b8c:	50                   	push   %eax
  801b8d:	6a 1c                	push   $0x1c
  801b8f:	e8 fc fc ff ff       	call   801890 <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	51                   	push   %ecx
  801baa:	52                   	push   %edx
  801bab:	50                   	push   %eax
  801bac:	6a 1d                	push   $0x1d
  801bae:	e8 dd fc ff ff       	call   801890 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	52                   	push   %edx
  801bc8:	50                   	push   %eax
  801bc9:	6a 1e                	push   $0x1e
  801bcb:	e8 c0 fc ff ff       	call   801890 <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 1f                	push   $0x1f
  801be4:	e8 a7 fc ff ff       	call   801890 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	6a 00                	push   $0x0
  801bf6:	ff 75 14             	pushl  0x14(%ebp)
  801bf9:	ff 75 10             	pushl  0x10(%ebp)
  801bfc:	ff 75 0c             	pushl  0xc(%ebp)
  801bff:	50                   	push   %eax
  801c00:	6a 20                	push   $0x20
  801c02:	e8 89 fc ff ff       	call   801890 <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	50                   	push   %eax
  801c1b:	6a 21                	push   $0x21
  801c1d:	e8 6e fc ff ff       	call   801890 <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
}
  801c25:	90                   	nop
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	50                   	push   %eax
  801c37:	6a 22                	push   $0x22
  801c39:	e8 52 fc ff ff       	call   801890 <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 02                	push   $0x2
  801c52:	e8 39 fc ff ff       	call   801890 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 03                	push   $0x3
  801c6b:	e8 20 fc ff ff       	call   801890 <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 04                	push   $0x4
  801c84:	e8 07 fc ff ff       	call   801890 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_exit_env>:


void sys_exit_env(void)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 23                	push   $0x23
  801c9d:	e8 ee fb ff ff       	call   801890 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	90                   	nop
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb1:	8d 50 04             	lea    0x4(%eax),%edx
  801cb4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	52                   	push   %edx
  801cbe:	50                   	push   %eax
  801cbf:	6a 24                	push   $0x24
  801cc1:	e8 ca fb ff ff       	call   801890 <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
	return result;
  801cc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ccc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ccf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cd2:	89 01                	mov    %eax,(%ecx)
  801cd4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	c9                   	leave  
  801cdb:	c2 04 00             	ret    $0x4

00801cde <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	ff 75 10             	pushl  0x10(%ebp)
  801ce8:	ff 75 0c             	pushl  0xc(%ebp)
  801ceb:	ff 75 08             	pushl  0x8(%ebp)
  801cee:	6a 12                	push   $0x12
  801cf0:	e8 9b fb ff ff       	call   801890 <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf8:	90                   	nop
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <sys_rcr2>:
uint32 sys_rcr2()
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 25                	push   $0x25
  801d0a:	e8 81 fb ff ff       	call   801890 <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 04             	sub    $0x4,%esp
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d20:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	50                   	push   %eax
  801d2d:	6a 26                	push   $0x26
  801d2f:	e8 5c fb ff ff       	call   801890 <syscall>
  801d34:	83 c4 18             	add    $0x18,%esp
	return ;
  801d37:	90                   	nop
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <rsttst>:
void rsttst()
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 28                	push   $0x28
  801d49:	e8 42 fb ff ff       	call   801890 <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d51:	90                   	nop
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 04             	sub    $0x4,%esp
  801d5a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d5d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d60:	8b 55 18             	mov    0x18(%ebp),%edx
  801d63:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d67:	52                   	push   %edx
  801d68:	50                   	push   %eax
  801d69:	ff 75 10             	pushl  0x10(%ebp)
  801d6c:	ff 75 0c             	pushl  0xc(%ebp)
  801d6f:	ff 75 08             	pushl  0x8(%ebp)
  801d72:	6a 27                	push   $0x27
  801d74:	e8 17 fb ff ff       	call   801890 <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7c:	90                   	nop
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <chktst>:
void chktst(uint32 n)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	ff 75 08             	pushl  0x8(%ebp)
  801d8d:	6a 29                	push   $0x29
  801d8f:	e8 fc fa ff ff       	call   801890 <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
	return ;
  801d97:	90                   	nop
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <inctst>:

void inctst()
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 2a                	push   $0x2a
  801da9:	e8 e2 fa ff ff       	call   801890 <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
	return ;
  801db1:	90                   	nop
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <gettst>:
uint32 gettst()
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 2b                	push   $0x2b
  801dc3:	e8 c8 fa ff ff       	call   801890 <syscall>
  801dc8:	83 c4 18             	add    $0x18,%esp
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 2c                	push   $0x2c
  801ddf:	e8 ac fa ff ff       	call   801890 <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
  801de7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dea:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dee:	75 07                	jne    801df7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801df0:	b8 01 00 00 00       	mov    $0x1,%eax
  801df5:	eb 05                	jmp    801dfc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 2c                	push   $0x2c
  801e10:	e8 7b fa ff ff       	call   801890 <syscall>
  801e15:	83 c4 18             	add    $0x18,%esp
  801e18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e1b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e1f:	75 07                	jne    801e28 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e21:	b8 01 00 00 00       	mov    $0x1,%eax
  801e26:	eb 05                	jmp    801e2d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
  801e32:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 2c                	push   $0x2c
  801e41:	e8 4a fa ff ff       	call   801890 <syscall>
  801e46:	83 c4 18             	add    $0x18,%esp
  801e49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e4c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e50:	75 07                	jne    801e59 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e52:	b8 01 00 00 00       	mov    $0x1,%eax
  801e57:	eb 05                	jmp    801e5e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 2c                	push   $0x2c
  801e72:	e8 19 fa ff ff       	call   801890 <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
  801e7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e7d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e81:	75 07                	jne    801e8a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e83:	b8 01 00 00 00       	mov    $0x1,%eax
  801e88:	eb 05                	jmp    801e8f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	ff 75 08             	pushl  0x8(%ebp)
  801e9f:	6a 2d                	push   $0x2d
  801ea1:	e8 ea f9 ff ff       	call   801890 <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea9:	90                   	nop
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eb0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eb3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	6a 00                	push   $0x0
  801ebe:	53                   	push   %ebx
  801ebf:	51                   	push   %ecx
  801ec0:	52                   	push   %edx
  801ec1:	50                   	push   %eax
  801ec2:	6a 2e                	push   $0x2e
  801ec4:	e8 c7 f9 ff ff       	call   801890 <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
}
  801ecc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ed4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	52                   	push   %edx
  801ee1:	50                   	push   %eax
  801ee2:	6a 2f                	push   $0x2f
  801ee4:	e8 a7 f9 ff ff       	call   801890 <syscall>
  801ee9:	83 c4 18             	add    $0x18,%esp
}
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ef4:	83 ec 0c             	sub    $0xc,%esp
  801ef7:	68 3c 3b 80 00       	push   $0x803b3c
  801efc:	e8 21 e7 ff ff       	call   800622 <cprintf>
  801f01:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f04:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f0b:	83 ec 0c             	sub    $0xc,%esp
  801f0e:	68 68 3b 80 00       	push   $0x803b68
  801f13:	e8 0a e7 ff ff       	call   800622 <cprintf>
  801f18:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f1b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f1f:	a1 38 41 80 00       	mov    0x804138,%eax
  801f24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f27:	eb 56                	jmp    801f7f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f2d:	74 1c                	je     801f4b <print_mem_block_lists+0x5d>
  801f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f32:	8b 50 08             	mov    0x8(%eax),%edx
  801f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f38:	8b 48 08             	mov    0x8(%eax),%ecx
  801f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f41:	01 c8                	add    %ecx,%eax
  801f43:	39 c2                	cmp    %eax,%edx
  801f45:	73 04                	jae    801f4b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f47:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4e:	8b 50 08             	mov    0x8(%eax),%edx
  801f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f54:	8b 40 0c             	mov    0xc(%eax),%eax
  801f57:	01 c2                	add    %eax,%edx
  801f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5c:	8b 40 08             	mov    0x8(%eax),%eax
  801f5f:	83 ec 04             	sub    $0x4,%esp
  801f62:	52                   	push   %edx
  801f63:	50                   	push   %eax
  801f64:	68 7d 3b 80 00       	push   $0x803b7d
  801f69:	e8 b4 e6 ff ff       	call   800622 <cprintf>
  801f6e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f74:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f77:	a1 40 41 80 00       	mov    0x804140,%eax
  801f7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f83:	74 07                	je     801f8c <print_mem_block_lists+0x9e>
  801f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f88:	8b 00                	mov    (%eax),%eax
  801f8a:	eb 05                	jmp    801f91 <print_mem_block_lists+0xa3>
  801f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f91:	a3 40 41 80 00       	mov    %eax,0x804140
  801f96:	a1 40 41 80 00       	mov    0x804140,%eax
  801f9b:	85 c0                	test   %eax,%eax
  801f9d:	75 8a                	jne    801f29 <print_mem_block_lists+0x3b>
  801f9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa3:	75 84                	jne    801f29 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fa5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fa9:	75 10                	jne    801fbb <print_mem_block_lists+0xcd>
  801fab:	83 ec 0c             	sub    $0xc,%esp
  801fae:	68 8c 3b 80 00       	push   $0x803b8c
  801fb3:	e8 6a e6 ff ff       	call   800622 <cprintf>
  801fb8:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fbb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fc2:	83 ec 0c             	sub    $0xc,%esp
  801fc5:	68 b0 3b 80 00       	push   $0x803bb0
  801fca:	e8 53 e6 ff ff       	call   800622 <cprintf>
  801fcf:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fd2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fd6:	a1 40 40 80 00       	mov    0x804040,%eax
  801fdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fde:	eb 56                	jmp    802036 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fe0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fe4:	74 1c                	je     802002 <print_mem_block_lists+0x114>
  801fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe9:	8b 50 08             	mov    0x8(%eax),%edx
  801fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fef:	8b 48 08             	mov    0x8(%eax),%ecx
  801ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff8:	01 c8                	add    %ecx,%eax
  801ffa:	39 c2                	cmp    %eax,%edx
  801ffc:	73 04                	jae    802002 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ffe:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802005:	8b 50 08             	mov    0x8(%eax),%edx
  802008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200b:	8b 40 0c             	mov    0xc(%eax),%eax
  80200e:	01 c2                	add    %eax,%edx
  802010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802013:	8b 40 08             	mov    0x8(%eax),%eax
  802016:	83 ec 04             	sub    $0x4,%esp
  802019:	52                   	push   %edx
  80201a:	50                   	push   %eax
  80201b:	68 7d 3b 80 00       	push   $0x803b7d
  802020:	e8 fd e5 ff ff       	call   800622 <cprintf>
  802025:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80202e:	a1 48 40 80 00       	mov    0x804048,%eax
  802033:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802036:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203a:	74 07                	je     802043 <print_mem_block_lists+0x155>
  80203c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203f:	8b 00                	mov    (%eax),%eax
  802041:	eb 05                	jmp    802048 <print_mem_block_lists+0x15a>
  802043:	b8 00 00 00 00       	mov    $0x0,%eax
  802048:	a3 48 40 80 00       	mov    %eax,0x804048
  80204d:	a1 48 40 80 00       	mov    0x804048,%eax
  802052:	85 c0                	test   %eax,%eax
  802054:	75 8a                	jne    801fe0 <print_mem_block_lists+0xf2>
  802056:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205a:	75 84                	jne    801fe0 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80205c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802060:	75 10                	jne    802072 <print_mem_block_lists+0x184>
  802062:	83 ec 0c             	sub    $0xc,%esp
  802065:	68 c8 3b 80 00       	push   $0x803bc8
  80206a:	e8 b3 e5 ff ff       	call   800622 <cprintf>
  80206f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802072:	83 ec 0c             	sub    $0xc,%esp
  802075:	68 3c 3b 80 00       	push   $0x803b3c
  80207a:	e8 a3 e5 ff ff       	call   800622 <cprintf>
  80207f:	83 c4 10             	add    $0x10,%esp

}
  802082:	90                   	nop
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80208b:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802092:	00 00 00 
  802095:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80209c:	00 00 00 
  80209f:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020a6:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8020a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020b0:	e9 9e 00 00 00       	jmp    802153 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8020b5:	a1 50 40 80 00       	mov    0x804050,%eax
  8020ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bd:	c1 e2 04             	shl    $0x4,%edx
  8020c0:	01 d0                	add    %edx,%eax
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	75 14                	jne    8020da <initialize_MemBlocksList+0x55>
  8020c6:	83 ec 04             	sub    $0x4,%esp
  8020c9:	68 f0 3b 80 00       	push   $0x803bf0
  8020ce:	6a 43                	push   $0x43
  8020d0:	68 13 3c 80 00       	push   $0x803c13
  8020d5:	e8 9c 0f 00 00       	call   803076 <_panic>
  8020da:	a1 50 40 80 00       	mov    0x804050,%eax
  8020df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e2:	c1 e2 04             	shl    $0x4,%edx
  8020e5:	01 d0                	add    %edx,%eax
  8020e7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020ed:	89 10                	mov    %edx,(%eax)
  8020ef:	8b 00                	mov    (%eax),%eax
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	74 18                	je     80210d <initialize_MemBlocksList+0x88>
  8020f5:	a1 48 41 80 00       	mov    0x804148,%eax
  8020fa:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802100:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802103:	c1 e1 04             	shl    $0x4,%ecx
  802106:	01 ca                	add    %ecx,%edx
  802108:	89 50 04             	mov    %edx,0x4(%eax)
  80210b:	eb 12                	jmp    80211f <initialize_MemBlocksList+0x9a>
  80210d:	a1 50 40 80 00       	mov    0x804050,%eax
  802112:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802115:	c1 e2 04             	shl    $0x4,%edx
  802118:	01 d0                	add    %edx,%eax
  80211a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80211f:	a1 50 40 80 00       	mov    0x804050,%eax
  802124:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802127:	c1 e2 04             	shl    $0x4,%edx
  80212a:	01 d0                	add    %edx,%eax
  80212c:	a3 48 41 80 00       	mov    %eax,0x804148
  802131:	a1 50 40 80 00       	mov    0x804050,%eax
  802136:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802139:	c1 e2 04             	shl    $0x4,%edx
  80213c:	01 d0                	add    %edx,%eax
  80213e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802145:	a1 54 41 80 00       	mov    0x804154,%eax
  80214a:	40                   	inc    %eax
  80214b:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802150:	ff 45 f4             	incl   -0xc(%ebp)
  802153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802156:	3b 45 08             	cmp    0x8(%ebp),%eax
  802159:	0f 82 56 ff ff ff    	jb     8020b5 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  80215f:	90                   	nop
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802168:	a1 38 41 80 00       	mov    0x804138,%eax
  80216d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802170:	eb 18                	jmp    80218a <find_block+0x28>
	{
		if (ele->sva==va)
  802172:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802175:	8b 40 08             	mov    0x8(%eax),%eax
  802178:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80217b:	75 05                	jne    802182 <find_block+0x20>
			return ele;
  80217d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802180:	eb 7b                	jmp    8021fd <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802182:	a1 40 41 80 00       	mov    0x804140,%eax
  802187:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80218a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80218e:	74 07                	je     802197 <find_block+0x35>
  802190:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802193:	8b 00                	mov    (%eax),%eax
  802195:	eb 05                	jmp    80219c <find_block+0x3a>
  802197:	b8 00 00 00 00       	mov    $0x0,%eax
  80219c:	a3 40 41 80 00       	mov    %eax,0x804140
  8021a1:	a1 40 41 80 00       	mov    0x804140,%eax
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	75 c8                	jne    802172 <find_block+0x10>
  8021aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021ae:	75 c2                	jne    802172 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8021b0:	a1 40 40 80 00       	mov    0x804040,%eax
  8021b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021b8:	eb 18                	jmp    8021d2 <find_block+0x70>
	{
		if (ele->sva==va)
  8021ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021bd:	8b 40 08             	mov    0x8(%eax),%eax
  8021c0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021c3:	75 05                	jne    8021ca <find_block+0x68>
					return ele;
  8021c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c8:	eb 33                	jmp    8021fd <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8021ca:	a1 48 40 80 00       	mov    0x804048,%eax
  8021cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021d6:	74 07                	je     8021df <find_block+0x7d>
  8021d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021db:	8b 00                	mov    (%eax),%eax
  8021dd:	eb 05                	jmp    8021e4 <find_block+0x82>
  8021df:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e4:	a3 48 40 80 00       	mov    %eax,0x804048
  8021e9:	a1 48 40 80 00       	mov    0x804048,%eax
  8021ee:	85 c0                	test   %eax,%eax
  8021f0:	75 c8                	jne    8021ba <find_block+0x58>
  8021f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021f6:	75 c2                	jne    8021ba <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  8021f8:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8021fd:	c9                   	leave  
  8021fe:	c3                   	ret    

008021ff <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021ff:	55                   	push   %ebp
  802200:	89 e5                	mov    %esp,%ebp
  802202:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802205:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80220a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  80220d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802211:	75 62                	jne    802275 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802213:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802217:	75 14                	jne    80222d <insert_sorted_allocList+0x2e>
  802219:	83 ec 04             	sub    $0x4,%esp
  80221c:	68 f0 3b 80 00       	push   $0x803bf0
  802221:	6a 69                	push   $0x69
  802223:	68 13 3c 80 00       	push   $0x803c13
  802228:	e8 49 0e 00 00       	call   803076 <_panic>
  80222d:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	89 10                	mov    %edx,(%eax)
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	8b 00                	mov    (%eax),%eax
  80223d:	85 c0                	test   %eax,%eax
  80223f:	74 0d                	je     80224e <insert_sorted_allocList+0x4f>
  802241:	a1 40 40 80 00       	mov    0x804040,%eax
  802246:	8b 55 08             	mov    0x8(%ebp),%edx
  802249:	89 50 04             	mov    %edx,0x4(%eax)
  80224c:	eb 08                	jmp    802256 <insert_sorted_allocList+0x57>
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	a3 44 40 80 00       	mov    %eax,0x804044
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	a3 40 40 80 00       	mov    %eax,0x804040
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802268:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80226d:	40                   	inc    %eax
  80226e:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802273:	eb 72                	jmp    8022e7 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802275:	a1 40 40 80 00       	mov    0x804040,%eax
  80227a:	8b 50 08             	mov    0x8(%eax),%edx
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	8b 40 08             	mov    0x8(%eax),%eax
  802283:	39 c2                	cmp    %eax,%edx
  802285:	76 60                	jbe    8022e7 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802287:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80228b:	75 14                	jne    8022a1 <insert_sorted_allocList+0xa2>
  80228d:	83 ec 04             	sub    $0x4,%esp
  802290:	68 f0 3b 80 00       	push   $0x803bf0
  802295:	6a 6d                	push   $0x6d
  802297:	68 13 3c 80 00       	push   $0x803c13
  80229c:	e8 d5 0d 00 00       	call   803076 <_panic>
  8022a1:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022aa:	89 10                	mov    %edx,(%eax)
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	8b 00                	mov    (%eax),%eax
  8022b1:	85 c0                	test   %eax,%eax
  8022b3:	74 0d                	je     8022c2 <insert_sorted_allocList+0xc3>
  8022b5:	a1 40 40 80 00       	mov    0x804040,%eax
  8022ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8022bd:	89 50 04             	mov    %edx,0x4(%eax)
  8022c0:	eb 08                	jmp    8022ca <insert_sorted_allocList+0xcb>
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	a3 44 40 80 00       	mov    %eax,0x804044
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	a3 40 40 80 00       	mov    %eax,0x804040
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022dc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022e1:	40                   	inc    %eax
  8022e2:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8022e7:	a1 40 40 80 00       	mov    0x804040,%eax
  8022ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ef:	e9 b9 01 00 00       	jmp    8024ad <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	8b 50 08             	mov    0x8(%eax),%edx
  8022fa:	a1 40 40 80 00       	mov    0x804040,%eax
  8022ff:	8b 40 08             	mov    0x8(%eax),%eax
  802302:	39 c2                	cmp    %eax,%edx
  802304:	76 7c                	jbe    802382 <insert_sorted_allocList+0x183>
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	8b 50 08             	mov    0x8(%eax),%edx
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	8b 40 08             	mov    0x8(%eax),%eax
  802312:	39 c2                	cmp    %eax,%edx
  802314:	73 6c                	jae    802382 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802316:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231a:	74 06                	je     802322 <insert_sorted_allocList+0x123>
  80231c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802320:	75 14                	jne    802336 <insert_sorted_allocList+0x137>
  802322:	83 ec 04             	sub    $0x4,%esp
  802325:	68 2c 3c 80 00       	push   $0x803c2c
  80232a:	6a 75                	push   $0x75
  80232c:	68 13 3c 80 00       	push   $0x803c13
  802331:	e8 40 0d 00 00       	call   803076 <_panic>
  802336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802339:	8b 50 04             	mov    0x4(%eax),%edx
  80233c:	8b 45 08             	mov    0x8(%ebp),%eax
  80233f:	89 50 04             	mov    %edx,0x4(%eax)
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802348:	89 10                	mov    %edx,(%eax)
  80234a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234d:	8b 40 04             	mov    0x4(%eax),%eax
  802350:	85 c0                	test   %eax,%eax
  802352:	74 0d                	je     802361 <insert_sorted_allocList+0x162>
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	8b 40 04             	mov    0x4(%eax),%eax
  80235a:	8b 55 08             	mov    0x8(%ebp),%edx
  80235d:	89 10                	mov    %edx,(%eax)
  80235f:	eb 08                	jmp    802369 <insert_sorted_allocList+0x16a>
  802361:	8b 45 08             	mov    0x8(%ebp),%eax
  802364:	a3 40 40 80 00       	mov    %eax,0x804040
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	8b 55 08             	mov    0x8(%ebp),%edx
  80236f:	89 50 04             	mov    %edx,0x4(%eax)
  802372:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802377:	40                   	inc    %eax
  802378:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  80237d:	e9 59 01 00 00       	jmp    8024db <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	8b 50 08             	mov    0x8(%eax),%edx
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	8b 40 08             	mov    0x8(%eax),%eax
  80238e:	39 c2                	cmp    %eax,%edx
  802390:	0f 86 98 00 00 00    	jbe    80242e <insert_sorted_allocList+0x22f>
  802396:	8b 45 08             	mov    0x8(%ebp),%eax
  802399:	8b 50 08             	mov    0x8(%eax),%edx
  80239c:	a1 44 40 80 00       	mov    0x804044,%eax
  8023a1:	8b 40 08             	mov    0x8(%eax),%eax
  8023a4:	39 c2                	cmp    %eax,%edx
  8023a6:	0f 83 82 00 00 00    	jae    80242e <insert_sorted_allocList+0x22f>
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	8b 50 08             	mov    0x8(%eax),%edx
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	8b 00                	mov    (%eax),%eax
  8023b7:	8b 40 08             	mov    0x8(%eax),%eax
  8023ba:	39 c2                	cmp    %eax,%edx
  8023bc:	73 70                	jae    80242e <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8023be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c2:	74 06                	je     8023ca <insert_sorted_allocList+0x1cb>
  8023c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023c8:	75 14                	jne    8023de <insert_sorted_allocList+0x1df>
  8023ca:	83 ec 04             	sub    $0x4,%esp
  8023cd:	68 64 3c 80 00       	push   $0x803c64
  8023d2:	6a 7c                	push   $0x7c
  8023d4:	68 13 3c 80 00       	push   $0x803c13
  8023d9:	e8 98 0c 00 00       	call   803076 <_panic>
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	8b 10                	mov    (%eax),%edx
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	89 10                	mov    %edx,(%eax)
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	8b 00                	mov    (%eax),%eax
  8023ed:	85 c0                	test   %eax,%eax
  8023ef:	74 0b                	je     8023fc <insert_sorted_allocList+0x1fd>
  8023f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f4:	8b 00                	mov    (%eax),%eax
  8023f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f9:	89 50 04             	mov    %edx,0x4(%eax)
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802402:	89 10                	mov    %edx,(%eax)
  802404:	8b 45 08             	mov    0x8(%ebp),%eax
  802407:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80240a:	89 50 04             	mov    %edx,0x4(%eax)
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
  802410:	8b 00                	mov    (%eax),%eax
  802412:	85 c0                	test   %eax,%eax
  802414:	75 08                	jne    80241e <insert_sorted_allocList+0x21f>
  802416:	8b 45 08             	mov    0x8(%ebp),%eax
  802419:	a3 44 40 80 00       	mov    %eax,0x804044
  80241e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802423:	40                   	inc    %eax
  802424:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802429:	e9 ad 00 00 00       	jmp    8024db <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80242e:	8b 45 08             	mov    0x8(%ebp),%eax
  802431:	8b 50 08             	mov    0x8(%eax),%edx
  802434:	a1 44 40 80 00       	mov    0x804044,%eax
  802439:	8b 40 08             	mov    0x8(%eax),%eax
  80243c:	39 c2                	cmp    %eax,%edx
  80243e:	76 65                	jbe    8024a5 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802440:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802444:	75 17                	jne    80245d <insert_sorted_allocList+0x25e>
  802446:	83 ec 04             	sub    $0x4,%esp
  802449:	68 98 3c 80 00       	push   $0x803c98
  80244e:	68 80 00 00 00       	push   $0x80
  802453:	68 13 3c 80 00       	push   $0x803c13
  802458:	e8 19 0c 00 00       	call   803076 <_panic>
  80245d:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	89 50 04             	mov    %edx,0x4(%eax)
  802469:	8b 45 08             	mov    0x8(%ebp),%eax
  80246c:	8b 40 04             	mov    0x4(%eax),%eax
  80246f:	85 c0                	test   %eax,%eax
  802471:	74 0c                	je     80247f <insert_sorted_allocList+0x280>
  802473:	a1 44 40 80 00       	mov    0x804044,%eax
  802478:	8b 55 08             	mov    0x8(%ebp),%edx
  80247b:	89 10                	mov    %edx,(%eax)
  80247d:	eb 08                	jmp    802487 <insert_sorted_allocList+0x288>
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	a3 40 40 80 00       	mov    %eax,0x804040
  802487:	8b 45 08             	mov    0x8(%ebp),%eax
  80248a:	a3 44 40 80 00       	mov    %eax,0x804044
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802498:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80249d:	40                   	inc    %eax
  80249e:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8024a3:	eb 36                	jmp    8024db <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8024a5:	a1 48 40 80 00       	mov    0x804048,%eax
  8024aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b1:	74 07                	je     8024ba <insert_sorted_allocList+0x2bb>
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	8b 00                	mov    (%eax),%eax
  8024b8:	eb 05                	jmp    8024bf <insert_sorted_allocList+0x2c0>
  8024ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bf:	a3 48 40 80 00       	mov    %eax,0x804048
  8024c4:	a1 48 40 80 00       	mov    0x804048,%eax
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	0f 85 23 fe ff ff    	jne    8022f4 <insert_sorted_allocList+0xf5>
  8024d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d5:	0f 85 19 fe ff ff    	jne    8022f4 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  8024db:	90                   	nop
  8024dc:	c9                   	leave  
  8024dd:	c3                   	ret    

008024de <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
  8024e1:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8024e4:	a1 38 41 80 00       	mov    0x804138,%eax
  8024e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ec:	e9 7c 01 00 00       	jmp    80266d <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024fa:	0f 85 90 00 00 00    	jne    802590 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802506:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250a:	75 17                	jne    802523 <alloc_block_FF+0x45>
  80250c:	83 ec 04             	sub    $0x4,%esp
  80250f:	68 bb 3c 80 00       	push   $0x803cbb
  802514:	68 ba 00 00 00       	push   $0xba
  802519:	68 13 3c 80 00       	push   $0x803c13
  80251e:	e8 53 0b 00 00       	call   803076 <_panic>
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	8b 00                	mov    (%eax),%eax
  802528:	85 c0                	test   %eax,%eax
  80252a:	74 10                	je     80253c <alloc_block_FF+0x5e>
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	8b 00                	mov    (%eax),%eax
  802531:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802534:	8b 52 04             	mov    0x4(%edx),%edx
  802537:	89 50 04             	mov    %edx,0x4(%eax)
  80253a:	eb 0b                	jmp    802547 <alloc_block_FF+0x69>
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 40 04             	mov    0x4(%eax),%eax
  802542:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	8b 40 04             	mov    0x4(%eax),%eax
  80254d:	85 c0                	test   %eax,%eax
  80254f:	74 0f                	je     802560 <alloc_block_FF+0x82>
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 40 04             	mov    0x4(%eax),%eax
  802557:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255a:	8b 12                	mov    (%edx),%edx
  80255c:	89 10                	mov    %edx,(%eax)
  80255e:	eb 0a                	jmp    80256a <alloc_block_FF+0x8c>
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	8b 00                	mov    (%eax),%eax
  802565:	a3 38 41 80 00       	mov    %eax,0x804138
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257d:	a1 44 41 80 00       	mov    0x804144,%eax
  802582:	48                   	dec    %eax
  802583:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  802588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258b:	e9 10 01 00 00       	jmp    8026a0 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	8b 40 0c             	mov    0xc(%eax),%eax
  802596:	3b 45 08             	cmp    0x8(%ebp),%eax
  802599:	0f 86 c6 00 00 00    	jbe    802665 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  80259f:	a1 48 41 80 00       	mov    0x804148,%eax
  8025a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8025a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ab:	75 17                	jne    8025c4 <alloc_block_FF+0xe6>
  8025ad:	83 ec 04             	sub    $0x4,%esp
  8025b0:	68 bb 3c 80 00       	push   $0x803cbb
  8025b5:	68 c2 00 00 00       	push   $0xc2
  8025ba:	68 13 3c 80 00       	push   $0x803c13
  8025bf:	e8 b2 0a 00 00       	call   803076 <_panic>
  8025c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c7:	8b 00                	mov    (%eax),%eax
  8025c9:	85 c0                	test   %eax,%eax
  8025cb:	74 10                	je     8025dd <alloc_block_FF+0xff>
  8025cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d0:	8b 00                	mov    (%eax),%eax
  8025d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025d5:	8b 52 04             	mov    0x4(%edx),%edx
  8025d8:	89 50 04             	mov    %edx,0x4(%eax)
  8025db:	eb 0b                	jmp    8025e8 <alloc_block_FF+0x10a>
  8025dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e0:	8b 40 04             	mov    0x4(%eax),%eax
  8025e3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025eb:	8b 40 04             	mov    0x4(%eax),%eax
  8025ee:	85 c0                	test   %eax,%eax
  8025f0:	74 0f                	je     802601 <alloc_block_FF+0x123>
  8025f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f5:	8b 40 04             	mov    0x4(%eax),%eax
  8025f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025fb:	8b 12                	mov    (%edx),%edx
  8025fd:	89 10                	mov    %edx,(%eax)
  8025ff:	eb 0a                	jmp    80260b <alloc_block_FF+0x12d>
  802601:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802604:	8b 00                	mov    (%eax),%eax
  802606:	a3 48 41 80 00       	mov    %eax,0x804148
  80260b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802617:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80261e:	a1 54 41 80 00       	mov    0x804154,%eax
  802623:	48                   	dec    %eax
  802624:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	8b 50 08             	mov    0x8(%eax),%edx
  80262f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802632:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802635:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802638:	8b 55 08             	mov    0x8(%ebp),%edx
  80263b:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  80263e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802641:	8b 40 0c             	mov    0xc(%eax),%eax
  802644:	2b 45 08             	sub    0x8(%ebp),%eax
  802647:	89 c2                	mov    %eax,%edx
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	8b 50 08             	mov    0x8(%eax),%edx
  802655:	8b 45 08             	mov    0x8(%ebp),%eax
  802658:	01 c2                	add    %eax,%edx
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802663:	eb 3b                	jmp    8026a0 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802665:	a1 40 41 80 00       	mov    0x804140,%eax
  80266a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802671:	74 07                	je     80267a <alloc_block_FF+0x19c>
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	8b 00                	mov    (%eax),%eax
  802678:	eb 05                	jmp    80267f <alloc_block_FF+0x1a1>
  80267a:	b8 00 00 00 00       	mov    $0x0,%eax
  80267f:	a3 40 41 80 00       	mov    %eax,0x804140
  802684:	a1 40 41 80 00       	mov    0x804140,%eax
  802689:	85 c0                	test   %eax,%eax
  80268b:	0f 85 60 fe ff ff    	jne    8024f1 <alloc_block_FF+0x13>
  802691:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802695:	0f 85 56 fe ff ff    	jne    8024f1 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  80269b:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a0:	c9                   	leave  
  8026a1:	c3                   	ret    

008026a2 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8026a2:	55                   	push   %ebp
  8026a3:	89 e5                	mov    %esp,%ebp
  8026a5:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8026a8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8026af:	a1 38 41 80 00       	mov    0x804138,%eax
  8026b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b7:	eb 3a                	jmp    8026f3 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c2:	72 27                	jb     8026eb <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8026c4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8026c8:	75 0b                	jne    8026d5 <alloc_block_BF+0x33>
					best_size= element->size;
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026d3:	eb 16                	jmp    8026eb <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 50 0c             	mov    0xc(%eax),%edx
  8026db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026de:	39 c2                	cmp    %eax,%edx
  8026e0:	77 09                	ja     8026eb <alloc_block_BF+0x49>
					best_size=element->size;
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e8:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8026eb:	a1 40 41 80 00       	mov    0x804140,%eax
  8026f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f7:	74 07                	je     802700 <alloc_block_BF+0x5e>
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 00                	mov    (%eax),%eax
  8026fe:	eb 05                	jmp    802705 <alloc_block_BF+0x63>
  802700:	b8 00 00 00 00       	mov    $0x0,%eax
  802705:	a3 40 41 80 00       	mov    %eax,0x804140
  80270a:	a1 40 41 80 00       	mov    0x804140,%eax
  80270f:	85 c0                	test   %eax,%eax
  802711:	75 a6                	jne    8026b9 <alloc_block_BF+0x17>
  802713:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802717:	75 a0                	jne    8026b9 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802719:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80271d:	0f 84 d3 01 00 00    	je     8028f6 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802723:	a1 38 41 80 00       	mov    0x804138,%eax
  802728:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80272b:	e9 98 01 00 00       	jmp    8028c8 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802733:	3b 45 08             	cmp    0x8(%ebp),%eax
  802736:	0f 86 da 00 00 00    	jbe    802816 <alloc_block_BF+0x174>
  80273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273f:	8b 50 0c             	mov    0xc(%eax),%edx
  802742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802745:	39 c2                	cmp    %eax,%edx
  802747:	0f 85 c9 00 00 00    	jne    802816 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  80274d:	a1 48 41 80 00       	mov    0x804148,%eax
  802752:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802755:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802759:	75 17                	jne    802772 <alloc_block_BF+0xd0>
  80275b:	83 ec 04             	sub    $0x4,%esp
  80275e:	68 bb 3c 80 00       	push   $0x803cbb
  802763:	68 ea 00 00 00       	push   $0xea
  802768:	68 13 3c 80 00       	push   $0x803c13
  80276d:	e8 04 09 00 00       	call   803076 <_panic>
  802772:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802775:	8b 00                	mov    (%eax),%eax
  802777:	85 c0                	test   %eax,%eax
  802779:	74 10                	je     80278b <alloc_block_BF+0xe9>
  80277b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277e:	8b 00                	mov    (%eax),%eax
  802780:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802783:	8b 52 04             	mov    0x4(%edx),%edx
  802786:	89 50 04             	mov    %edx,0x4(%eax)
  802789:	eb 0b                	jmp    802796 <alloc_block_BF+0xf4>
  80278b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278e:	8b 40 04             	mov    0x4(%eax),%eax
  802791:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802796:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802799:	8b 40 04             	mov    0x4(%eax),%eax
  80279c:	85 c0                	test   %eax,%eax
  80279e:	74 0f                	je     8027af <alloc_block_BF+0x10d>
  8027a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a3:	8b 40 04             	mov    0x4(%eax),%eax
  8027a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027a9:	8b 12                	mov    (%edx),%edx
  8027ab:	89 10                	mov    %edx,(%eax)
  8027ad:	eb 0a                	jmp    8027b9 <alloc_block_BF+0x117>
  8027af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b2:	8b 00                	mov    (%eax),%eax
  8027b4:	a3 48 41 80 00       	mov    %eax,0x804148
  8027b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027cc:	a1 54 41 80 00       	mov    0x804154,%eax
  8027d1:	48                   	dec    %eax
  8027d2:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 50 08             	mov    0x8(%eax),%edx
  8027dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e0:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  8027e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e9:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f2:	2b 45 08             	sub    0x8(%ebp),%eax
  8027f5:	89 c2                	mov    %eax,%edx
  8027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fa:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	8b 50 08             	mov    0x8(%eax),%edx
  802803:	8b 45 08             	mov    0x8(%ebp),%eax
  802806:	01 c2                	add    %eax,%edx
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  80280e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802811:	e9 e5 00 00 00       	jmp    8028fb <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	8b 50 0c             	mov    0xc(%eax),%edx
  80281c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281f:	39 c2                	cmp    %eax,%edx
  802821:	0f 85 99 00 00 00    	jne    8028c0 <alloc_block_BF+0x21e>
  802827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80282d:	0f 85 8d 00 00 00    	jne    8028c0 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802839:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283d:	75 17                	jne    802856 <alloc_block_BF+0x1b4>
  80283f:	83 ec 04             	sub    $0x4,%esp
  802842:	68 bb 3c 80 00       	push   $0x803cbb
  802847:	68 f7 00 00 00       	push   $0xf7
  80284c:	68 13 3c 80 00       	push   $0x803c13
  802851:	e8 20 08 00 00       	call   803076 <_panic>
  802856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802859:	8b 00                	mov    (%eax),%eax
  80285b:	85 c0                	test   %eax,%eax
  80285d:	74 10                	je     80286f <alloc_block_BF+0x1cd>
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	8b 00                	mov    (%eax),%eax
  802864:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802867:	8b 52 04             	mov    0x4(%edx),%edx
  80286a:	89 50 04             	mov    %edx,0x4(%eax)
  80286d:	eb 0b                	jmp    80287a <alloc_block_BF+0x1d8>
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	8b 40 04             	mov    0x4(%eax),%eax
  802875:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	8b 40 04             	mov    0x4(%eax),%eax
  802880:	85 c0                	test   %eax,%eax
  802882:	74 0f                	je     802893 <alloc_block_BF+0x1f1>
  802884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802887:	8b 40 04             	mov    0x4(%eax),%eax
  80288a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288d:	8b 12                	mov    (%edx),%edx
  80288f:	89 10                	mov    %edx,(%eax)
  802891:	eb 0a                	jmp    80289d <alloc_block_BF+0x1fb>
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	8b 00                	mov    (%eax),%eax
  802898:	a3 38 41 80 00       	mov    %eax,0x804138
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b0:	a1 44 41 80 00       	mov    0x804144,%eax
  8028b5:	48                   	dec    %eax
  8028b6:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  8028bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028be:	eb 3b                	jmp    8028fb <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8028c0:	a1 40 41 80 00       	mov    0x804140,%eax
  8028c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028cc:	74 07                	je     8028d5 <alloc_block_BF+0x233>
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	8b 00                	mov    (%eax),%eax
  8028d3:	eb 05                	jmp    8028da <alloc_block_BF+0x238>
  8028d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028da:	a3 40 41 80 00       	mov    %eax,0x804140
  8028df:	a1 40 41 80 00       	mov    0x804140,%eax
  8028e4:	85 c0                	test   %eax,%eax
  8028e6:	0f 85 44 fe ff ff    	jne    802730 <alloc_block_BF+0x8e>
  8028ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f0:	0f 85 3a fe ff ff    	jne    802730 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  8028f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028fb:	c9                   	leave  
  8028fc:	c3                   	ret    

008028fd <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028fd:	55                   	push   %ebp
  8028fe:	89 e5                	mov    %esp,%ebp
  802900:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802903:	83 ec 04             	sub    $0x4,%esp
  802906:	68 dc 3c 80 00       	push   $0x803cdc
  80290b:	68 04 01 00 00       	push   $0x104
  802910:	68 13 3c 80 00       	push   $0x803c13
  802915:	e8 5c 07 00 00       	call   803076 <_panic>

0080291a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  80291a:	55                   	push   %ebp
  80291b:	89 e5                	mov    %esp,%ebp
  80291d:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802920:	a1 38 41 80 00       	mov    0x804138,%eax
  802925:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802928:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80292d:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802930:	a1 38 41 80 00       	mov    0x804138,%eax
  802935:	85 c0                	test   %eax,%eax
  802937:	75 68                	jne    8029a1 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802939:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80293d:	75 17                	jne    802956 <insert_sorted_with_merge_freeList+0x3c>
  80293f:	83 ec 04             	sub    $0x4,%esp
  802942:	68 f0 3b 80 00       	push   $0x803bf0
  802947:	68 14 01 00 00       	push   $0x114
  80294c:	68 13 3c 80 00       	push   $0x803c13
  802951:	e8 20 07 00 00       	call   803076 <_panic>
  802956:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	89 10                	mov    %edx,(%eax)
  802961:	8b 45 08             	mov    0x8(%ebp),%eax
  802964:	8b 00                	mov    (%eax),%eax
  802966:	85 c0                	test   %eax,%eax
  802968:	74 0d                	je     802977 <insert_sorted_with_merge_freeList+0x5d>
  80296a:	a1 38 41 80 00       	mov    0x804138,%eax
  80296f:	8b 55 08             	mov    0x8(%ebp),%edx
  802972:	89 50 04             	mov    %edx,0x4(%eax)
  802975:	eb 08                	jmp    80297f <insert_sorted_with_merge_freeList+0x65>
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	a3 38 41 80 00       	mov    %eax,0x804138
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802991:	a1 44 41 80 00       	mov    0x804144,%eax
  802996:	40                   	inc    %eax
  802997:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  80299c:	e9 d2 06 00 00       	jmp    803073 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8029a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a4:	8b 50 08             	mov    0x8(%eax),%edx
  8029a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029aa:	8b 40 08             	mov    0x8(%eax),%eax
  8029ad:	39 c2                	cmp    %eax,%edx
  8029af:	0f 83 22 01 00 00    	jae    802ad7 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8029b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b8:	8b 50 08             	mov    0x8(%eax),%edx
  8029bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029be:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c1:	01 c2                	add    %eax,%edx
  8029c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c6:	8b 40 08             	mov    0x8(%eax),%eax
  8029c9:	39 c2                	cmp    %eax,%edx
  8029cb:	0f 85 9e 00 00 00    	jne    802a6f <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  8029d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d4:	8b 50 08             	mov    0x8(%eax),%edx
  8029d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029da:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  8029dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e0:	8b 50 0c             	mov    0xc(%eax),%edx
  8029e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e9:	01 c2                	add    %eax,%edx
  8029eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ee:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	8b 50 08             	mov    0x8(%eax),%edx
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a0b:	75 17                	jne    802a24 <insert_sorted_with_merge_freeList+0x10a>
  802a0d:	83 ec 04             	sub    $0x4,%esp
  802a10:	68 f0 3b 80 00       	push   $0x803bf0
  802a15:	68 21 01 00 00       	push   $0x121
  802a1a:	68 13 3c 80 00       	push   $0x803c13
  802a1f:	e8 52 06 00 00       	call   803076 <_panic>
  802a24:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	89 10                	mov    %edx,(%eax)
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	8b 00                	mov    (%eax),%eax
  802a34:	85 c0                	test   %eax,%eax
  802a36:	74 0d                	je     802a45 <insert_sorted_with_merge_freeList+0x12b>
  802a38:	a1 48 41 80 00       	mov    0x804148,%eax
  802a3d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a40:	89 50 04             	mov    %edx,0x4(%eax)
  802a43:	eb 08                	jmp    802a4d <insert_sorted_with_merge_freeList+0x133>
  802a45:	8b 45 08             	mov    0x8(%ebp),%eax
  802a48:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a50:	a3 48 41 80 00       	mov    %eax,0x804148
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5f:	a1 54 41 80 00       	mov    0x804154,%eax
  802a64:	40                   	inc    %eax
  802a65:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802a6a:	e9 04 06 00 00       	jmp    803073 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802a6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a73:	75 17                	jne    802a8c <insert_sorted_with_merge_freeList+0x172>
  802a75:	83 ec 04             	sub    $0x4,%esp
  802a78:	68 f0 3b 80 00       	push   $0x803bf0
  802a7d:	68 26 01 00 00       	push   $0x126
  802a82:	68 13 3c 80 00       	push   $0x803c13
  802a87:	e8 ea 05 00 00       	call   803076 <_panic>
  802a8c:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a92:	8b 45 08             	mov    0x8(%ebp),%eax
  802a95:	89 10                	mov    %edx,(%eax)
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	8b 00                	mov    (%eax),%eax
  802a9c:	85 c0                	test   %eax,%eax
  802a9e:	74 0d                	je     802aad <insert_sorted_with_merge_freeList+0x193>
  802aa0:	a1 38 41 80 00       	mov    0x804138,%eax
  802aa5:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa8:	89 50 04             	mov    %edx,0x4(%eax)
  802aab:	eb 08                	jmp    802ab5 <insert_sorted_with_merge_freeList+0x19b>
  802aad:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab8:	a3 38 41 80 00       	mov    %eax,0x804138
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac7:	a1 44 41 80 00       	mov    0x804144,%eax
  802acc:	40                   	inc    %eax
  802acd:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802ad2:	e9 9c 05 00 00       	jmp    803073 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	8b 50 08             	mov    0x8(%eax),%edx
  802add:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae0:	8b 40 08             	mov    0x8(%eax),%eax
  802ae3:	39 c2                	cmp    %eax,%edx
  802ae5:	0f 86 16 01 00 00    	jbe    802c01 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aee:	8b 50 08             	mov    0x8(%eax),%edx
  802af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af4:	8b 40 0c             	mov    0xc(%eax),%eax
  802af7:	01 c2                	add    %eax,%edx
  802af9:	8b 45 08             	mov    0x8(%ebp),%eax
  802afc:	8b 40 08             	mov    0x8(%eax),%eax
  802aff:	39 c2                	cmp    %eax,%edx
  802b01:	0f 85 92 00 00 00    	jne    802b99 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802b07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0a:	8b 50 0c             	mov    0xc(%eax),%edx
  802b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b10:	8b 40 0c             	mov    0xc(%eax),%eax
  802b13:	01 c2                	add    %eax,%edx
  802b15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b18:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	8b 50 08             	mov    0x8(%eax),%edx
  802b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2e:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802b31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b35:	75 17                	jne    802b4e <insert_sorted_with_merge_freeList+0x234>
  802b37:	83 ec 04             	sub    $0x4,%esp
  802b3a:	68 f0 3b 80 00       	push   $0x803bf0
  802b3f:	68 31 01 00 00       	push   $0x131
  802b44:	68 13 3c 80 00       	push   $0x803c13
  802b49:	e8 28 05 00 00       	call   803076 <_panic>
  802b4e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b54:	8b 45 08             	mov    0x8(%ebp),%eax
  802b57:	89 10                	mov    %edx,(%eax)
  802b59:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5c:	8b 00                	mov    (%eax),%eax
  802b5e:	85 c0                	test   %eax,%eax
  802b60:	74 0d                	je     802b6f <insert_sorted_with_merge_freeList+0x255>
  802b62:	a1 48 41 80 00       	mov    0x804148,%eax
  802b67:	8b 55 08             	mov    0x8(%ebp),%edx
  802b6a:	89 50 04             	mov    %edx,0x4(%eax)
  802b6d:	eb 08                	jmp    802b77 <insert_sorted_with_merge_freeList+0x25d>
  802b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b72:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	a3 48 41 80 00       	mov    %eax,0x804148
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b89:	a1 54 41 80 00       	mov    0x804154,%eax
  802b8e:	40                   	inc    %eax
  802b8f:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802b94:	e9 da 04 00 00       	jmp    803073 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802b99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b9d:	75 17                	jne    802bb6 <insert_sorted_with_merge_freeList+0x29c>
  802b9f:	83 ec 04             	sub    $0x4,%esp
  802ba2:	68 98 3c 80 00       	push   $0x803c98
  802ba7:	68 37 01 00 00       	push   $0x137
  802bac:	68 13 3c 80 00       	push   $0x803c13
  802bb1:	e8 c0 04 00 00       	call   803076 <_panic>
  802bb6:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	89 50 04             	mov    %edx,0x4(%eax)
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	8b 40 04             	mov    0x4(%eax),%eax
  802bc8:	85 c0                	test   %eax,%eax
  802bca:	74 0c                	je     802bd8 <insert_sorted_with_merge_freeList+0x2be>
  802bcc:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd4:	89 10                	mov    %edx,(%eax)
  802bd6:	eb 08                	jmp    802be0 <insert_sorted_with_merge_freeList+0x2c6>
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	a3 38 41 80 00       	mov    %eax,0x804138
  802be0:	8b 45 08             	mov    0x8(%ebp),%eax
  802be3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802be8:	8b 45 08             	mov    0x8(%ebp),%eax
  802beb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf1:	a1 44 41 80 00       	mov    0x804144,%eax
  802bf6:	40                   	inc    %eax
  802bf7:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802bfc:	e9 72 04 00 00       	jmp    803073 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802c01:	a1 38 41 80 00       	mov    0x804138,%eax
  802c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c09:	e9 35 04 00 00       	jmp    803043 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	8b 00                	mov    (%eax),%eax
  802c13:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	8b 50 08             	mov    0x8(%eax),%edx
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	8b 40 08             	mov    0x8(%eax),%eax
  802c22:	39 c2                	cmp    %eax,%edx
  802c24:	0f 86 11 04 00 00    	jbe    80303b <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2d:	8b 50 08             	mov    0x8(%eax),%edx
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	8b 40 0c             	mov    0xc(%eax),%eax
  802c36:	01 c2                	add    %eax,%edx
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	8b 40 08             	mov    0x8(%eax),%eax
  802c3e:	39 c2                	cmp    %eax,%edx
  802c40:	0f 83 8b 00 00 00    	jae    802cd1 <insert_sorted_with_merge_freeList+0x3b7>
  802c46:	8b 45 08             	mov    0x8(%ebp),%eax
  802c49:	8b 50 08             	mov    0x8(%eax),%edx
  802c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c52:	01 c2                	add    %eax,%edx
  802c54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c57:	8b 40 08             	mov    0x8(%eax),%eax
  802c5a:	39 c2                	cmp    %eax,%edx
  802c5c:	73 73                	jae    802cd1 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802c5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c62:	74 06                	je     802c6a <insert_sorted_with_merge_freeList+0x350>
  802c64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c68:	75 17                	jne    802c81 <insert_sorted_with_merge_freeList+0x367>
  802c6a:	83 ec 04             	sub    $0x4,%esp
  802c6d:	68 64 3c 80 00       	push   $0x803c64
  802c72:	68 48 01 00 00       	push   $0x148
  802c77:	68 13 3c 80 00       	push   $0x803c13
  802c7c:	e8 f5 03 00 00       	call   803076 <_panic>
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 10                	mov    (%eax),%edx
  802c86:	8b 45 08             	mov    0x8(%ebp),%eax
  802c89:	89 10                	mov    %edx,(%eax)
  802c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8e:	8b 00                	mov    (%eax),%eax
  802c90:	85 c0                	test   %eax,%eax
  802c92:	74 0b                	je     802c9f <insert_sorted_with_merge_freeList+0x385>
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 00                	mov    (%eax),%eax
  802c99:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9c:	89 50 04             	mov    %edx,0x4(%eax)
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca5:	89 10                	mov    %edx,(%eax)
  802ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  802caa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cad:	89 50 04             	mov    %edx,0x4(%eax)
  802cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb3:	8b 00                	mov    (%eax),%eax
  802cb5:	85 c0                	test   %eax,%eax
  802cb7:	75 08                	jne    802cc1 <insert_sorted_with_merge_freeList+0x3a7>
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cc1:	a1 44 41 80 00       	mov    0x804144,%eax
  802cc6:	40                   	inc    %eax
  802cc7:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802ccc:	e9 a2 03 00 00       	jmp    803073 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	8b 50 08             	mov    0x8(%eax),%edx
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdd:	01 c2                	add    %eax,%edx
  802cdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce2:	8b 40 08             	mov    0x8(%eax),%eax
  802ce5:	39 c2                	cmp    %eax,%edx
  802ce7:	0f 83 ae 00 00 00    	jae    802d9b <insert_sorted_with_merge_freeList+0x481>
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	8b 50 08             	mov    0x8(%eax),%edx
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 48 08             	mov    0x8(%eax),%ecx
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	8b 40 0c             	mov    0xc(%eax),%eax
  802cff:	01 c8                	add    %ecx,%eax
  802d01:	39 c2                	cmp    %eax,%edx
  802d03:	0f 85 92 00 00 00    	jne    802d9b <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	8b 50 0c             	mov    0xc(%eax),%edx
  802d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d12:	8b 40 0c             	mov    0xc(%eax),%eax
  802d15:	01 c2                	add    %eax,%edx
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d27:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2a:	8b 50 08             	mov    0x8(%eax),%edx
  802d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d30:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d37:	75 17                	jne    802d50 <insert_sorted_with_merge_freeList+0x436>
  802d39:	83 ec 04             	sub    $0x4,%esp
  802d3c:	68 f0 3b 80 00       	push   $0x803bf0
  802d41:	68 51 01 00 00       	push   $0x151
  802d46:	68 13 3c 80 00       	push   $0x803c13
  802d4b:	e8 26 03 00 00       	call   803076 <_panic>
  802d50:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d56:	8b 45 08             	mov    0x8(%ebp),%eax
  802d59:	89 10                	mov    %edx,(%eax)
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	8b 00                	mov    (%eax),%eax
  802d60:	85 c0                	test   %eax,%eax
  802d62:	74 0d                	je     802d71 <insert_sorted_with_merge_freeList+0x457>
  802d64:	a1 48 41 80 00       	mov    0x804148,%eax
  802d69:	8b 55 08             	mov    0x8(%ebp),%edx
  802d6c:	89 50 04             	mov    %edx,0x4(%eax)
  802d6f:	eb 08                	jmp    802d79 <insert_sorted_with_merge_freeList+0x45f>
  802d71:	8b 45 08             	mov    0x8(%ebp),%eax
  802d74:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	a3 48 41 80 00       	mov    %eax,0x804148
  802d81:	8b 45 08             	mov    0x8(%ebp),%eax
  802d84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8b:	a1 54 41 80 00       	mov    0x804154,%eax
  802d90:	40                   	inc    %eax
  802d91:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802d96:	e9 d8 02 00 00       	jmp    803073 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	8b 50 08             	mov    0x8(%eax),%edx
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	8b 40 0c             	mov    0xc(%eax),%eax
  802da7:	01 c2                	add    %eax,%edx
  802da9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dac:	8b 40 08             	mov    0x8(%eax),%eax
  802daf:	39 c2                	cmp    %eax,%edx
  802db1:	0f 85 ba 00 00 00    	jne    802e71 <insert_sorted_with_merge_freeList+0x557>
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	8b 50 08             	mov    0x8(%eax),%edx
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	8b 48 08             	mov    0x8(%eax),%ecx
  802dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc6:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc9:	01 c8                	add    %ecx,%eax
  802dcb:	39 c2                	cmp    %eax,%edx
  802dcd:	0f 86 9e 00 00 00    	jbe    802e71 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802dd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd6:	8b 50 0c             	mov    0xc(%eax),%edx
  802dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddf:	01 c2                	add    %eax,%edx
  802de1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de4:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802de7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dea:	8b 50 08             	mov    0x8(%eax),%edx
  802ded:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df0:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802e00:	8b 50 08             	mov    0x8(%eax),%edx
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802e09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e0d:	75 17                	jne    802e26 <insert_sorted_with_merge_freeList+0x50c>
  802e0f:	83 ec 04             	sub    $0x4,%esp
  802e12:	68 f0 3b 80 00       	push   $0x803bf0
  802e17:	68 5b 01 00 00       	push   $0x15b
  802e1c:	68 13 3c 80 00       	push   $0x803c13
  802e21:	e8 50 02 00 00       	call   803076 <_panic>
  802e26:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2f:	89 10                	mov    %edx,(%eax)
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	8b 00                	mov    (%eax),%eax
  802e36:	85 c0                	test   %eax,%eax
  802e38:	74 0d                	je     802e47 <insert_sorted_with_merge_freeList+0x52d>
  802e3a:	a1 48 41 80 00       	mov    0x804148,%eax
  802e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e42:	89 50 04             	mov    %edx,0x4(%eax)
  802e45:	eb 08                	jmp    802e4f <insert_sorted_with_merge_freeList+0x535>
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e52:	a3 48 41 80 00       	mov    %eax,0x804148
  802e57:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e61:	a1 54 41 80 00       	mov    0x804154,%eax
  802e66:	40                   	inc    %eax
  802e67:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802e6c:	e9 02 02 00 00       	jmp    803073 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	8b 50 08             	mov    0x8(%eax),%edx
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7d:	01 c2                	add    %eax,%edx
  802e7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e82:	8b 40 08             	mov    0x8(%eax),%eax
  802e85:	39 c2                	cmp    %eax,%edx
  802e87:	0f 85 ae 01 00 00    	jne    80303b <insert_sorted_with_merge_freeList+0x721>
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	8b 50 08             	mov    0x8(%eax),%edx
  802e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e96:	8b 48 08             	mov    0x8(%eax),%ecx
  802e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9f:	01 c8                	add    %ecx,%eax
  802ea1:	39 c2                	cmp    %eax,%edx
  802ea3:	0f 85 92 01 00 00    	jne    80303b <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eac:	8b 50 0c             	mov    0xc(%eax),%edx
  802eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb5:	01 c2                	add    %eax,%edx
  802eb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eba:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebd:	01 c2                	add    %eax,%edx
  802ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec2:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed2:	8b 50 08             	mov    0x8(%eax),%edx
  802ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed8:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802edb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ede:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ee5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee8:	8b 50 08             	mov    0x8(%eax),%edx
  802eeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eee:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802ef1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ef5:	75 17                	jne    802f0e <insert_sorted_with_merge_freeList+0x5f4>
  802ef7:	83 ec 04             	sub    $0x4,%esp
  802efa:	68 bb 3c 80 00       	push   $0x803cbb
  802eff:	68 63 01 00 00       	push   $0x163
  802f04:	68 13 3c 80 00       	push   $0x803c13
  802f09:	e8 68 01 00 00       	call   803076 <_panic>
  802f0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f11:	8b 00                	mov    (%eax),%eax
  802f13:	85 c0                	test   %eax,%eax
  802f15:	74 10                	je     802f27 <insert_sorted_with_merge_freeList+0x60d>
  802f17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1a:	8b 00                	mov    (%eax),%eax
  802f1c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f1f:	8b 52 04             	mov    0x4(%edx),%edx
  802f22:	89 50 04             	mov    %edx,0x4(%eax)
  802f25:	eb 0b                	jmp    802f32 <insert_sorted_with_merge_freeList+0x618>
  802f27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2a:	8b 40 04             	mov    0x4(%eax),%eax
  802f2d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f35:	8b 40 04             	mov    0x4(%eax),%eax
  802f38:	85 c0                	test   %eax,%eax
  802f3a:	74 0f                	je     802f4b <insert_sorted_with_merge_freeList+0x631>
  802f3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3f:	8b 40 04             	mov    0x4(%eax),%eax
  802f42:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f45:	8b 12                	mov    (%edx),%edx
  802f47:	89 10                	mov    %edx,(%eax)
  802f49:	eb 0a                	jmp    802f55 <insert_sorted_with_merge_freeList+0x63b>
  802f4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4e:	8b 00                	mov    (%eax),%eax
  802f50:	a3 38 41 80 00       	mov    %eax,0x804138
  802f55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f68:	a1 44 41 80 00       	mov    0x804144,%eax
  802f6d:	48                   	dec    %eax
  802f6e:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802f73:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f77:	75 17                	jne    802f90 <insert_sorted_with_merge_freeList+0x676>
  802f79:	83 ec 04             	sub    $0x4,%esp
  802f7c:	68 f0 3b 80 00       	push   $0x803bf0
  802f81:	68 64 01 00 00       	push   $0x164
  802f86:	68 13 3c 80 00       	push   $0x803c13
  802f8b:	e8 e6 00 00 00       	call   803076 <_panic>
  802f90:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f99:	89 10                	mov    %edx,(%eax)
  802f9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9e:	8b 00                	mov    (%eax),%eax
  802fa0:	85 c0                	test   %eax,%eax
  802fa2:	74 0d                	je     802fb1 <insert_sorted_with_merge_freeList+0x697>
  802fa4:	a1 48 41 80 00       	mov    0x804148,%eax
  802fa9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fac:	89 50 04             	mov    %edx,0x4(%eax)
  802faf:	eb 08                	jmp    802fb9 <insert_sorted_with_merge_freeList+0x69f>
  802fb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbc:	a3 48 41 80 00       	mov    %eax,0x804148
  802fc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fcb:	a1 54 41 80 00       	mov    0x804154,%eax
  802fd0:	40                   	inc    %eax
  802fd1:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802fd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fda:	75 17                	jne    802ff3 <insert_sorted_with_merge_freeList+0x6d9>
  802fdc:	83 ec 04             	sub    $0x4,%esp
  802fdf:	68 f0 3b 80 00       	push   $0x803bf0
  802fe4:	68 65 01 00 00       	push   $0x165
  802fe9:	68 13 3c 80 00       	push   $0x803c13
  802fee:	e8 83 00 00 00       	call   803076 <_panic>
  802ff3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	89 10                	mov    %edx,(%eax)
  802ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  803001:	8b 00                	mov    (%eax),%eax
  803003:	85 c0                	test   %eax,%eax
  803005:	74 0d                	je     803014 <insert_sorted_with_merge_freeList+0x6fa>
  803007:	a1 48 41 80 00       	mov    0x804148,%eax
  80300c:	8b 55 08             	mov    0x8(%ebp),%edx
  80300f:	89 50 04             	mov    %edx,0x4(%eax)
  803012:	eb 08                	jmp    80301c <insert_sorted_with_merge_freeList+0x702>
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80301c:	8b 45 08             	mov    0x8(%ebp),%eax
  80301f:	a3 48 41 80 00       	mov    %eax,0x804148
  803024:	8b 45 08             	mov    0x8(%ebp),%eax
  803027:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302e:	a1 54 41 80 00       	mov    0x804154,%eax
  803033:	40                   	inc    %eax
  803034:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  803039:	eb 38                	jmp    803073 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  80303b:	a1 40 41 80 00       	mov    0x804140,%eax
  803040:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803043:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803047:	74 07                	je     803050 <insert_sorted_with_merge_freeList+0x736>
  803049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304c:	8b 00                	mov    (%eax),%eax
  80304e:	eb 05                	jmp    803055 <insert_sorted_with_merge_freeList+0x73b>
  803050:	b8 00 00 00 00       	mov    $0x0,%eax
  803055:	a3 40 41 80 00       	mov    %eax,0x804140
  80305a:	a1 40 41 80 00       	mov    0x804140,%eax
  80305f:	85 c0                	test   %eax,%eax
  803061:	0f 85 a7 fb ff ff    	jne    802c0e <insert_sorted_with_merge_freeList+0x2f4>
  803067:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80306b:	0f 85 9d fb ff ff    	jne    802c0e <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  803071:	eb 00                	jmp    803073 <insert_sorted_with_merge_freeList+0x759>
  803073:	90                   	nop
  803074:	c9                   	leave  
  803075:	c3                   	ret    

00803076 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803076:	55                   	push   %ebp
  803077:	89 e5                	mov    %esp,%ebp
  803079:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80307c:	8d 45 10             	lea    0x10(%ebp),%eax
  80307f:	83 c0 04             	add    $0x4,%eax
  803082:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803085:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80308a:	85 c0                	test   %eax,%eax
  80308c:	74 16                	je     8030a4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80308e:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803093:	83 ec 08             	sub    $0x8,%esp
  803096:	50                   	push   %eax
  803097:	68 0c 3d 80 00       	push   $0x803d0c
  80309c:	e8 81 d5 ff ff       	call   800622 <cprintf>
  8030a1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8030a4:	a1 00 40 80 00       	mov    0x804000,%eax
  8030a9:	ff 75 0c             	pushl  0xc(%ebp)
  8030ac:	ff 75 08             	pushl  0x8(%ebp)
  8030af:	50                   	push   %eax
  8030b0:	68 11 3d 80 00       	push   $0x803d11
  8030b5:	e8 68 d5 ff ff       	call   800622 <cprintf>
  8030ba:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8030bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8030c0:	83 ec 08             	sub    $0x8,%esp
  8030c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8030c6:	50                   	push   %eax
  8030c7:	e8 eb d4 ff ff       	call   8005b7 <vcprintf>
  8030cc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8030cf:	83 ec 08             	sub    $0x8,%esp
  8030d2:	6a 00                	push   $0x0
  8030d4:	68 2d 3d 80 00       	push   $0x803d2d
  8030d9:	e8 d9 d4 ff ff       	call   8005b7 <vcprintf>
  8030de:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8030e1:	e8 5a d4 ff ff       	call   800540 <exit>

	// should not return here
	while (1) ;
  8030e6:	eb fe                	jmp    8030e6 <_panic+0x70>

008030e8 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8030e8:	55                   	push   %ebp
  8030e9:	89 e5                	mov    %esp,%ebp
  8030eb:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8030ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8030f3:	8b 50 74             	mov    0x74(%eax),%edx
  8030f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f9:	39 c2                	cmp    %eax,%edx
  8030fb:	74 14                	je     803111 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8030fd:	83 ec 04             	sub    $0x4,%esp
  803100:	68 30 3d 80 00       	push   $0x803d30
  803105:	6a 26                	push   $0x26
  803107:	68 7c 3d 80 00       	push   $0x803d7c
  80310c:	e8 65 ff ff ff       	call   803076 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803111:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803118:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80311f:	e9 c2 00 00 00       	jmp    8031e6 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803127:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	01 d0                	add    %edx,%eax
  803133:	8b 00                	mov    (%eax),%eax
  803135:	85 c0                	test   %eax,%eax
  803137:	75 08                	jne    803141 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803139:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80313c:	e9 a2 00 00 00       	jmp    8031e3 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803141:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803148:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80314f:	eb 69                	jmp    8031ba <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803151:	a1 20 40 80 00       	mov    0x804020,%eax
  803156:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80315c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80315f:	89 d0                	mov    %edx,%eax
  803161:	01 c0                	add    %eax,%eax
  803163:	01 d0                	add    %edx,%eax
  803165:	c1 e0 03             	shl    $0x3,%eax
  803168:	01 c8                	add    %ecx,%eax
  80316a:	8a 40 04             	mov    0x4(%eax),%al
  80316d:	84 c0                	test   %al,%al
  80316f:	75 46                	jne    8031b7 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803171:	a1 20 40 80 00       	mov    0x804020,%eax
  803176:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80317c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80317f:	89 d0                	mov    %edx,%eax
  803181:	01 c0                	add    %eax,%eax
  803183:	01 d0                	add    %edx,%eax
  803185:	c1 e0 03             	shl    $0x3,%eax
  803188:	01 c8                	add    %ecx,%eax
  80318a:	8b 00                	mov    (%eax),%eax
  80318c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80318f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803192:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803197:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	01 c8                	add    %ecx,%eax
  8031a8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8031aa:	39 c2                	cmp    %eax,%edx
  8031ac:	75 09                	jne    8031b7 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8031ae:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8031b5:	eb 12                	jmp    8031c9 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8031b7:	ff 45 e8             	incl   -0x18(%ebp)
  8031ba:	a1 20 40 80 00       	mov    0x804020,%eax
  8031bf:	8b 50 74             	mov    0x74(%eax),%edx
  8031c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c5:	39 c2                	cmp    %eax,%edx
  8031c7:	77 88                	ja     803151 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8031c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031cd:	75 14                	jne    8031e3 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8031cf:	83 ec 04             	sub    $0x4,%esp
  8031d2:	68 88 3d 80 00       	push   $0x803d88
  8031d7:	6a 3a                	push   $0x3a
  8031d9:	68 7c 3d 80 00       	push   $0x803d7c
  8031de:	e8 93 fe ff ff       	call   803076 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8031e3:	ff 45 f0             	incl   -0x10(%ebp)
  8031e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8031ec:	0f 8c 32 ff ff ff    	jl     803124 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8031f2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8031f9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803200:	eb 26                	jmp    803228 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803202:	a1 20 40 80 00       	mov    0x804020,%eax
  803207:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80320d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803210:	89 d0                	mov    %edx,%eax
  803212:	01 c0                	add    %eax,%eax
  803214:	01 d0                	add    %edx,%eax
  803216:	c1 e0 03             	shl    $0x3,%eax
  803219:	01 c8                	add    %ecx,%eax
  80321b:	8a 40 04             	mov    0x4(%eax),%al
  80321e:	3c 01                	cmp    $0x1,%al
  803220:	75 03                	jne    803225 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803222:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803225:	ff 45 e0             	incl   -0x20(%ebp)
  803228:	a1 20 40 80 00       	mov    0x804020,%eax
  80322d:	8b 50 74             	mov    0x74(%eax),%edx
  803230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803233:	39 c2                	cmp    %eax,%edx
  803235:	77 cb                	ja     803202 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80323d:	74 14                	je     803253 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80323f:	83 ec 04             	sub    $0x4,%esp
  803242:	68 dc 3d 80 00       	push   $0x803ddc
  803247:	6a 44                	push   $0x44
  803249:	68 7c 3d 80 00       	push   $0x803d7c
  80324e:	e8 23 fe ff ff       	call   803076 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803253:	90                   	nop
  803254:	c9                   	leave  
  803255:	c3                   	ret    
  803256:	66 90                	xchg   %ax,%ax

00803258 <__udivdi3>:
  803258:	55                   	push   %ebp
  803259:	57                   	push   %edi
  80325a:	56                   	push   %esi
  80325b:	53                   	push   %ebx
  80325c:	83 ec 1c             	sub    $0x1c,%esp
  80325f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803263:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803267:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80326b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80326f:	89 ca                	mov    %ecx,%edx
  803271:	89 f8                	mov    %edi,%eax
  803273:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803277:	85 f6                	test   %esi,%esi
  803279:	75 2d                	jne    8032a8 <__udivdi3+0x50>
  80327b:	39 cf                	cmp    %ecx,%edi
  80327d:	77 65                	ja     8032e4 <__udivdi3+0x8c>
  80327f:	89 fd                	mov    %edi,%ebp
  803281:	85 ff                	test   %edi,%edi
  803283:	75 0b                	jne    803290 <__udivdi3+0x38>
  803285:	b8 01 00 00 00       	mov    $0x1,%eax
  80328a:	31 d2                	xor    %edx,%edx
  80328c:	f7 f7                	div    %edi
  80328e:	89 c5                	mov    %eax,%ebp
  803290:	31 d2                	xor    %edx,%edx
  803292:	89 c8                	mov    %ecx,%eax
  803294:	f7 f5                	div    %ebp
  803296:	89 c1                	mov    %eax,%ecx
  803298:	89 d8                	mov    %ebx,%eax
  80329a:	f7 f5                	div    %ebp
  80329c:	89 cf                	mov    %ecx,%edi
  80329e:	89 fa                	mov    %edi,%edx
  8032a0:	83 c4 1c             	add    $0x1c,%esp
  8032a3:	5b                   	pop    %ebx
  8032a4:	5e                   	pop    %esi
  8032a5:	5f                   	pop    %edi
  8032a6:	5d                   	pop    %ebp
  8032a7:	c3                   	ret    
  8032a8:	39 ce                	cmp    %ecx,%esi
  8032aa:	77 28                	ja     8032d4 <__udivdi3+0x7c>
  8032ac:	0f bd fe             	bsr    %esi,%edi
  8032af:	83 f7 1f             	xor    $0x1f,%edi
  8032b2:	75 40                	jne    8032f4 <__udivdi3+0x9c>
  8032b4:	39 ce                	cmp    %ecx,%esi
  8032b6:	72 0a                	jb     8032c2 <__udivdi3+0x6a>
  8032b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032bc:	0f 87 9e 00 00 00    	ja     803360 <__udivdi3+0x108>
  8032c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8032c7:	89 fa                	mov    %edi,%edx
  8032c9:	83 c4 1c             	add    $0x1c,%esp
  8032cc:	5b                   	pop    %ebx
  8032cd:	5e                   	pop    %esi
  8032ce:	5f                   	pop    %edi
  8032cf:	5d                   	pop    %ebp
  8032d0:	c3                   	ret    
  8032d1:	8d 76 00             	lea    0x0(%esi),%esi
  8032d4:	31 ff                	xor    %edi,%edi
  8032d6:	31 c0                	xor    %eax,%eax
  8032d8:	89 fa                	mov    %edi,%edx
  8032da:	83 c4 1c             	add    $0x1c,%esp
  8032dd:	5b                   	pop    %ebx
  8032de:	5e                   	pop    %esi
  8032df:	5f                   	pop    %edi
  8032e0:	5d                   	pop    %ebp
  8032e1:	c3                   	ret    
  8032e2:	66 90                	xchg   %ax,%ax
  8032e4:	89 d8                	mov    %ebx,%eax
  8032e6:	f7 f7                	div    %edi
  8032e8:	31 ff                	xor    %edi,%edi
  8032ea:	89 fa                	mov    %edi,%edx
  8032ec:	83 c4 1c             	add    $0x1c,%esp
  8032ef:	5b                   	pop    %ebx
  8032f0:	5e                   	pop    %esi
  8032f1:	5f                   	pop    %edi
  8032f2:	5d                   	pop    %ebp
  8032f3:	c3                   	ret    
  8032f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8032f9:	89 eb                	mov    %ebp,%ebx
  8032fb:	29 fb                	sub    %edi,%ebx
  8032fd:	89 f9                	mov    %edi,%ecx
  8032ff:	d3 e6                	shl    %cl,%esi
  803301:	89 c5                	mov    %eax,%ebp
  803303:	88 d9                	mov    %bl,%cl
  803305:	d3 ed                	shr    %cl,%ebp
  803307:	89 e9                	mov    %ebp,%ecx
  803309:	09 f1                	or     %esi,%ecx
  80330b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80330f:	89 f9                	mov    %edi,%ecx
  803311:	d3 e0                	shl    %cl,%eax
  803313:	89 c5                	mov    %eax,%ebp
  803315:	89 d6                	mov    %edx,%esi
  803317:	88 d9                	mov    %bl,%cl
  803319:	d3 ee                	shr    %cl,%esi
  80331b:	89 f9                	mov    %edi,%ecx
  80331d:	d3 e2                	shl    %cl,%edx
  80331f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803323:	88 d9                	mov    %bl,%cl
  803325:	d3 e8                	shr    %cl,%eax
  803327:	09 c2                	or     %eax,%edx
  803329:	89 d0                	mov    %edx,%eax
  80332b:	89 f2                	mov    %esi,%edx
  80332d:	f7 74 24 0c          	divl   0xc(%esp)
  803331:	89 d6                	mov    %edx,%esi
  803333:	89 c3                	mov    %eax,%ebx
  803335:	f7 e5                	mul    %ebp
  803337:	39 d6                	cmp    %edx,%esi
  803339:	72 19                	jb     803354 <__udivdi3+0xfc>
  80333b:	74 0b                	je     803348 <__udivdi3+0xf0>
  80333d:	89 d8                	mov    %ebx,%eax
  80333f:	31 ff                	xor    %edi,%edi
  803341:	e9 58 ff ff ff       	jmp    80329e <__udivdi3+0x46>
  803346:	66 90                	xchg   %ax,%ax
  803348:	8b 54 24 08          	mov    0x8(%esp),%edx
  80334c:	89 f9                	mov    %edi,%ecx
  80334e:	d3 e2                	shl    %cl,%edx
  803350:	39 c2                	cmp    %eax,%edx
  803352:	73 e9                	jae    80333d <__udivdi3+0xe5>
  803354:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803357:	31 ff                	xor    %edi,%edi
  803359:	e9 40 ff ff ff       	jmp    80329e <__udivdi3+0x46>
  80335e:	66 90                	xchg   %ax,%ax
  803360:	31 c0                	xor    %eax,%eax
  803362:	e9 37 ff ff ff       	jmp    80329e <__udivdi3+0x46>
  803367:	90                   	nop

00803368 <__umoddi3>:
  803368:	55                   	push   %ebp
  803369:	57                   	push   %edi
  80336a:	56                   	push   %esi
  80336b:	53                   	push   %ebx
  80336c:	83 ec 1c             	sub    $0x1c,%esp
  80336f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803373:	8b 74 24 34          	mov    0x34(%esp),%esi
  803377:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80337b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80337f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803383:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803387:	89 f3                	mov    %esi,%ebx
  803389:	89 fa                	mov    %edi,%edx
  80338b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80338f:	89 34 24             	mov    %esi,(%esp)
  803392:	85 c0                	test   %eax,%eax
  803394:	75 1a                	jne    8033b0 <__umoddi3+0x48>
  803396:	39 f7                	cmp    %esi,%edi
  803398:	0f 86 a2 00 00 00    	jbe    803440 <__umoddi3+0xd8>
  80339e:	89 c8                	mov    %ecx,%eax
  8033a0:	89 f2                	mov    %esi,%edx
  8033a2:	f7 f7                	div    %edi
  8033a4:	89 d0                	mov    %edx,%eax
  8033a6:	31 d2                	xor    %edx,%edx
  8033a8:	83 c4 1c             	add    $0x1c,%esp
  8033ab:	5b                   	pop    %ebx
  8033ac:	5e                   	pop    %esi
  8033ad:	5f                   	pop    %edi
  8033ae:	5d                   	pop    %ebp
  8033af:	c3                   	ret    
  8033b0:	39 f0                	cmp    %esi,%eax
  8033b2:	0f 87 ac 00 00 00    	ja     803464 <__umoddi3+0xfc>
  8033b8:	0f bd e8             	bsr    %eax,%ebp
  8033bb:	83 f5 1f             	xor    $0x1f,%ebp
  8033be:	0f 84 ac 00 00 00    	je     803470 <__umoddi3+0x108>
  8033c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8033c9:	29 ef                	sub    %ebp,%edi
  8033cb:	89 fe                	mov    %edi,%esi
  8033cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033d1:	89 e9                	mov    %ebp,%ecx
  8033d3:	d3 e0                	shl    %cl,%eax
  8033d5:	89 d7                	mov    %edx,%edi
  8033d7:	89 f1                	mov    %esi,%ecx
  8033d9:	d3 ef                	shr    %cl,%edi
  8033db:	09 c7                	or     %eax,%edi
  8033dd:	89 e9                	mov    %ebp,%ecx
  8033df:	d3 e2                	shl    %cl,%edx
  8033e1:	89 14 24             	mov    %edx,(%esp)
  8033e4:	89 d8                	mov    %ebx,%eax
  8033e6:	d3 e0                	shl    %cl,%eax
  8033e8:	89 c2                	mov    %eax,%edx
  8033ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033ee:	d3 e0                	shl    %cl,%eax
  8033f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033f8:	89 f1                	mov    %esi,%ecx
  8033fa:	d3 e8                	shr    %cl,%eax
  8033fc:	09 d0                	or     %edx,%eax
  8033fe:	d3 eb                	shr    %cl,%ebx
  803400:	89 da                	mov    %ebx,%edx
  803402:	f7 f7                	div    %edi
  803404:	89 d3                	mov    %edx,%ebx
  803406:	f7 24 24             	mull   (%esp)
  803409:	89 c6                	mov    %eax,%esi
  80340b:	89 d1                	mov    %edx,%ecx
  80340d:	39 d3                	cmp    %edx,%ebx
  80340f:	0f 82 87 00 00 00    	jb     80349c <__umoddi3+0x134>
  803415:	0f 84 91 00 00 00    	je     8034ac <__umoddi3+0x144>
  80341b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80341f:	29 f2                	sub    %esi,%edx
  803421:	19 cb                	sbb    %ecx,%ebx
  803423:	89 d8                	mov    %ebx,%eax
  803425:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803429:	d3 e0                	shl    %cl,%eax
  80342b:	89 e9                	mov    %ebp,%ecx
  80342d:	d3 ea                	shr    %cl,%edx
  80342f:	09 d0                	or     %edx,%eax
  803431:	89 e9                	mov    %ebp,%ecx
  803433:	d3 eb                	shr    %cl,%ebx
  803435:	89 da                	mov    %ebx,%edx
  803437:	83 c4 1c             	add    $0x1c,%esp
  80343a:	5b                   	pop    %ebx
  80343b:	5e                   	pop    %esi
  80343c:	5f                   	pop    %edi
  80343d:	5d                   	pop    %ebp
  80343e:	c3                   	ret    
  80343f:	90                   	nop
  803440:	89 fd                	mov    %edi,%ebp
  803442:	85 ff                	test   %edi,%edi
  803444:	75 0b                	jne    803451 <__umoddi3+0xe9>
  803446:	b8 01 00 00 00       	mov    $0x1,%eax
  80344b:	31 d2                	xor    %edx,%edx
  80344d:	f7 f7                	div    %edi
  80344f:	89 c5                	mov    %eax,%ebp
  803451:	89 f0                	mov    %esi,%eax
  803453:	31 d2                	xor    %edx,%edx
  803455:	f7 f5                	div    %ebp
  803457:	89 c8                	mov    %ecx,%eax
  803459:	f7 f5                	div    %ebp
  80345b:	89 d0                	mov    %edx,%eax
  80345d:	e9 44 ff ff ff       	jmp    8033a6 <__umoddi3+0x3e>
  803462:	66 90                	xchg   %ax,%ax
  803464:	89 c8                	mov    %ecx,%eax
  803466:	89 f2                	mov    %esi,%edx
  803468:	83 c4 1c             	add    $0x1c,%esp
  80346b:	5b                   	pop    %ebx
  80346c:	5e                   	pop    %esi
  80346d:	5f                   	pop    %edi
  80346e:	5d                   	pop    %ebp
  80346f:	c3                   	ret    
  803470:	3b 04 24             	cmp    (%esp),%eax
  803473:	72 06                	jb     80347b <__umoddi3+0x113>
  803475:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803479:	77 0f                	ja     80348a <__umoddi3+0x122>
  80347b:	89 f2                	mov    %esi,%edx
  80347d:	29 f9                	sub    %edi,%ecx
  80347f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803483:	89 14 24             	mov    %edx,(%esp)
  803486:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80348a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80348e:	8b 14 24             	mov    (%esp),%edx
  803491:	83 c4 1c             	add    $0x1c,%esp
  803494:	5b                   	pop    %ebx
  803495:	5e                   	pop    %esi
  803496:	5f                   	pop    %edi
  803497:	5d                   	pop    %ebp
  803498:	c3                   	ret    
  803499:	8d 76 00             	lea    0x0(%esi),%esi
  80349c:	2b 04 24             	sub    (%esp),%eax
  80349f:	19 fa                	sbb    %edi,%edx
  8034a1:	89 d1                	mov    %edx,%ecx
  8034a3:	89 c6                	mov    %eax,%esi
  8034a5:	e9 71 ff ff ff       	jmp    80341b <__umoddi3+0xb3>
  8034aa:	66 90                	xchg   %ax,%ax
  8034ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034b0:	72 ea                	jb     80349c <__umoddi3+0x134>
  8034b2:	89 d9                	mov    %ebx,%ecx
  8034b4:	e9 62 ff ff ff       	jmp    80341b <__umoddi3+0xb3>
