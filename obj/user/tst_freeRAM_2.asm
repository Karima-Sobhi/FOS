
obj/user/tst_freeRAM_2:     file format elf32-i386


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
  800031:	e8 ac 05 00 00       	call   8005e2 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec b0 00 00 00    	sub    $0xb0,%esp





	int Mega = 1024*1024;
  800043:	c7 45 f4 00 00 10 00 	movl   $0x100000,-0xc(%ebp)
	int kilo = 1024;
  80004a:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	char minByte = 1<<7;
  800051:	c6 45 ef 80          	movb   $0x80,-0x11(%ebp)
	char maxByte = 0x7F;
  800055:	c6 45 ee 7f          	movb   $0x7f,-0x12(%ebp)
	short minShort = 1<<15 ;
  800059:	66 c7 45 ec 00 80    	movw   $0x8000,-0x14(%ebp)
	short maxShort = 0x7FFF;
  80005f:	66 c7 45 ea ff 7f    	movw   $0x7fff,-0x16(%ebp)
	int minInt = 1<<31 ;
  800065:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
	int maxInt = 0x7FFFFFFF;
  80006c:	c7 45 e0 ff ff ff 7f 	movl   $0x7fffffff,-0x20(%ebp)

	void* ptr_allocations[20] = {0};
  800073:	8d 95 4c ff ff ff    	lea    -0xb4(%ebp),%edx
  800079:	b9 14 00 00 00       	mov    $0x14,%ecx
  80007e:	b8 00 00 00 00       	mov    $0x0,%eax
  800083:	89 d7                	mov    %edx,%edi
  800085:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//Load "fib" & "fos_helloWorld" programs into RAM
		cprintf("Loading Fib & fos_helloWorld programs into RAM...");
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	68 40 37 80 00       	push   $0x803740
  80008f:	e8 3e 09 00 00       	call   8009d2 <cprintf>
  800094:	83 c4 10             	add    $0x10,%esp
		int32 envIdFib = sys_create_env("fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800097:	a1 20 50 80 00       	mov    0x805020,%eax
  80009c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a7:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000ad:	89 c1                	mov    %eax,%ecx
  8000af:	a1 20 50 80 00       	mov    0x805020,%eax
  8000b4:	8b 40 74             	mov    0x74(%eax),%eax
  8000b7:	52                   	push   %edx
  8000b8:	51                   	push   %ecx
  8000b9:	50                   	push   %eax
  8000ba:	68 72 37 80 00       	push   $0x803772
  8000bf:	e8 da 1e 00 00       	call   801f9e <sys_create_env>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 5d 1c 00 00       	call   801d2c <sys_calculate_free_frames>
  8000cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int32 envIdHelloWorld = sys_create_env("fos_helloWorld", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8000d7:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000dd:	a1 20 50 80 00       	mov    0x805020,%eax
  8000e2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ef:	8b 40 74             	mov    0x74(%eax),%eax
  8000f2:	52                   	push   %edx
  8000f3:	51                   	push   %ecx
  8000f4:	50                   	push   %eax
  8000f5:	68 76 37 80 00       	push   $0x803776
  8000fa:	e8 9f 1e 00 00       	call   801f9e <sys_create_env>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int helloWorldFrames = freeFrames - sys_calculate_free_frames() ;
  800105:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800108:	e8 1f 1c 00 00       	call   801d2c <sys_calculate_free_frames>
  80010d:	29 c3                	sub    %eax,%ebx
  80010f:	89 d8                	mov    %ebx,%eax
  800111:	89 45 d0             	mov    %eax,-0x30(%ebp)
		env_sleep(2000);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 d0 07 00 00       	push   $0x7d0
  80011c:	e8 05 33 00 00       	call   803426 <env_sleep>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 85 37 80 00       	push   $0x803785
  80012c:	e8 a1 08 00 00       	call   8009d2 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp

		//Load and run "fos_add"
		cprintf("Loading fos_add program into RAM...");
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 90 37 80 00       	push   $0x803790
  80013c:	e8 91 08 00 00       	call   8009d2 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
		int32 envIdFOSAdd= sys_create_env("fos_add", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800144:	a1 20 50 80 00       	mov    0x805020,%eax
  800149:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80014f:	a1 20 50 80 00       	mov    0x805020,%eax
  800154:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80015a:	89 c1                	mov    %eax,%ecx
  80015c:	a1 20 50 80 00       	mov    0x805020,%eax
  800161:	8b 40 74             	mov    0x74(%eax),%eax
  800164:	52                   	push   %edx
  800165:	51                   	push   %ecx
  800166:	50                   	push   %eax
  800167:	68 b4 37 80 00       	push   $0x8037b4
  80016c:	e8 2d 1e 00 00       	call   801f9e <sys_create_env>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	89 45 cc             	mov    %eax,-0x34(%ebp)
		env_sleep(2000);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	68 d0 07 00 00       	push   $0x7d0
  80017f:	e8 a2 32 00 00       	call   803426 <env_sleep>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 85 37 80 00       	push   $0x803785
  80018f:	e8 3e 08 00 00       	call   8009d2 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		cprintf("running fos_add program...\n\n");
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	68 bc 37 80 00       	push   $0x8037bc
  80019f:	e8 2e 08 00 00       	call   8009d2 <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdFOSAdd);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 cc             	pushl  -0x34(%ebp)
  8001ad:	e8 0a 1e 00 00       	call   801fbc <sys_run_env>
  8001b2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	68 d9 37 80 00       	push   $0x8037d9
  8001bd:	e8 10 08 00 00       	call   8009d2 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 88 13 00 00       	push   $0x1388
  8001cd:	e8 54 32 00 00       	call   803426 <env_sleep>
  8001d2:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8001d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	50                   	push   %eax
  8001e1:	e8 18 17 00 00       	call   8018fe <malloc>
  8001e6:	83 c4 10             	add    $0x10,%esp
  8001e9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  8001ef:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8001f5:	89 45 c8             	mov    %eax,-0x38(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8001f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001fb:	01 c0                	add    %eax,%eax
  8001fd:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800200:	48                   	dec    %eax
  800201:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		byteArr[0] = minByte ;
  800204:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800207:	8a 55 ef             	mov    -0x11(%ebp),%dl
  80020a:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80020c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80020f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800212:	01 c2                	add    %eax,%edx
  800214:	8a 45 ee             	mov    -0x12(%ebp),%al
  800217:	88 02                	mov    %al,(%edx)

		//Allocate another 2 MB
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80021c:	01 c0                	add    %eax,%eax
  80021e:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 d4 16 00 00       	call   8018fe <malloc>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  800233:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800239:	89 45 c0             	mov    %eax,-0x40(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  80023c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023f:	01 c0                	add    %eax,%eax
  800241:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800244:	d1 e8                	shr    %eax
  800246:	48                   	dec    %eax
  800247:	89 45 bc             	mov    %eax,-0x44(%ebp)
		shortArr[0] = minShort;
  80024a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80024d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800250:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800253:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800256:	01 c0                	add    %eax,%eax
  800258:	89 c2                	mov    %eax,%edx
  80025a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80025d:	01 c2                	add    %eax,%edx
  80025f:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  800263:	66 89 02             	mov    %ax,(%edx)

		//Allocate all remaining RAM (Here: it requires to free some RAM by removing exited program (fos_add))
		freeFrames = sys_calculate_free_frames() ;
  800266:	e8 c1 1a 00 00       	call   801d2c <sys_calculate_free_frames>
  80026b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[2] = malloc(freeFrames*PAGE_SIZE);
  80026e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800271:	c1 e0 0c             	shl    $0xc,%eax
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	50                   	push   %eax
  800278:	e8 81 16 00 00       	call   8018fe <malloc>
  80027d:	83 c4 10             	add    $0x10,%esp
  800280:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  800286:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  80028c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		int lastIndexOfInt = (freeFrames*PAGE_SIZE)/sizeof(int) - 1;
  80028f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800292:	c1 e0 0c             	shl    $0xc,%eax
  800295:	c1 e8 02             	shr    $0x2,%eax
  800298:	48                   	dec    %eax
  800299:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		intArr[0] = minInt;
  80029c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80029f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a2:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8002a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002b1:	01 c2                	add    %eax,%edx
  8002b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b6:	89 02                	mov    %eax,(%edx)

		//Allocate 7 KB after freeing some RAM
		ptr_allocations[3] = malloc(7*kilo);
  8002b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8002bb:	89 d0                	mov    %edx,%eax
  8002bd:	01 c0                	add    %eax,%eax
  8002bf:	01 d0                	add    %edx,%eax
  8002c1:	01 c0                	add    %eax,%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	83 ec 0c             	sub    $0xc,%esp
  8002c8:	50                   	push   %eax
  8002c9:	e8 30 16 00 00       	call   8018fe <malloc>
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8002d7:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8002dd:	89 45 b0             	mov    %eax,-0x50(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8002e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8002e3:	89 d0                	mov    %edx,%eax
  8002e5:	01 c0                	add    %eax,%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	01 c0                	add    %eax,%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	c1 e8 03             	shr    $0x3,%eax
  8002f0:	48                   	dec    %eax
  8002f1:	89 45 ac             	mov    %eax,-0x54(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8002f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002f7:	8a 55 ef             	mov    -0x11(%ebp),%dl
  8002fa:	88 10                	mov    %dl,(%eax)
  8002fc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8002ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800302:	66 89 42 02          	mov    %ax,0x2(%edx)
  800306:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800309:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80030c:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  80030f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80031c:	01 c2                	add    %eax,%edx
  80031e:	8a 45 ee             	mov    -0x12(%ebp),%al
  800321:	88 02                	mov    %al,(%edx)
  800323:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800326:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80032d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800330:	01 c2                	add    %eax,%edx
  800332:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  800336:	66 89 42 02          	mov    %ax,0x2(%edx)
  80033a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80033d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800344:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800347:	01 c2                	add    %eax,%edx
  800349:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80034c:	89 42 04             	mov    %eax,0x4(%edx)

		cprintf("running fos_helloWorld program...\n\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 f0 37 80 00       	push   $0x8037f0
  800357:	e8 76 06 00 00       	call   8009d2 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdHelloWorld);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d4             	pushl  -0x2c(%ebp)
  800365:	e8 52 1c 00 00       	call   801fbc <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 d9 37 80 00       	push   $0x8037d9
  800375:	e8 58 06 00 00       	call   8009d2 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	68 88 13 00 00       	push   $0x1388
  800385:	e8 9c 30 00 00       	call   803426 <env_sleep>
  80038a:	83 c4 10             	add    $0x10,%esp

		//Allocate the remaining RAM + extra RAM by the size of helloWorld program (Here: it requires to free some RAM by removing exited & loaded program(s) (fos_helloWorld & fib))
		freeFrames = sys_calculate_free_frames() ;
  80038d:	e8 9a 19 00 00       	call   801d2c <sys_calculate_free_frames>
  800392:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[4] = malloc((freeFrames + helloWorldFrames)*PAGE_SIZE);
  800395:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800398:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039b:	01 d0                	add    %edx,%eax
  80039d:	c1 e0 0c             	shl    $0xc,%eax
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	50                   	push   %eax
  8003a4:	e8 55 15 00 00       	call   8018fe <malloc>
  8003a9:	83 c4 10             	add    $0x10,%esp
  8003ac:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		int *intArr2 = (int *) ptr_allocations[4];
  8003b2:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8003b8:	89 45 a8             	mov    %eax,-0x58(%ebp)
		int lastIndexOfInt2 = ((freeFrames + helloWorldFrames)*PAGE_SIZE)/sizeof(int) - 1;
  8003bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 0c             	shl    $0xc,%eax
  8003c6:	c1 e8 02             	shr    $0x2,%eax
  8003c9:	48                   	dec    %eax
  8003ca:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		intArr2[0] = minInt;
  8003cd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003d3:	89 10                	mov    %edx,(%eax)
		intArr2[lastIndexOfInt2] = maxInt;
  8003d5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003df:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003e2:	01 c2                	add    %eax,%edx
  8003e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e7:	89 02                	mov    %eax,(%edx)

		//Allocate 8 B after freeing the RAM
		ptr_allocations[5] = malloc(8);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	6a 08                	push   $0x8
  8003ee:	e8 0b 15 00 00       	call   8018fe <malloc>
  8003f3:	83 c4 10             	add    $0x10,%esp
  8003f6:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		int *intArr3 = (int *) ptr_allocations[5];
  8003fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800402:	89 45 a0             	mov    %eax,-0x60(%ebp)
		int lastIndexOfInt3 = 8/sizeof(int) - 1;
  800405:	c7 45 9c 01 00 00 00 	movl   $0x1,-0x64(%ebp)
		intArr3[0] = minInt;
  80040c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80040f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800412:	89 10                	mov    %edx,(%eax)
		intArr3[lastIndexOfInt3] = maxInt;
  800414:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800417:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80041e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800421:	01 c2                	add    %eax,%edx
  800423:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800426:	89 02                	mov    %eax,(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800428:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80042b:	8a 00                	mov    (%eax),%al
  80042d:	3a 45 ef             	cmp    -0x11(%ebp),%al
  800430:	75 0f                	jne    800441 <_main+0x409>
  800432:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800435:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800438:	01 d0                	add    %edx,%eax
  80043a:	8a 00                	mov    (%eax),%al
  80043c:	3a 45 ee             	cmp    -0x12(%ebp),%al
  80043f:	74 14                	je     800455 <_main+0x41d>
  800441:	83 ec 04             	sub    $0x4,%esp
  800444:	68 14 38 80 00       	push   $0x803814
  800449:	6a 62                	push   $0x62
  80044b:	68 49 38 80 00       	push   $0x803849
  800450:	e8 c9 02 00 00       	call   80071e <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800455:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800458:	66 8b 00             	mov    (%eax),%ax
  80045b:	66 3b 45 ec          	cmp    -0x14(%ebp),%ax
  80045f:	75 15                	jne    800476 <_main+0x43e>
  800461:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800464:	01 c0                	add    %eax,%eax
  800466:	89 c2                	mov    %eax,%edx
  800468:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	66 8b 00             	mov    (%eax),%ax
  800470:	66 3b 45 ea          	cmp    -0x16(%ebp),%ax
  800474:	74 14                	je     80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 14 38 80 00       	push   $0x803814
  80047e:	6a 63                	push   $0x63
  800480:	68 49 38 80 00       	push   $0x803849
  800485:	e8 94 02 00 00       	call   80071e <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  80048a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800492:	75 16                	jne    8004aa <_main+0x472>
  800494:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800497:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80049e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004a1:	01 d0                	add    %edx,%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 14 38 80 00       	push   $0x803814
  8004b2:	6a 64                	push   $0x64
  8004b4:	68 49 38 80 00       	push   $0x803849
  8004b9:	e8 60 02 00 00       	call   80071e <_panic>
		if (intArr2[0] 	!= minInt 	|| intArr2[lastIndexOfInt2] 	!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8004be:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004c6:	75 16                	jne    8004de <_main+0x4a6>
  8004c8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004d5:	01 d0                	add    %edx,%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004dc:	74 14                	je     8004f2 <_main+0x4ba>
  8004de:	83 ec 04             	sub    $0x4,%esp
  8004e1:	68 14 38 80 00       	push   $0x803814
  8004e6:	6a 65                	push   $0x65
  8004e8:	68 49 38 80 00       	push   $0x803849
  8004ed:	e8 2c 02 00 00       	call   80071e <_panic>
		if (intArr3[0] 	!= minInt 	|| intArr3[lastIndexOfInt3] 	!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8004f2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fa:	75 16                	jne    800512 <_main+0x4da>
  8004fc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800506:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 14 38 80 00       	push   $0x803814
  80051a:	6a 66                	push   $0x66
  80051c:	68 49 38 80 00       	push   $0x803849
  800521:	e8 f8 01 00 00       	call   80071e <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  800526:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800529:	8a 00                	mov    (%eax),%al
  80052b:	3a 45 ef             	cmp    -0x11(%ebp),%al
  80052e:	75 16                	jne    800546 <_main+0x50e>
  800530:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800533:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80053a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80053d:	01 d0                	add    %edx,%eax
  80053f:	8a 00                	mov    (%eax),%al
  800541:	3a 45 ee             	cmp    -0x12(%ebp),%al
  800544:	74 14                	je     80055a <_main+0x522>
  800546:	83 ec 04             	sub    $0x4,%esp
  800549:	68 14 38 80 00       	push   $0x803814
  80054e:	6a 68                	push   $0x68
  800550:	68 49 38 80 00       	push   $0x803849
  800555:	e8 c4 01 00 00       	call   80071e <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  80055a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80055d:	66 8b 40 02          	mov    0x2(%eax),%ax
  800561:	66 3b 45 ec          	cmp    -0x14(%ebp),%ax
  800565:	75 19                	jne    800580 <_main+0x548>
  800567:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80056a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800571:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800574:	01 d0                	add    %edx,%eax
  800576:	66 8b 40 02          	mov    0x2(%eax),%ax
  80057a:	66 3b 45 ea          	cmp    -0x16(%ebp),%ax
  80057e:	74 14                	je     800594 <_main+0x55c>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 14 38 80 00       	push   $0x803814
  800588:	6a 69                	push   $0x69
  80058a:	68 49 38 80 00       	push   $0x803849
  80058f:	e8 8a 01 00 00       	call   80071e <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  800594:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800597:	8b 40 04             	mov    0x4(%eax),%eax
  80059a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80059d:	75 17                	jne    8005b6 <_main+0x57e>
  80059f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005ac:	01 d0                	add    %edx,%eax
  8005ae:	8b 40 04             	mov    0x4(%eax),%eax
  8005b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005b4:	74 14                	je     8005ca <_main+0x592>
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	68 14 38 80 00       	push   $0x803814
  8005be:	6a 6a                	push   $0x6a
  8005c0:	68 49 38 80 00       	push   $0x803849
  8005c5:	e8 54 01 00 00       	call   80071e <_panic>


	}

	cprintf("Congratulations!! test freeRAM (1) completed successfully.\n");
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	68 60 38 80 00       	push   $0x803860
  8005d2:	e8 fb 03 00 00       	call   8009d2 <cprintf>
  8005d7:	83 c4 10             	add    $0x10,%esp

	return;
  8005da:	90                   	nop
}
  8005db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8005de:	5b                   	pop    %ebx
  8005df:	5f                   	pop    %edi
  8005e0:	5d                   	pop    %ebp
  8005e1:	c3                   	ret    

008005e2 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005e8:	e8 1f 1a 00 00       	call   80200c <sys_getenvindex>
  8005ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f3:	89 d0                	mov    %edx,%eax
  8005f5:	c1 e0 03             	shl    $0x3,%eax
  8005f8:	01 d0                	add    %edx,%eax
  8005fa:	01 c0                	add    %eax,%eax
  8005fc:	01 d0                	add    %edx,%eax
  8005fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800605:	01 d0                	add    %edx,%eax
  800607:	c1 e0 04             	shl    $0x4,%eax
  80060a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80060f:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800614:	a1 20 50 80 00       	mov    0x805020,%eax
  800619:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80061f:	84 c0                	test   %al,%al
  800621:	74 0f                	je     800632 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800623:	a1 20 50 80 00       	mov    0x805020,%eax
  800628:	05 5c 05 00 00       	add    $0x55c,%eax
  80062d:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800632:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800636:	7e 0a                	jle    800642 <libmain+0x60>
		binaryname = argv[0];
  800638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	ff 75 0c             	pushl  0xc(%ebp)
  800648:	ff 75 08             	pushl  0x8(%ebp)
  80064b:	e8 e8 f9 ff ff       	call   800038 <_main>
  800650:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800653:	e8 c1 17 00 00       	call   801e19 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 b4 38 80 00       	push   $0x8038b4
  800660:	e8 6d 03 00 00       	call   8009d2 <cprintf>
  800665:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800668:	a1 20 50 80 00       	mov    0x805020,%eax
  80066d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800673:	a1 20 50 80 00       	mov    0x805020,%eax
  800678:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80067e:	83 ec 04             	sub    $0x4,%esp
  800681:	52                   	push   %edx
  800682:	50                   	push   %eax
  800683:	68 dc 38 80 00       	push   $0x8038dc
  800688:	e8 45 03 00 00       	call   8009d2 <cprintf>
  80068d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800690:	a1 20 50 80 00       	mov    0x805020,%eax
  800695:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80069b:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006a6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006ab:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006b1:	51                   	push   %ecx
  8006b2:	52                   	push   %edx
  8006b3:	50                   	push   %eax
  8006b4:	68 04 39 80 00       	push   $0x803904
  8006b9:	e8 14 03 00 00       	call   8009d2 <cprintf>
  8006be:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	50                   	push   %eax
  8006d0:	68 5c 39 80 00       	push   $0x80395c
  8006d5:	e8 f8 02 00 00       	call   8009d2 <cprintf>
  8006da:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006dd:	83 ec 0c             	sub    $0xc,%esp
  8006e0:	68 b4 38 80 00       	push   $0x8038b4
  8006e5:	e8 e8 02 00 00       	call   8009d2 <cprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006ed:	e8 41 17 00 00       	call   801e33 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006f2:	e8 19 00 00 00       	call   800710 <exit>
}
  8006f7:	90                   	nop
  8006f8:	c9                   	leave  
  8006f9:	c3                   	ret    

008006fa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006fa:	55                   	push   %ebp
  8006fb:	89 e5                	mov    %esp,%ebp
  8006fd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800700:	83 ec 0c             	sub    $0xc,%esp
  800703:	6a 00                	push   $0x0
  800705:	e8 ce 18 00 00       	call   801fd8 <sys_destroy_env>
  80070a:	83 c4 10             	add    $0x10,%esp
}
  80070d:	90                   	nop
  80070e:	c9                   	leave  
  80070f:	c3                   	ret    

00800710 <exit>:

void
exit(void)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800716:	e8 23 19 00 00       	call   80203e <sys_exit_env>
}
  80071b:	90                   	nop
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    

0080071e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800724:	8d 45 10             	lea    0x10(%ebp),%eax
  800727:	83 c0 04             	add    $0x4,%eax
  80072a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80072d:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800732:	85 c0                	test   %eax,%eax
  800734:	74 16                	je     80074c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800736:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	50                   	push   %eax
  80073f:	68 70 39 80 00       	push   $0x803970
  800744:	e8 89 02 00 00       	call   8009d2 <cprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80074c:	a1 00 50 80 00       	mov    0x805000,%eax
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	ff 75 08             	pushl  0x8(%ebp)
  800757:	50                   	push   %eax
  800758:	68 75 39 80 00       	push   $0x803975
  80075d:	e8 70 02 00 00       	call   8009d2 <cprintf>
  800762:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	ff 75 f4             	pushl  -0xc(%ebp)
  80076e:	50                   	push   %eax
  80076f:	e8 f3 01 00 00       	call   800967 <vcprintf>
  800774:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	6a 00                	push   $0x0
  80077c:	68 91 39 80 00       	push   $0x803991
  800781:	e8 e1 01 00 00       	call   800967 <vcprintf>
  800786:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800789:	e8 82 ff ff ff       	call   800710 <exit>

	// should not return here
	while (1) ;
  80078e:	eb fe                	jmp    80078e <_panic+0x70>

00800790 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800796:	a1 20 50 80 00       	mov    0x805020,%eax
  80079b:	8b 50 74             	mov    0x74(%eax),%edx
  80079e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a1:	39 c2                	cmp    %eax,%edx
  8007a3:	74 14                	je     8007b9 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007a5:	83 ec 04             	sub    $0x4,%esp
  8007a8:	68 94 39 80 00       	push   $0x803994
  8007ad:	6a 26                	push   $0x26
  8007af:	68 e0 39 80 00       	push   $0x8039e0
  8007b4:	e8 65 ff ff ff       	call   80071e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007c7:	e9 c2 00 00 00       	jmp    80088e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	01 d0                	add    %edx,%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	85 c0                	test   %eax,%eax
  8007df:	75 08                	jne    8007e9 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007e1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007e4:	e9 a2 00 00 00       	jmp    80088b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007f7:	eb 69                	jmp    800862 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8007fe:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800804:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800807:	89 d0                	mov    %edx,%eax
  800809:	01 c0                	add    %eax,%eax
  80080b:	01 d0                	add    %edx,%eax
  80080d:	c1 e0 03             	shl    $0x3,%eax
  800810:	01 c8                	add    %ecx,%eax
  800812:	8a 40 04             	mov    0x4(%eax),%al
  800815:	84 c0                	test   %al,%al
  800817:	75 46                	jne    80085f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800819:	a1 20 50 80 00       	mov    0x805020,%eax
  80081e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800824:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800827:	89 d0                	mov    %edx,%eax
  800829:	01 c0                	add    %eax,%eax
  80082b:	01 d0                	add    %edx,%eax
  80082d:	c1 e0 03             	shl    $0x3,%eax
  800830:	01 c8                	add    %ecx,%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800837:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80083a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80083f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800844:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	01 c8                	add    %ecx,%eax
  800850:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800852:	39 c2                	cmp    %eax,%edx
  800854:	75 09                	jne    80085f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800856:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80085d:	eb 12                	jmp    800871 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80085f:	ff 45 e8             	incl   -0x18(%ebp)
  800862:	a1 20 50 80 00       	mov    0x805020,%eax
  800867:	8b 50 74             	mov    0x74(%eax),%edx
  80086a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80086d:	39 c2                	cmp    %eax,%edx
  80086f:	77 88                	ja     8007f9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800871:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800875:	75 14                	jne    80088b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800877:	83 ec 04             	sub    $0x4,%esp
  80087a:	68 ec 39 80 00       	push   $0x8039ec
  80087f:	6a 3a                	push   $0x3a
  800881:	68 e0 39 80 00       	push   $0x8039e0
  800886:	e8 93 fe ff ff       	call   80071e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80088b:	ff 45 f0             	incl   -0x10(%ebp)
  80088e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800891:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800894:	0f 8c 32 ff ff ff    	jl     8007cc <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80089a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008a8:	eb 26                	jmp    8008d0 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8008af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b8:	89 d0                	mov    %edx,%eax
  8008ba:	01 c0                	add    %eax,%eax
  8008bc:	01 d0                	add    %edx,%eax
  8008be:	c1 e0 03             	shl    $0x3,%eax
  8008c1:	01 c8                	add    %ecx,%eax
  8008c3:	8a 40 04             	mov    0x4(%eax),%al
  8008c6:	3c 01                	cmp    $0x1,%al
  8008c8:	75 03                	jne    8008cd <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008ca:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008cd:	ff 45 e0             	incl   -0x20(%ebp)
  8008d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8008d5:	8b 50 74             	mov    0x74(%eax),%edx
  8008d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008db:	39 c2                	cmp    %eax,%edx
  8008dd:	77 cb                	ja     8008aa <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008e5:	74 14                	je     8008fb <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008e7:	83 ec 04             	sub    $0x4,%esp
  8008ea:	68 40 3a 80 00       	push   $0x803a40
  8008ef:	6a 44                	push   $0x44
  8008f1:	68 e0 39 80 00       	push   $0x8039e0
  8008f6:	e8 23 fe ff ff       	call   80071e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008fb:	90                   	nop
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800904:	8b 45 0c             	mov    0xc(%ebp),%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	8d 48 01             	lea    0x1(%eax),%ecx
  80090c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090f:	89 0a                	mov    %ecx,(%edx)
  800911:	8b 55 08             	mov    0x8(%ebp),%edx
  800914:	88 d1                	mov    %dl,%cl
  800916:	8b 55 0c             	mov    0xc(%ebp),%edx
  800919:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	3d ff 00 00 00       	cmp    $0xff,%eax
  800927:	75 2c                	jne    800955 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800929:	a0 24 50 80 00       	mov    0x805024,%al
  80092e:	0f b6 c0             	movzbl %al,%eax
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
  800934:	8b 12                	mov    (%edx),%edx
  800936:	89 d1                	mov    %edx,%ecx
  800938:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093b:	83 c2 08             	add    $0x8,%edx
  80093e:	83 ec 04             	sub    $0x4,%esp
  800941:	50                   	push   %eax
  800942:	51                   	push   %ecx
  800943:	52                   	push   %edx
  800944:	e8 22 13 00 00       	call   801c6b <sys_cputs>
  800949:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80094c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
  800958:	8b 40 04             	mov    0x4(%eax),%eax
  80095b:	8d 50 01             	lea    0x1(%eax),%edx
  80095e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800961:	89 50 04             	mov    %edx,0x4(%eax)
}
  800964:	90                   	nop
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800970:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800977:	00 00 00 
	b.cnt = 0;
  80097a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800981:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	ff 75 08             	pushl  0x8(%ebp)
  80098a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800990:	50                   	push   %eax
  800991:	68 fe 08 80 00       	push   $0x8008fe
  800996:	e8 11 02 00 00       	call   800bac <vprintfmt>
  80099b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80099e:	a0 24 50 80 00       	mov    0x805024,%al
  8009a3:	0f b6 c0             	movzbl %al,%eax
  8009a6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009ac:	83 ec 04             	sub    $0x4,%esp
  8009af:	50                   	push   %eax
  8009b0:	52                   	push   %edx
  8009b1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009b7:	83 c0 08             	add    $0x8,%eax
  8009ba:	50                   	push   %eax
  8009bb:	e8 ab 12 00 00       	call   801c6b <sys_cputs>
  8009c0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009c3:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8009ca:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009d8:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8009df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ee:	50                   	push   %eax
  8009ef:	e8 73 ff ff ff       	call   800967 <vcprintf>
  8009f4:	83 c4 10             	add    $0x10,%esp
  8009f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fd:	c9                   	leave  
  8009fe:	c3                   	ret    

008009ff <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a05:	e8 0f 14 00 00       	call   801e19 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a0a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 f4             	pushl  -0xc(%ebp)
  800a19:	50                   	push   %eax
  800a1a:	e8 48 ff ff ff       	call   800967 <vcprintf>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a25:	e8 09 14 00 00       	call   801e33 <sys_enable_interrupt>
	return cnt;
  800a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	53                   	push   %ebx
  800a33:	83 ec 14             	sub    $0x14,%esp
  800a36:	8b 45 10             	mov    0x10(%ebp),%eax
  800a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a42:	8b 45 18             	mov    0x18(%ebp),%eax
  800a45:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a4d:	77 55                	ja     800aa4 <printnum+0x75>
  800a4f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a52:	72 05                	jb     800a59 <printnum+0x2a>
  800a54:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a57:	77 4b                	ja     800aa4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a59:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a5c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a5f:	8b 45 18             	mov    0x18(%ebp),%eax
  800a62:	ba 00 00 00 00       	mov    $0x0,%edx
  800a67:	52                   	push   %edx
  800a68:	50                   	push   %eax
  800a69:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6c:	ff 75 f0             	pushl  -0x10(%ebp)
  800a6f:	e8 68 2a 00 00       	call   8034dc <__udivdi3>
  800a74:	83 c4 10             	add    $0x10,%esp
  800a77:	83 ec 04             	sub    $0x4,%esp
  800a7a:	ff 75 20             	pushl  0x20(%ebp)
  800a7d:	53                   	push   %ebx
  800a7e:	ff 75 18             	pushl  0x18(%ebp)
  800a81:	52                   	push   %edx
  800a82:	50                   	push   %eax
  800a83:	ff 75 0c             	pushl  0xc(%ebp)
  800a86:	ff 75 08             	pushl  0x8(%ebp)
  800a89:	e8 a1 ff ff ff       	call   800a2f <printnum>
  800a8e:	83 c4 20             	add    $0x20,%esp
  800a91:	eb 1a                	jmp    800aad <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	ff 75 20             	pushl  0x20(%ebp)
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aa4:	ff 4d 1c             	decl   0x1c(%ebp)
  800aa7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800aab:	7f e6                	jg     800a93 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800aad:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ab0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800abb:	53                   	push   %ebx
  800abc:	51                   	push   %ecx
  800abd:	52                   	push   %edx
  800abe:	50                   	push   %eax
  800abf:	e8 28 2b 00 00       	call   8035ec <__umoddi3>
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	05 b4 3c 80 00       	add    $0x803cb4,%eax
  800acc:	8a 00                	mov    (%eax),%al
  800ace:	0f be c0             	movsbl %al,%eax
  800ad1:	83 ec 08             	sub    $0x8,%esp
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	50                   	push   %eax
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	ff d0                	call   *%eax
  800add:	83 c4 10             	add    $0x10,%esp
}
  800ae0:	90                   	nop
  800ae1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ae9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800aed:	7e 1c                	jle    800b0b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8b 00                	mov    (%eax),%eax
  800af4:	8d 50 08             	lea    0x8(%eax),%edx
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	89 10                	mov    %edx,(%eax)
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8b 00                	mov    (%eax),%eax
  800b01:	83 e8 08             	sub    $0x8,%eax
  800b04:	8b 50 04             	mov    0x4(%eax),%edx
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	eb 40                	jmp    800b4b <getuint+0x65>
	else if (lflag)
  800b0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0f:	74 1e                	je     800b2f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8b 00                	mov    (%eax),%eax
  800b16:	8d 50 04             	lea    0x4(%eax),%edx
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	89 10                	mov    %edx,(%eax)
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	83 e8 04             	sub    $0x4,%eax
  800b26:	8b 00                	mov    (%eax),%eax
  800b28:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2d:	eb 1c                	jmp    800b4b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	8d 50 04             	lea    0x4(%eax),%edx
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	89 10                	mov    %edx,(%eax)
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8b 00                	mov    (%eax),%eax
  800b41:	83 e8 04             	sub    $0x4,%eax
  800b44:	8b 00                	mov    (%eax),%eax
  800b46:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    

00800b4d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b50:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b54:	7e 1c                	jle    800b72 <getint+0x25>
		return va_arg(*ap, long long);
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8b 00                	mov    (%eax),%eax
  800b5b:	8d 50 08             	lea    0x8(%eax),%edx
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	89 10                	mov    %edx,(%eax)
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8b 00                	mov    (%eax),%eax
  800b68:	83 e8 08             	sub    $0x8,%eax
  800b6b:	8b 50 04             	mov    0x4(%eax),%edx
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	eb 38                	jmp    800baa <getint+0x5d>
	else if (lflag)
  800b72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b76:	74 1a                	je     800b92 <getint+0x45>
		return va_arg(*ap, long);
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	8b 00                	mov    (%eax),%eax
  800b7d:	8d 50 04             	lea    0x4(%eax),%edx
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 10                	mov    %edx,(%eax)
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8b 00                	mov    (%eax),%eax
  800b8a:	83 e8 04             	sub    $0x4,%eax
  800b8d:	8b 00                	mov    (%eax),%eax
  800b8f:	99                   	cltd   
  800b90:	eb 18                	jmp    800baa <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	8d 50 04             	lea    0x4(%eax),%edx
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	89 10                	mov    %edx,(%eax)
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8b 00                	mov    (%eax),%eax
  800ba4:	83 e8 04             	sub    $0x4,%eax
  800ba7:	8b 00                	mov    (%eax),%eax
  800ba9:	99                   	cltd   
}
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	56                   	push   %esi
  800bb0:	53                   	push   %ebx
  800bb1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb4:	eb 17                	jmp    800bcd <vprintfmt+0x21>
			if (ch == '\0')
  800bb6:	85 db                	test   %ebx,%ebx
  800bb8:	0f 84 af 03 00 00    	je     800f6d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	53                   	push   %ebx
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	ff d0                	call   *%eax
  800bca:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd0:	8d 50 01             	lea    0x1(%eax),%edx
  800bd3:	89 55 10             	mov    %edx,0x10(%ebp)
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	0f b6 d8             	movzbl %al,%ebx
  800bdb:	83 fb 25             	cmp    $0x25,%ebx
  800bde:	75 d6                	jne    800bb6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800be0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800be4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800beb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bf2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bf9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c00:	8b 45 10             	mov    0x10(%ebp),%eax
  800c03:	8d 50 01             	lea    0x1(%eax),%edx
  800c06:	89 55 10             	mov    %edx,0x10(%ebp)
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	0f b6 d8             	movzbl %al,%ebx
  800c0e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c11:	83 f8 55             	cmp    $0x55,%eax
  800c14:	0f 87 2b 03 00 00    	ja     800f45 <vprintfmt+0x399>
  800c1a:	8b 04 85 d8 3c 80 00 	mov    0x803cd8(,%eax,4),%eax
  800c21:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c23:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c27:	eb d7                	jmp    800c00 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c29:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c2d:	eb d1                	jmp    800c00 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c39:	89 d0                	mov    %edx,%eax
  800c3b:	c1 e0 02             	shl    $0x2,%eax
  800c3e:	01 d0                	add    %edx,%eax
  800c40:	01 c0                	add    %eax,%eax
  800c42:	01 d8                	add    %ebx,%eax
  800c44:	83 e8 30             	sub    $0x30,%eax
  800c47:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c52:	83 fb 2f             	cmp    $0x2f,%ebx
  800c55:	7e 3e                	jle    800c95 <vprintfmt+0xe9>
  800c57:	83 fb 39             	cmp    $0x39,%ebx
  800c5a:	7f 39                	jg     800c95 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c5c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c5f:	eb d5                	jmp    800c36 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c61:	8b 45 14             	mov    0x14(%ebp),%eax
  800c64:	83 c0 04             	add    $0x4,%eax
  800c67:	89 45 14             	mov    %eax,0x14(%ebp)
  800c6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6d:	83 e8 04             	sub    $0x4,%eax
  800c70:	8b 00                	mov    (%eax),%eax
  800c72:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c75:	eb 1f                	jmp    800c96 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c7b:	79 83                	jns    800c00 <vprintfmt+0x54>
				width = 0;
  800c7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c84:	e9 77 ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c89:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c90:	e9 6b ff ff ff       	jmp    800c00 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c95:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c9a:	0f 89 60 ff ff ff    	jns    800c00 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ca0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ca3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ca6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cad:	e9 4e ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cb2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cb5:	e9 46 ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cba:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbd:	83 c0 04             	add    $0x4,%eax
  800cc0:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 e8 04             	sub    $0x4,%eax
  800cc9:	8b 00                	mov    (%eax),%eax
  800ccb:	83 ec 08             	sub    $0x8,%esp
  800cce:	ff 75 0c             	pushl  0xc(%ebp)
  800cd1:	50                   	push   %eax
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	ff d0                	call   *%eax
  800cd7:	83 c4 10             	add    $0x10,%esp
			break;
  800cda:	e9 89 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce2:	83 c0 04             	add    $0x4,%eax
  800ce5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ceb:	83 e8 04             	sub    $0x4,%eax
  800cee:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cf0:	85 db                	test   %ebx,%ebx
  800cf2:	79 02                	jns    800cf6 <vprintfmt+0x14a>
				err = -err;
  800cf4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cf6:	83 fb 64             	cmp    $0x64,%ebx
  800cf9:	7f 0b                	jg     800d06 <vprintfmt+0x15a>
  800cfb:	8b 34 9d 20 3b 80 00 	mov    0x803b20(,%ebx,4),%esi
  800d02:	85 f6                	test   %esi,%esi
  800d04:	75 19                	jne    800d1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d06:	53                   	push   %ebx
  800d07:	68 c5 3c 80 00       	push   $0x803cc5
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	ff 75 08             	pushl  0x8(%ebp)
  800d12:	e8 5e 02 00 00       	call   800f75 <printfmt>
  800d17:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d1a:	e9 49 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d1f:	56                   	push   %esi
  800d20:	68 ce 3c 80 00       	push   $0x803cce
  800d25:	ff 75 0c             	pushl  0xc(%ebp)
  800d28:	ff 75 08             	pushl  0x8(%ebp)
  800d2b:	e8 45 02 00 00       	call   800f75 <printfmt>
  800d30:	83 c4 10             	add    $0x10,%esp
			break;
  800d33:	e9 30 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d38:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3b:	83 c0 04             	add    $0x4,%eax
  800d3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	83 e8 04             	sub    $0x4,%eax
  800d47:	8b 30                	mov    (%eax),%esi
  800d49:	85 f6                	test   %esi,%esi
  800d4b:	75 05                	jne    800d52 <vprintfmt+0x1a6>
				p = "(null)";
  800d4d:	be d1 3c 80 00       	mov    $0x803cd1,%esi
			if (width > 0 && padc != '-')
  800d52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d56:	7e 6d                	jle    800dc5 <vprintfmt+0x219>
  800d58:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d5c:	74 67                	je     800dc5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d61:	83 ec 08             	sub    $0x8,%esp
  800d64:	50                   	push   %eax
  800d65:	56                   	push   %esi
  800d66:	e8 0c 03 00 00       	call   801077 <strnlen>
  800d6b:	83 c4 10             	add    $0x10,%esp
  800d6e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d71:	eb 16                	jmp    800d89 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d73:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d77:	83 ec 08             	sub    $0x8,%esp
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	50                   	push   %eax
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d86:	ff 4d e4             	decl   -0x1c(%ebp)
  800d89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d8d:	7f e4                	jg     800d73 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d8f:	eb 34                	jmp    800dc5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d91:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d95:	74 1c                	je     800db3 <vprintfmt+0x207>
  800d97:	83 fb 1f             	cmp    $0x1f,%ebx
  800d9a:	7e 05                	jle    800da1 <vprintfmt+0x1f5>
  800d9c:	83 fb 7e             	cmp    $0x7e,%ebx
  800d9f:	7e 12                	jle    800db3 <vprintfmt+0x207>
					putch('?', putdat);
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	ff 75 0c             	pushl  0xc(%ebp)
  800da7:	6a 3f                	push   $0x3f
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	ff d0                	call   *%eax
  800dae:	83 c4 10             	add    $0x10,%esp
  800db1:	eb 0f                	jmp    800dc2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 0c             	pushl  0xc(%ebp)
  800db9:	53                   	push   %ebx
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	ff d0                	call   *%eax
  800dbf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dc2:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc5:	89 f0                	mov    %esi,%eax
  800dc7:	8d 70 01             	lea    0x1(%eax),%esi
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	0f be d8             	movsbl %al,%ebx
  800dcf:	85 db                	test   %ebx,%ebx
  800dd1:	74 24                	je     800df7 <vprintfmt+0x24b>
  800dd3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dd7:	78 b8                	js     800d91 <vprintfmt+0x1e5>
  800dd9:	ff 4d e0             	decl   -0x20(%ebp)
  800ddc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de0:	79 af                	jns    800d91 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800de2:	eb 13                	jmp    800df7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800de4:	83 ec 08             	sub    $0x8,%esp
  800de7:	ff 75 0c             	pushl  0xc(%ebp)
  800dea:	6a 20                	push   $0x20
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	ff d0                	call   *%eax
  800df1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800df4:	ff 4d e4             	decl   -0x1c(%ebp)
  800df7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfb:	7f e7                	jg     800de4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dfd:	e9 66 01 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e02:	83 ec 08             	sub    $0x8,%esp
  800e05:	ff 75 e8             	pushl  -0x18(%ebp)
  800e08:	8d 45 14             	lea    0x14(%ebp),%eax
  800e0b:	50                   	push   %eax
  800e0c:	e8 3c fd ff ff       	call   800b4d <getint>
  800e11:	83 c4 10             	add    $0x10,%esp
  800e14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e20:	85 d2                	test   %edx,%edx
  800e22:	79 23                	jns    800e47 <vprintfmt+0x29b>
				putch('-', putdat);
  800e24:	83 ec 08             	sub    $0x8,%esp
  800e27:	ff 75 0c             	pushl  0xc(%ebp)
  800e2a:	6a 2d                	push   $0x2d
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	ff d0                	call   *%eax
  800e31:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3a:	f7 d8                	neg    %eax
  800e3c:	83 d2 00             	adc    $0x0,%edx
  800e3f:	f7 da                	neg    %edx
  800e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e44:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e47:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e4e:	e9 bc 00 00 00       	jmp    800f0f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e53:	83 ec 08             	sub    $0x8,%esp
  800e56:	ff 75 e8             	pushl  -0x18(%ebp)
  800e59:	8d 45 14             	lea    0x14(%ebp),%eax
  800e5c:	50                   	push   %eax
  800e5d:	e8 84 fc ff ff       	call   800ae6 <getuint>
  800e62:	83 c4 10             	add    $0x10,%esp
  800e65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e68:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e6b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e72:	e9 98 00 00 00       	jmp    800f0f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e77:	83 ec 08             	sub    $0x8,%esp
  800e7a:	ff 75 0c             	pushl  0xc(%ebp)
  800e7d:	6a 58                	push   $0x58
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	ff d0                	call   *%eax
  800e84:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e87:	83 ec 08             	sub    $0x8,%esp
  800e8a:	ff 75 0c             	pushl  0xc(%ebp)
  800e8d:	6a 58                	push   $0x58
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	ff d0                	call   *%eax
  800e94:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	6a 58                	push   $0x58
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
			break;
  800ea7:	e9 bc 00 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800eac:	83 ec 08             	sub    $0x8,%esp
  800eaf:	ff 75 0c             	pushl  0xc(%ebp)
  800eb2:	6a 30                	push   $0x30
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	ff d0                	call   *%eax
  800eb9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ebc:	83 ec 08             	sub    $0x8,%esp
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	6a 78                	push   $0x78
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	ff d0                	call   *%eax
  800ec9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ecc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecf:	83 c0 04             	add    $0x4,%eax
  800ed2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed8:	83 e8 04             	sub    $0x4,%eax
  800edb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ee7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eee:	eb 1f                	jmp    800f0f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ef0:	83 ec 08             	sub    $0x8,%esp
  800ef3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ef9:	50                   	push   %eax
  800efa:	e8 e7 fb ff ff       	call   800ae6 <getuint>
  800eff:	83 c4 10             	add    $0x10,%esp
  800f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f08:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f0f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f16:	83 ec 04             	sub    $0x4,%esp
  800f19:	52                   	push   %edx
  800f1a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f1d:	50                   	push   %eax
  800f1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800f21:	ff 75 f0             	pushl  -0x10(%ebp)
  800f24:	ff 75 0c             	pushl  0xc(%ebp)
  800f27:	ff 75 08             	pushl  0x8(%ebp)
  800f2a:	e8 00 fb ff ff       	call   800a2f <printnum>
  800f2f:	83 c4 20             	add    $0x20,%esp
			break;
  800f32:	eb 34                	jmp    800f68 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f34:	83 ec 08             	sub    $0x8,%esp
  800f37:	ff 75 0c             	pushl  0xc(%ebp)
  800f3a:	53                   	push   %ebx
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	ff d0                	call   *%eax
  800f40:	83 c4 10             	add    $0x10,%esp
			break;
  800f43:	eb 23                	jmp    800f68 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f45:	83 ec 08             	sub    $0x8,%esp
  800f48:	ff 75 0c             	pushl  0xc(%ebp)
  800f4b:	6a 25                	push   $0x25
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	ff d0                	call   *%eax
  800f52:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f55:	ff 4d 10             	decl   0x10(%ebp)
  800f58:	eb 03                	jmp    800f5d <vprintfmt+0x3b1>
  800f5a:	ff 4d 10             	decl   0x10(%ebp)
  800f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f60:	48                   	dec    %eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 25                	cmp    $0x25,%al
  800f65:	75 f3                	jne    800f5a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f67:	90                   	nop
		}
	}
  800f68:	e9 47 fc ff ff       	jmp    800bb4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f6d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    

00800f75 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f7b:	8d 45 10             	lea    0x10(%ebp),%eax
  800f7e:	83 c0 04             	add    $0x4,%eax
  800f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f84:	8b 45 10             	mov    0x10(%ebp),%eax
  800f87:	ff 75 f4             	pushl  -0xc(%ebp)
  800f8a:	50                   	push   %eax
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	ff 75 08             	pushl  0x8(%ebp)
  800f91:	e8 16 fc ff ff       	call   800bac <vprintfmt>
  800f96:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f99:	90                   	nop
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	8b 40 08             	mov    0x8(%eax),%eax
  800fa5:	8d 50 01             	lea    0x1(%eax),%edx
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	8b 10                	mov    (%eax),%edx
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	8b 40 04             	mov    0x4(%eax),%eax
  800fb9:	39 c2                	cmp    %eax,%edx
  800fbb:	73 12                	jae    800fcf <sprintputch+0x33>
		*b->buf++ = ch;
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	8b 00                	mov    (%eax),%eax
  800fc2:	8d 48 01             	lea    0x1(%eax),%ecx
  800fc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc8:	89 0a                	mov    %ecx,(%edx)
  800fca:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcd:	88 10                	mov    %dl,(%eax)
}
  800fcf:	90                   	nop
  800fd0:	5d                   	pop    %ebp
  800fd1:	c3                   	ret    

00800fd2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	01 d0                	add    %edx,%eax
  800fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ff3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ff7:	74 06                	je     800fff <vsnprintf+0x2d>
  800ff9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ffd:	7f 07                	jg     801006 <vsnprintf+0x34>
		return -E_INVAL;
  800fff:	b8 03 00 00 00       	mov    $0x3,%eax
  801004:	eb 20                	jmp    801026 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801006:	ff 75 14             	pushl  0x14(%ebp)
  801009:	ff 75 10             	pushl  0x10(%ebp)
  80100c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80100f:	50                   	push   %eax
  801010:	68 9c 0f 80 00       	push   $0x800f9c
  801015:	e8 92 fb ff ff       	call   800bac <vprintfmt>
  80101a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80101d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801020:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801023:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80102e:	8d 45 10             	lea    0x10(%ebp),%eax
  801031:	83 c0 04             	add    $0x4,%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801037:	8b 45 10             	mov    0x10(%ebp),%eax
  80103a:	ff 75 f4             	pushl  -0xc(%ebp)
  80103d:	50                   	push   %eax
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	ff 75 08             	pushl  0x8(%ebp)
  801044:	e8 89 ff ff ff       	call   800fd2 <vsnprintf>
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80104f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80105a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801061:	eb 06                	jmp    801069 <strlen+0x15>
		n++;
  801063:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801066:	ff 45 08             	incl   0x8(%ebp)
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	84 c0                	test   %al,%al
  801070:	75 f1                	jne    801063 <strlen+0xf>
		n++;
	return n;
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801075:	c9                   	leave  
  801076:	c3                   	ret    

00801077 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80107d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801084:	eb 09                	jmp    80108f <strnlen+0x18>
		n++;
  801086:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801089:	ff 45 08             	incl   0x8(%ebp)
  80108c:	ff 4d 0c             	decl   0xc(%ebp)
  80108f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801093:	74 09                	je     80109e <strnlen+0x27>
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	84 c0                	test   %al,%al
  80109c:	75 e8                	jne    801086 <strnlen+0xf>
		n++;
	return n;
  80109e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010a1:	c9                   	leave  
  8010a2:	c3                   	ret    

008010a3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010af:	90                   	nop
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	8d 50 01             	lea    0x1(%eax),%edx
  8010b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010c2:	8a 12                	mov    (%edx),%dl
  8010c4:	88 10                	mov    %dl,(%eax)
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	84 c0                	test   %al,%al
  8010ca:	75 e4                	jne    8010b0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010e4:	eb 1f                	jmp    801105 <strncpy+0x34>
		*dst++ = *src;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8d 50 01             	lea    0x1(%eax),%edx
  8010ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f2:	8a 12                	mov    (%edx),%dl
  8010f4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	84 c0                	test   %al,%al
  8010fd:	74 03                	je     801102 <strncpy+0x31>
			src++;
  8010ff:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801102:	ff 45 fc             	incl   -0x4(%ebp)
  801105:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801108:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110b:	72 d9                	jb     8010e6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80110d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80111e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801122:	74 30                	je     801154 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801124:	eb 16                	jmp    80113c <strlcpy+0x2a>
			*dst++ = *src++;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8d 50 01             	lea    0x1(%eax),%edx
  80112c:	89 55 08             	mov    %edx,0x8(%ebp)
  80112f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801132:	8d 4a 01             	lea    0x1(%edx),%ecx
  801135:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801138:	8a 12                	mov    (%edx),%dl
  80113a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80113c:	ff 4d 10             	decl   0x10(%ebp)
  80113f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801143:	74 09                	je     80114e <strlcpy+0x3c>
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	84 c0                	test   %al,%al
  80114c:	75 d8                	jne    801126 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801154:	8b 55 08             	mov    0x8(%ebp),%edx
  801157:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115a:	29 c2                	sub    %eax,%edx
  80115c:	89 d0                	mov    %edx,%eax
}
  80115e:	c9                   	leave  
  80115f:	c3                   	ret    

00801160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801163:	eb 06                	jmp    80116b <strcmp+0xb>
		p++, q++;
  801165:	ff 45 08             	incl   0x8(%ebp)
  801168:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	84 c0                	test   %al,%al
  801172:	74 0e                	je     801182 <strcmp+0x22>
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 10                	mov    (%eax),%dl
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	38 c2                	cmp    %al,%dl
  801180:	74 e3                	je     801165 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	0f b6 d0             	movzbl %al,%edx
  80118a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	0f b6 c0             	movzbl %al,%eax
  801192:	29 c2                	sub    %eax,%edx
  801194:	89 d0                	mov    %edx,%eax
}
  801196:	5d                   	pop    %ebp
  801197:	c3                   	ret    

00801198 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80119b:	eb 09                	jmp    8011a6 <strncmp+0xe>
		n--, p++, q++;
  80119d:	ff 4d 10             	decl   0x10(%ebp)
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011aa:	74 17                	je     8011c3 <strncmp+0x2b>
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	84 c0                	test   %al,%al
  8011b3:	74 0e                	je     8011c3 <strncmp+0x2b>
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 10                	mov    (%eax),%dl
  8011ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	38 c2                	cmp    %al,%dl
  8011c1:	74 da                	je     80119d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c7:	75 07                	jne    8011d0 <strncmp+0x38>
		return 0;
  8011c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ce:	eb 14                	jmp    8011e4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	0f b6 d0             	movzbl %al,%edx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	0f b6 c0             	movzbl %al,%eax
  8011e0:	29 c2                	sub    %eax,%edx
  8011e2:	89 d0                	mov    %edx,%eax
}
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    

008011e6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	83 ec 04             	sub    $0x4,%esp
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011f2:	eb 12                	jmp    801206 <strchr+0x20>
		if (*s == c)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011fc:	75 05                	jne    801203 <strchr+0x1d>
			return (char *) s;
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	eb 11                	jmp    801214 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	84 c0                	test   %al,%al
  80120d:	75 e5                	jne    8011f4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80120f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 04             	sub    $0x4,%esp
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801222:	eb 0d                	jmp    801231 <strfind+0x1b>
		if (*s == c)
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80122c:	74 0e                	je     80123c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80122e:	ff 45 08             	incl   0x8(%ebp)
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	84 c0                	test   %al,%al
  801238:	75 ea                	jne    801224 <strfind+0xe>
  80123a:	eb 01                	jmp    80123d <strfind+0x27>
		if (*s == c)
			break;
  80123c:	90                   	nop
	return (char *) s;
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80124e:	8b 45 10             	mov    0x10(%ebp),%eax
  801251:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801254:	eb 0e                	jmp    801264 <memset+0x22>
		*p++ = c;
  801256:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801259:	8d 50 01             	lea    0x1(%eax),%edx
  80125c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80125f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801262:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801264:	ff 4d f8             	decl   -0x8(%ebp)
  801267:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80126b:	79 e9                	jns    801256 <memset+0x14>
		*p++ = c;

	return v;
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801284:	eb 16                	jmp    80129c <memcpy+0x2a>
		*d++ = *s++;
  801286:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801289:	8d 50 01             	lea    0x1(%eax),%edx
  80128c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80128f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801292:	8d 4a 01             	lea    0x1(%edx),%ecx
  801295:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801298:	8a 12                	mov    (%edx),%dl
  80129a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	75 dd                	jne    801286 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012c6:	73 50                	jae    801318 <memmove+0x6a>
  8012c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012d3:	76 43                	jbe    801318 <memmove+0x6a>
		s += n;
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012db:	8b 45 10             	mov    0x10(%ebp),%eax
  8012de:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012e1:	eb 10                	jmp    8012f3 <memmove+0x45>
			*--d = *--s;
  8012e3:	ff 4d f8             	decl   -0x8(%ebp)
  8012e6:	ff 4d fc             	decl   -0x4(%ebp)
  8012e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ec:	8a 10                	mov    (%eax),%dl
  8012ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	75 e3                	jne    8012e3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801300:	eb 23                	jmp    801325 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801302:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801305:	8d 50 01             	lea    0x1(%eax),%edx
  801308:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80130b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801311:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801314:	8a 12                	mov    (%edx),%dl
  801316:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801318:	8b 45 10             	mov    0x10(%ebp),%eax
  80131b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131e:	89 55 10             	mov    %edx,0x10(%ebp)
  801321:	85 c0                	test   %eax,%eax
  801323:	75 dd                	jne    801302 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80133c:	eb 2a                	jmp    801368 <memcmp+0x3e>
		if (*s1 != *s2)
  80133e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801341:	8a 10                	mov    (%eax),%dl
  801343:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801346:	8a 00                	mov    (%eax),%al
  801348:	38 c2                	cmp    %al,%dl
  80134a:	74 16                	je     801362 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80134c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	0f b6 d0             	movzbl %al,%edx
  801354:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801357:	8a 00                	mov    (%eax),%al
  801359:	0f b6 c0             	movzbl %al,%eax
  80135c:	29 c2                	sub    %eax,%edx
  80135e:	89 d0                	mov    %edx,%eax
  801360:	eb 18                	jmp    80137a <memcmp+0x50>
		s1++, s2++;
  801362:	ff 45 fc             	incl   -0x4(%ebp)
  801365:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80136e:	89 55 10             	mov    %edx,0x10(%ebp)
  801371:	85 c0                	test   %eax,%eax
  801373:	75 c9                	jne    80133e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801382:	8b 55 08             	mov    0x8(%ebp),%edx
  801385:	8b 45 10             	mov    0x10(%ebp),%eax
  801388:	01 d0                	add    %edx,%eax
  80138a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80138d:	eb 15                	jmp    8013a4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	0f b6 d0             	movzbl %al,%edx
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	0f b6 c0             	movzbl %al,%eax
  80139d:	39 c2                	cmp    %eax,%edx
  80139f:	74 0d                	je     8013ae <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013a1:	ff 45 08             	incl   0x8(%ebp)
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013aa:	72 e3                	jb     80138f <memfind+0x13>
  8013ac:	eb 01                	jmp    8013af <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013ae:	90                   	nop
	return (void *) s;
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013c8:	eb 03                	jmp    8013cd <strtol+0x19>
		s++;
  8013ca:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	3c 20                	cmp    $0x20,%al
  8013d4:	74 f4                	je     8013ca <strtol+0x16>
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8a 00                	mov    (%eax),%al
  8013db:	3c 09                	cmp    $0x9,%al
  8013dd:	74 eb                	je     8013ca <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	3c 2b                	cmp    $0x2b,%al
  8013e6:	75 05                	jne    8013ed <strtol+0x39>
		s++;
  8013e8:	ff 45 08             	incl   0x8(%ebp)
  8013eb:	eb 13                	jmp    801400 <strtol+0x4c>
	else if (*s == '-')
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	3c 2d                	cmp    $0x2d,%al
  8013f4:	75 0a                	jne    801400 <strtol+0x4c>
		s++, neg = 1;
  8013f6:	ff 45 08             	incl   0x8(%ebp)
  8013f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801400:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801404:	74 06                	je     80140c <strtol+0x58>
  801406:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80140a:	75 20                	jne    80142c <strtol+0x78>
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	3c 30                	cmp    $0x30,%al
  801413:	75 17                	jne    80142c <strtol+0x78>
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	40                   	inc    %eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	3c 78                	cmp    $0x78,%al
  80141d:	75 0d                	jne    80142c <strtol+0x78>
		s += 2, base = 16;
  80141f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801423:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80142a:	eb 28                	jmp    801454 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80142c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801430:	75 15                	jne    801447 <strtol+0x93>
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3c 30                	cmp    $0x30,%al
  801439:	75 0c                	jne    801447 <strtol+0x93>
		s++, base = 8;
  80143b:	ff 45 08             	incl   0x8(%ebp)
  80143e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801445:	eb 0d                	jmp    801454 <strtol+0xa0>
	else if (base == 0)
  801447:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144b:	75 07                	jne    801454 <strtol+0xa0>
		base = 10;
  80144d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	3c 2f                	cmp    $0x2f,%al
  80145b:	7e 19                	jle    801476 <strtol+0xc2>
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	3c 39                	cmp    $0x39,%al
  801464:	7f 10                	jg     801476 <strtol+0xc2>
			dig = *s - '0';
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	0f be c0             	movsbl %al,%eax
  80146e:	83 e8 30             	sub    $0x30,%eax
  801471:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801474:	eb 42                	jmp    8014b8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	3c 60                	cmp    $0x60,%al
  80147d:	7e 19                	jle    801498 <strtol+0xe4>
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	3c 7a                	cmp    $0x7a,%al
  801486:	7f 10                	jg     801498 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8a 00                	mov    (%eax),%al
  80148d:	0f be c0             	movsbl %al,%eax
  801490:	83 e8 57             	sub    $0x57,%eax
  801493:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801496:	eb 20                	jmp    8014b8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	3c 40                	cmp    $0x40,%al
  80149f:	7e 39                	jle    8014da <strtol+0x126>
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	3c 5a                	cmp    $0x5a,%al
  8014a8:	7f 30                	jg     8014da <strtol+0x126>
			dig = *s - 'A' + 10;
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	0f be c0             	movsbl %al,%eax
  8014b2:	83 e8 37             	sub    $0x37,%eax
  8014b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014be:	7d 19                	jge    8014d9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014c0:	ff 45 08             	incl   0x8(%ebp)
  8014c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014ca:	89 c2                	mov    %eax,%edx
  8014cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014cf:	01 d0                	add    %edx,%eax
  8014d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014d4:	e9 7b ff ff ff       	jmp    801454 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014d9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014de:	74 08                	je     8014e8 <strtol+0x134>
		*endptr = (char *) s;
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014ec:	74 07                	je     8014f5 <strtol+0x141>
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	f7 d8                	neg    %eax
  8014f3:	eb 03                	jmp    8014f8 <strtol+0x144>
  8014f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <ltostr>:

void
ltostr(long value, char *str)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801500:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801507:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80150e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801512:	79 13                	jns    801527 <ltostr+0x2d>
	{
		neg = 1;
  801514:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80151b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801521:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801524:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80152f:	99                   	cltd   
  801530:	f7 f9                	idiv   %ecx
  801532:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801535:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801538:	8d 50 01             	lea    0x1(%eax),%edx
  80153b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80153e:	89 c2                	mov    %eax,%edx
  801540:	8b 45 0c             	mov    0xc(%ebp),%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801548:	83 c2 30             	add    $0x30,%edx
  80154b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80154d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801550:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801555:	f7 e9                	imul   %ecx
  801557:	c1 fa 02             	sar    $0x2,%edx
  80155a:	89 c8                	mov    %ecx,%eax
  80155c:	c1 f8 1f             	sar    $0x1f,%eax
  80155f:	29 c2                	sub    %eax,%edx
  801561:	89 d0                	mov    %edx,%eax
  801563:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801566:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801569:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80156e:	f7 e9                	imul   %ecx
  801570:	c1 fa 02             	sar    $0x2,%edx
  801573:	89 c8                	mov    %ecx,%eax
  801575:	c1 f8 1f             	sar    $0x1f,%eax
  801578:	29 c2                	sub    %eax,%edx
  80157a:	89 d0                	mov    %edx,%eax
  80157c:	c1 e0 02             	shl    $0x2,%eax
  80157f:	01 d0                	add    %edx,%eax
  801581:	01 c0                	add    %eax,%eax
  801583:	29 c1                	sub    %eax,%ecx
  801585:	89 ca                	mov    %ecx,%edx
  801587:	85 d2                	test   %edx,%edx
  801589:	75 9c                	jne    801527 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80158b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801592:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801595:	48                   	dec    %eax
  801596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801599:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80159d:	74 3d                	je     8015dc <ltostr+0xe2>
		start = 1 ;
  80159f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015a6:	eb 34                	jmp    8015dc <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	01 d0                	add    %edx,%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	01 c2                	add    %eax,%edx
  8015bd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c3:	01 c8                	add    %ecx,%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	01 c2                	add    %eax,%edx
  8015d1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015d4:	88 02                	mov    %al,(%edx)
		start++ ;
  8015d6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015d9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e2:	7c c4                	jl     8015a8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ea:	01 d0                	add    %edx,%eax
  8015ec:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015ef:	90                   	nop
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015f8:	ff 75 08             	pushl  0x8(%ebp)
  8015fb:	e8 54 fa ff ff       	call   801054 <strlen>
  801600:	83 c4 04             	add    $0x4,%esp
  801603:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801606:	ff 75 0c             	pushl  0xc(%ebp)
  801609:	e8 46 fa ff ff       	call   801054 <strlen>
  80160e:	83 c4 04             	add    $0x4,%esp
  801611:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801614:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80161b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801622:	eb 17                	jmp    80163b <strcconcat+0x49>
		final[s] = str1[s] ;
  801624:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801627:	8b 45 10             	mov    0x10(%ebp),%eax
  80162a:	01 c2                	add    %eax,%edx
  80162c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	01 c8                	add    %ecx,%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801638:	ff 45 fc             	incl   -0x4(%ebp)
  80163b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801641:	7c e1                	jl     801624 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801643:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80164a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801651:	eb 1f                	jmp    801672 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801653:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801656:	8d 50 01             	lea    0x1(%eax),%edx
  801659:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80165c:	89 c2                	mov    %eax,%edx
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	01 c2                	add    %eax,%edx
  801663:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	01 c8                	add    %ecx,%eax
  80166b:	8a 00                	mov    (%eax),%al
  80166d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80166f:	ff 45 f8             	incl   -0x8(%ebp)
  801672:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801675:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801678:	7c d9                	jl     801653 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80167a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167d:	8b 45 10             	mov    0x10(%ebp),%eax
  801680:	01 d0                	add    %edx,%eax
  801682:	c6 00 00             	movb   $0x0,(%eax)
}
  801685:	90                   	nop
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80168b:	8b 45 14             	mov    0x14(%ebp),%eax
  80168e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801694:	8b 45 14             	mov    0x14(%ebp),%eax
  801697:	8b 00                	mov    (%eax),%eax
  801699:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a3:	01 d0                	add    %edx,%eax
  8016a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016ab:	eb 0c                	jmp    8016b9 <strsplit+0x31>
			*string++ = 0;
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8d 50 01             	lea    0x1(%eax),%edx
  8016b3:	89 55 08             	mov    %edx,0x8(%ebp)
  8016b6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8a 00                	mov    (%eax),%al
  8016be:	84 c0                	test   %al,%al
  8016c0:	74 18                	je     8016da <strsplit+0x52>
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8a 00                	mov    (%eax),%al
  8016c7:	0f be c0             	movsbl %al,%eax
  8016ca:	50                   	push   %eax
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	e8 13 fb ff ff       	call   8011e6 <strchr>
  8016d3:	83 c4 08             	add    $0x8,%esp
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	75 d3                	jne    8016ad <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	84 c0                	test   %al,%al
  8016e1:	74 5a                	je     80173d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e6:	8b 00                	mov    (%eax),%eax
  8016e8:	83 f8 0f             	cmp    $0xf,%eax
  8016eb:	75 07                	jne    8016f4 <strsplit+0x6c>
		{
			return 0;
  8016ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f2:	eb 66                	jmp    80175a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f7:	8b 00                	mov    (%eax),%eax
  8016f9:	8d 48 01             	lea    0x1(%eax),%ecx
  8016fc:	8b 55 14             	mov    0x14(%ebp),%edx
  8016ff:	89 0a                	mov    %ecx,(%edx)
  801701:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801708:	8b 45 10             	mov    0x10(%ebp),%eax
  80170b:	01 c2                	add    %eax,%edx
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801712:	eb 03                	jmp    801717 <strsplit+0x8f>
			string++;
  801714:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	84 c0                	test   %al,%al
  80171e:	74 8b                	je     8016ab <strsplit+0x23>
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	8a 00                	mov    (%eax),%al
  801725:	0f be c0             	movsbl %al,%eax
  801728:	50                   	push   %eax
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	e8 b5 fa ff ff       	call   8011e6 <strchr>
  801731:	83 c4 08             	add    $0x8,%esp
  801734:	85 c0                	test   %eax,%eax
  801736:	74 dc                	je     801714 <strsplit+0x8c>
			string++;
	}
  801738:	e9 6e ff ff ff       	jmp    8016ab <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80173d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80173e:	8b 45 14             	mov    0x14(%ebp),%eax
  801741:	8b 00                	mov    (%eax),%eax
  801743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80174a:	8b 45 10             	mov    0x10(%ebp),%eax
  80174d:	01 d0                	add    %edx,%eax
  80174f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801755:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801762:	a1 04 50 80 00       	mov    0x805004,%eax
  801767:	85 c0                	test   %eax,%eax
  801769:	74 1f                	je     80178a <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80176b:	e8 1d 00 00 00       	call   80178d <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801770:	83 ec 0c             	sub    $0xc,%esp
  801773:	68 30 3e 80 00       	push   $0x803e30
  801778:	e8 55 f2 ff ff       	call   8009d2 <cprintf>
  80177d:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801780:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801787:	00 00 00 
	}
}
  80178a:	90                   	nop
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801793:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80179a:	00 00 00 
  80179d:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8017a4:	00 00 00 
  8017a7:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8017ae:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  8017b1:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8017b8:	00 00 00 
  8017bb:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8017c2:	00 00 00 
  8017c5:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8017cc:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  8017cf:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8017d6:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  8017d9:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8017e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017e8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017ed:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  8017f2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017f9:	a1 20 51 80 00       	mov    0x805120,%eax
  8017fe:	c1 e0 04             	shl    $0x4,%eax
  801801:	89 c2                	mov    %eax,%edx
  801803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801806:	01 d0                	add    %edx,%eax
  801808:	48                   	dec    %eax
  801809:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80180c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80180f:	ba 00 00 00 00       	mov    $0x0,%edx
  801814:	f7 75 f0             	divl   -0x10(%ebp)
  801817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80181a:	29 d0                	sub    %edx,%eax
  80181c:	89 c2                	mov    %eax,%edx
  80181e:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801825:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801828:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80182d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801832:	83 ec 04             	sub    $0x4,%esp
  801835:	6a 06                	push   $0x6
  801837:	52                   	push   %edx
  801838:	50                   	push   %eax
  801839:	e8 71 05 00 00       	call   801daf <sys_allocate_chunk>
  80183e:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801841:	a1 20 51 80 00       	mov    0x805120,%eax
  801846:	83 ec 0c             	sub    $0xc,%esp
  801849:	50                   	push   %eax
  80184a:	e8 e6 0b 00 00       	call   802435 <initialize_MemBlocksList>
  80184f:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801852:	a1 48 51 80 00       	mov    0x805148,%eax
  801857:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  80185a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80185e:	75 14                	jne    801874 <initialize_dyn_block_system+0xe7>
  801860:	83 ec 04             	sub    $0x4,%esp
  801863:	68 55 3e 80 00       	push   $0x803e55
  801868:	6a 2b                	push   $0x2b
  80186a:	68 73 3e 80 00       	push   $0x803e73
  80186f:	e8 aa ee ff ff       	call   80071e <_panic>
  801874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801877:	8b 00                	mov    (%eax),%eax
  801879:	85 c0                	test   %eax,%eax
  80187b:	74 10                	je     80188d <initialize_dyn_block_system+0x100>
  80187d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801880:	8b 00                	mov    (%eax),%eax
  801882:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801885:	8b 52 04             	mov    0x4(%edx),%edx
  801888:	89 50 04             	mov    %edx,0x4(%eax)
  80188b:	eb 0b                	jmp    801898 <initialize_dyn_block_system+0x10b>
  80188d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801890:	8b 40 04             	mov    0x4(%eax),%eax
  801893:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801898:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80189b:	8b 40 04             	mov    0x4(%eax),%eax
  80189e:	85 c0                	test   %eax,%eax
  8018a0:	74 0f                	je     8018b1 <initialize_dyn_block_system+0x124>
  8018a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018a5:	8b 40 04             	mov    0x4(%eax),%eax
  8018a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018ab:	8b 12                	mov    (%edx),%edx
  8018ad:	89 10                	mov    %edx,(%eax)
  8018af:	eb 0a                	jmp    8018bb <initialize_dyn_block_system+0x12e>
  8018b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018b4:	8b 00                	mov    (%eax),%eax
  8018b6:	a3 48 51 80 00       	mov    %eax,0x805148
  8018bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018ce:	a1 54 51 80 00       	mov    0x805154,%eax
  8018d3:	48                   	dec    %eax
  8018d4:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  8018d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018dc:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  8018e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018e6:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  8018ed:	83 ec 0c             	sub    $0xc,%esp
  8018f0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018f3:	e8 d2 13 00 00       	call   802cca <insert_sorted_with_merge_freeList>
  8018f8:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8018fb:	90                   	nop
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801904:	e8 53 fe ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  801909:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80190d:	75 07                	jne    801916 <malloc+0x18>
  80190f:	b8 00 00 00 00       	mov    $0x0,%eax
  801914:	eb 61                	jmp    801977 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801916:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80191d:	8b 55 08             	mov    0x8(%ebp),%edx
  801920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801923:	01 d0                	add    %edx,%eax
  801925:	48                   	dec    %eax
  801926:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192c:	ba 00 00 00 00       	mov    $0x0,%edx
  801931:	f7 75 f4             	divl   -0xc(%ebp)
  801934:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801937:	29 d0                	sub    %edx,%eax
  801939:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80193c:	e8 3c 08 00 00       	call   80217d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801941:	85 c0                	test   %eax,%eax
  801943:	74 2d                	je     801972 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801945:	83 ec 0c             	sub    $0xc,%esp
  801948:	ff 75 08             	pushl  0x8(%ebp)
  80194b:	e8 3e 0f 00 00       	call   80288e <alloc_block_FF>
  801950:	83 c4 10             	add    $0x10,%esp
  801953:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801956:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80195a:	74 16                	je     801972 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  80195c:	83 ec 0c             	sub    $0xc,%esp
  80195f:	ff 75 ec             	pushl  -0x14(%ebp)
  801962:	e8 48 0c 00 00       	call   8025af <insert_sorted_allocList>
  801967:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  80196a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80196d:	8b 40 08             	mov    0x8(%eax),%eax
  801970:	eb 05                	jmp    801977 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801972:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801988:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80198d:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	83 ec 08             	sub    $0x8,%esp
  801996:	50                   	push   %eax
  801997:	68 40 50 80 00       	push   $0x805040
  80199c:	e8 71 0b 00 00       	call   802512 <find_block>
  8019a1:	83 c4 10             	add    $0x10,%esp
  8019a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  8019a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019aa:	8b 50 0c             	mov    0xc(%eax),%edx
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	83 ec 08             	sub    $0x8,%esp
  8019b3:	52                   	push   %edx
  8019b4:	50                   	push   %eax
  8019b5:	e8 bd 03 00 00       	call   801d77 <sys_free_user_mem>
  8019ba:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  8019bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019c1:	75 14                	jne    8019d7 <free+0x5e>
  8019c3:	83 ec 04             	sub    $0x4,%esp
  8019c6:	68 55 3e 80 00       	push   $0x803e55
  8019cb:	6a 71                	push   $0x71
  8019cd:	68 73 3e 80 00       	push   $0x803e73
  8019d2:	e8 47 ed ff ff       	call   80071e <_panic>
  8019d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019da:	8b 00                	mov    (%eax),%eax
  8019dc:	85 c0                	test   %eax,%eax
  8019de:	74 10                	je     8019f0 <free+0x77>
  8019e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e3:	8b 00                	mov    (%eax),%eax
  8019e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019e8:	8b 52 04             	mov    0x4(%edx),%edx
  8019eb:	89 50 04             	mov    %edx,0x4(%eax)
  8019ee:	eb 0b                	jmp    8019fb <free+0x82>
  8019f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f3:	8b 40 04             	mov    0x4(%eax),%eax
  8019f6:	a3 44 50 80 00       	mov    %eax,0x805044
  8019fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fe:	8b 40 04             	mov    0x4(%eax),%eax
  801a01:	85 c0                	test   %eax,%eax
  801a03:	74 0f                	je     801a14 <free+0x9b>
  801a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a08:	8b 40 04             	mov    0x4(%eax),%eax
  801a0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a0e:	8b 12                	mov    (%edx),%edx
  801a10:	89 10                	mov    %edx,(%eax)
  801a12:	eb 0a                	jmp    801a1e <free+0xa5>
  801a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a17:	8b 00                	mov    (%eax),%eax
  801a19:	a3 40 50 80 00       	mov    %eax,0x805040
  801a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a31:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a36:	48                   	dec    %eax
  801a37:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801a3c:	83 ec 0c             	sub    $0xc,%esp
  801a3f:	ff 75 f0             	pushl  -0x10(%ebp)
  801a42:	e8 83 12 00 00       	call   802cca <insert_sorted_with_merge_freeList>
  801a47:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801a4a:	90                   	nop
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	83 ec 28             	sub    $0x28,%esp
  801a53:	8b 45 10             	mov    0x10(%ebp),%eax
  801a56:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a59:	e8 fe fc ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  801a5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a62:	75 0a                	jne    801a6e <smalloc+0x21>
  801a64:	b8 00 00 00 00       	mov    $0x0,%eax
  801a69:	e9 86 00 00 00       	jmp    801af4 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801a6e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801a75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7b:	01 d0                	add    %edx,%eax
  801a7d:	48                   	dec    %eax
  801a7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a84:	ba 00 00 00 00       	mov    $0x0,%edx
  801a89:	f7 75 f4             	divl   -0xc(%ebp)
  801a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8f:	29 d0                	sub    %edx,%eax
  801a91:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801a94:	e8 e4 06 00 00       	call   80217d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a99:	85 c0                	test   %eax,%eax
  801a9b:	74 52                	je     801aef <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801a9d:	83 ec 0c             	sub    $0xc,%esp
  801aa0:	ff 75 0c             	pushl  0xc(%ebp)
  801aa3:	e8 e6 0d 00 00       	call   80288e <alloc_block_FF>
  801aa8:	83 c4 10             	add    $0x10,%esp
  801aab:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801aae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ab2:	75 07                	jne    801abb <smalloc+0x6e>
			return NULL ;
  801ab4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab9:	eb 39                	jmp    801af4 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801abb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801abe:	8b 40 08             	mov    0x8(%eax),%eax
  801ac1:	89 c2                	mov    %eax,%edx
  801ac3:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801ac7:	52                   	push   %edx
  801ac8:	50                   	push   %eax
  801ac9:	ff 75 0c             	pushl  0xc(%ebp)
  801acc:	ff 75 08             	pushl  0x8(%ebp)
  801acf:	e8 2e 04 00 00       	call   801f02 <sys_createSharedObject>
  801ad4:	83 c4 10             	add    $0x10,%esp
  801ad7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801ada:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ade:	79 07                	jns    801ae7 <smalloc+0x9a>
			return (void*)NULL ;
  801ae0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae5:	eb 0d                	jmp    801af4 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aea:	8b 40 08             	mov    0x8(%eax),%eax
  801aed:	eb 05                	jmp    801af4 <smalloc+0xa7>
		}
		return (void*)NULL ;
  801aef:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801afc:	e8 5b fc ff ff       	call   80175c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b01:	83 ec 08             	sub    $0x8,%esp
  801b04:	ff 75 0c             	pushl  0xc(%ebp)
  801b07:	ff 75 08             	pushl  0x8(%ebp)
  801b0a:	e8 1d 04 00 00       	call   801f2c <sys_getSizeOfSharedObject>
  801b0f:	83 c4 10             	add    $0x10,%esp
  801b12:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801b15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b19:	75 0a                	jne    801b25 <sget+0x2f>
			return NULL ;
  801b1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b20:	e9 83 00 00 00       	jmp    801ba8 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801b25:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b32:	01 d0                	add    %edx,%eax
  801b34:	48                   	dec    %eax
  801b35:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b40:	f7 75 f0             	divl   -0x10(%ebp)
  801b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b46:	29 d0                	sub    %edx,%eax
  801b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b4b:	e8 2d 06 00 00       	call   80217d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b50:	85 c0                	test   %eax,%eax
  801b52:	74 4f                	je     801ba3 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b57:	83 ec 0c             	sub    $0xc,%esp
  801b5a:	50                   	push   %eax
  801b5b:	e8 2e 0d 00 00       	call   80288e <alloc_block_FF>
  801b60:	83 c4 10             	add    $0x10,%esp
  801b63:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801b66:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b6a:	75 07                	jne    801b73 <sget+0x7d>
					return (void*)NULL ;
  801b6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b71:	eb 35                	jmp    801ba8 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b76:	8b 40 08             	mov    0x8(%eax),%eax
  801b79:	83 ec 04             	sub    $0x4,%esp
  801b7c:	50                   	push   %eax
  801b7d:	ff 75 0c             	pushl  0xc(%ebp)
  801b80:	ff 75 08             	pushl  0x8(%ebp)
  801b83:	e8 c1 03 00 00       	call   801f49 <sys_getSharedObject>
  801b88:	83 c4 10             	add    $0x10,%esp
  801b8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801b8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b92:	79 07                	jns    801b9b <sget+0xa5>
				return (void*)NULL ;
  801b94:	b8 00 00 00 00       	mov    $0x0,%eax
  801b99:	eb 0d                	jmp    801ba8 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801b9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b9e:	8b 40 08             	mov    0x8(%eax),%eax
  801ba1:	eb 05                	jmp    801ba8 <sget+0xb2>


		}
	return (void*)NULL ;
  801ba3:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bb0:	e8 a7 fb ff ff       	call   80175c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801bb5:	83 ec 04             	sub    $0x4,%esp
  801bb8:	68 80 3e 80 00       	push   $0x803e80
  801bbd:	68 f9 00 00 00       	push   $0xf9
  801bc2:	68 73 3e 80 00       	push   $0x803e73
  801bc7:	e8 52 eb ff ff       	call   80071e <_panic>

00801bcc <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801bd2:	83 ec 04             	sub    $0x4,%esp
  801bd5:	68 a8 3e 80 00       	push   $0x803ea8
  801bda:	68 0d 01 00 00       	push   $0x10d
  801bdf:	68 73 3e 80 00       	push   $0x803e73
  801be4:	e8 35 eb ff ff       	call   80071e <_panic>

00801be9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bef:	83 ec 04             	sub    $0x4,%esp
  801bf2:	68 cc 3e 80 00       	push   $0x803ecc
  801bf7:	68 18 01 00 00       	push   $0x118
  801bfc:	68 73 3e 80 00       	push   $0x803e73
  801c01:	e8 18 eb ff ff       	call   80071e <_panic>

00801c06 <shrink>:

}
void shrink(uint32 newSize)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c0c:	83 ec 04             	sub    $0x4,%esp
  801c0f:	68 cc 3e 80 00       	push   $0x803ecc
  801c14:	68 1d 01 00 00       	push   $0x11d
  801c19:	68 73 3e 80 00       	push   $0x803e73
  801c1e:	e8 fb ea ff ff       	call   80071e <_panic>

00801c23 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c29:	83 ec 04             	sub    $0x4,%esp
  801c2c:	68 cc 3e 80 00       	push   $0x803ecc
  801c31:	68 22 01 00 00       	push   $0x122
  801c36:	68 73 3e 80 00       	push   $0x803e73
  801c3b:	e8 de ea ff ff       	call   80071e <_panic>

00801c40 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	57                   	push   %edi
  801c44:	56                   	push   %esi
  801c45:	53                   	push   %ebx
  801c46:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c52:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c55:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c58:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c5b:	cd 30                	int    $0x30
  801c5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c63:	83 c4 10             	add    $0x10,%esp
  801c66:	5b                   	pop    %ebx
  801c67:	5e                   	pop    %esi
  801c68:	5f                   	pop    %edi
  801c69:	5d                   	pop    %ebp
  801c6a:	c3                   	ret    

00801c6b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	83 ec 04             	sub    $0x4,%esp
  801c71:	8b 45 10             	mov    0x10(%ebp),%eax
  801c74:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c77:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	52                   	push   %edx
  801c83:	ff 75 0c             	pushl  0xc(%ebp)
  801c86:	50                   	push   %eax
  801c87:	6a 00                	push   $0x0
  801c89:	e8 b2 ff ff ff       	call   801c40 <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
}
  801c91:	90                   	nop
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 01                	push   $0x1
  801ca3:	e8 98 ff ff ff       	call   801c40 <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	52                   	push   %edx
  801cbd:	50                   	push   %eax
  801cbe:	6a 05                	push   $0x5
  801cc0:	e8 7b ff ff ff       	call   801c40 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	56                   	push   %esi
  801cce:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ccf:	8b 75 18             	mov    0x18(%ebp),%esi
  801cd2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cd5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	56                   	push   %esi
  801cdf:	53                   	push   %ebx
  801ce0:	51                   	push   %ecx
  801ce1:	52                   	push   %edx
  801ce2:	50                   	push   %eax
  801ce3:	6a 06                	push   $0x6
  801ce5:	e8 56 ff ff ff       	call   801c40 <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
}
  801ced:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf0:	5b                   	pop    %ebx
  801cf1:	5e                   	pop    %esi
  801cf2:	5d                   	pop    %ebp
  801cf3:	c3                   	ret    

00801cf4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	52                   	push   %edx
  801d04:	50                   	push   %eax
  801d05:	6a 07                	push   $0x7
  801d07:	e8 34 ff ff ff       	call   801c40 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	ff 75 0c             	pushl  0xc(%ebp)
  801d1d:	ff 75 08             	pushl  0x8(%ebp)
  801d20:	6a 08                	push   $0x8
  801d22:	e8 19 ff ff ff       	call   801c40 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 09                	push   $0x9
  801d3b:	e8 00 ff ff ff       	call   801c40 <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 0a                	push   $0xa
  801d54:	e8 e7 fe ff ff       	call   801c40 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 0b                	push   $0xb
  801d6d:	e8 ce fe ff ff       	call   801c40 <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	ff 75 0c             	pushl  0xc(%ebp)
  801d83:	ff 75 08             	pushl  0x8(%ebp)
  801d86:	6a 0f                	push   $0xf
  801d88:	e8 b3 fe ff ff       	call   801c40 <syscall>
  801d8d:	83 c4 18             	add    $0x18,%esp
	return;
  801d90:	90                   	nop
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	ff 75 0c             	pushl  0xc(%ebp)
  801d9f:	ff 75 08             	pushl  0x8(%ebp)
  801da2:	6a 10                	push   $0x10
  801da4:	e8 97 fe ff ff       	call   801c40 <syscall>
  801da9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dac:	90                   	nop
}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	ff 75 10             	pushl  0x10(%ebp)
  801db9:	ff 75 0c             	pushl  0xc(%ebp)
  801dbc:	ff 75 08             	pushl  0x8(%ebp)
  801dbf:	6a 11                	push   $0x11
  801dc1:	e8 7a fe ff ff       	call   801c40 <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc9:	90                   	nop
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 0c                	push   $0xc
  801ddb:	e8 60 fe ff ff       	call   801c40 <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	ff 75 08             	pushl  0x8(%ebp)
  801df3:	6a 0d                	push   $0xd
  801df5:	e8 46 fe ff ff       	call   801c40 <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_scarce_memory>:

void sys_scarce_memory()
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 0e                	push   $0xe
  801e0e:	e8 2d fe ff ff       	call   801c40 <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
}
  801e16:	90                   	nop
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 13                	push   $0x13
  801e28:	e8 13 fe ff ff       	call   801c40 <syscall>
  801e2d:	83 c4 18             	add    $0x18,%esp
}
  801e30:	90                   	nop
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 14                	push   $0x14
  801e42:	e8 f9 fd ff ff       	call   801c40 <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
}
  801e4a:	90                   	nop
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_cputc>:


void
sys_cputc(const char c)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	83 ec 04             	sub    $0x4,%esp
  801e53:	8b 45 08             	mov    0x8(%ebp),%eax
  801e56:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e59:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	50                   	push   %eax
  801e66:	6a 15                	push   $0x15
  801e68:	e8 d3 fd ff ff       	call   801c40 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
}
  801e70:	90                   	nop
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 16                	push   $0x16
  801e82:	e8 b9 fd ff ff       	call   801c40 <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
}
  801e8a:	90                   	nop
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	ff 75 0c             	pushl  0xc(%ebp)
  801e9c:	50                   	push   %eax
  801e9d:	6a 17                	push   $0x17
  801e9f:	e8 9c fd ff ff       	call   801c40 <syscall>
  801ea4:	83 c4 18             	add    $0x18,%esp
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801eac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	52                   	push   %edx
  801eb9:	50                   	push   %eax
  801eba:	6a 1a                	push   $0x1a
  801ebc:	e8 7f fd ff ff       	call   801c40 <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ec9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	52                   	push   %edx
  801ed6:	50                   	push   %eax
  801ed7:	6a 18                	push   $0x18
  801ed9:	e8 62 fd ff ff       	call   801c40 <syscall>
  801ede:	83 c4 18             	add    $0x18,%esp
}
  801ee1:	90                   	nop
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ee7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	52                   	push   %edx
  801ef4:	50                   	push   %eax
  801ef5:	6a 19                	push   $0x19
  801ef7:	e8 44 fd ff ff       	call   801c40 <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
}
  801eff:	90                   	nop
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	83 ec 04             	sub    $0x4,%esp
  801f08:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f0e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f11:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	6a 00                	push   $0x0
  801f1a:	51                   	push   %ecx
  801f1b:	52                   	push   %edx
  801f1c:	ff 75 0c             	pushl  0xc(%ebp)
  801f1f:	50                   	push   %eax
  801f20:	6a 1b                	push   $0x1b
  801f22:	e8 19 fd ff ff       	call   801c40 <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f32:	8b 45 08             	mov    0x8(%ebp),%eax
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	52                   	push   %edx
  801f3c:	50                   	push   %eax
  801f3d:	6a 1c                	push   $0x1c
  801f3f:	e8 fc fc ff ff       	call   801c40 <syscall>
  801f44:	83 c4 18             	add    $0x18,%esp
}
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f4c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	51                   	push   %ecx
  801f5a:	52                   	push   %edx
  801f5b:	50                   	push   %eax
  801f5c:	6a 1d                	push   $0x1d
  801f5e:	e8 dd fc ff ff       	call   801c40 <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	52                   	push   %edx
  801f78:	50                   	push   %eax
  801f79:	6a 1e                	push   $0x1e
  801f7b:	e8 c0 fc ff ff       	call   801c40 <syscall>
  801f80:	83 c4 18             	add    $0x18,%esp
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 1f                	push   $0x1f
  801f94:	e8 a7 fc ff ff       	call   801c40 <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	6a 00                	push   $0x0
  801fa6:	ff 75 14             	pushl  0x14(%ebp)
  801fa9:	ff 75 10             	pushl  0x10(%ebp)
  801fac:	ff 75 0c             	pushl  0xc(%ebp)
  801faf:	50                   	push   %eax
  801fb0:	6a 20                	push   $0x20
  801fb2:	e8 89 fc ff ff       	call   801c40 <syscall>
  801fb7:	83 c4 18             	add    $0x18,%esp
}
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    

00801fbc <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	50                   	push   %eax
  801fcb:	6a 21                	push   $0x21
  801fcd:	e8 6e fc ff ff       	call   801c40 <syscall>
  801fd2:	83 c4 18             	add    $0x18,%esp
}
  801fd5:	90                   	nop
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	50                   	push   %eax
  801fe7:	6a 22                	push   $0x22
  801fe9:	e8 52 fc ff ff       	call   801c40 <syscall>
  801fee:	83 c4 18             	add    $0x18,%esp
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 02                	push   $0x2
  802002:	e8 39 fc ff ff       	call   801c40 <syscall>
  802007:	83 c4 18             	add    $0x18,%esp
}
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 03                	push   $0x3
  80201b:	e8 20 fc ff ff       	call   801c40 <syscall>
  802020:	83 c4 18             	add    $0x18,%esp
}
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 04                	push   $0x4
  802034:	e8 07 fc ff ff       	call   801c40 <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <sys_exit_env>:


void sys_exit_env(void)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 23                	push   $0x23
  80204d:	e8 ee fb ff ff       	call   801c40 <syscall>
  802052:	83 c4 18             	add    $0x18,%esp
}
  802055:	90                   	nop
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
  80205b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80205e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802061:	8d 50 04             	lea    0x4(%eax),%edx
  802064:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	52                   	push   %edx
  80206e:	50                   	push   %eax
  80206f:	6a 24                	push   $0x24
  802071:	e8 ca fb ff ff       	call   801c40 <syscall>
  802076:	83 c4 18             	add    $0x18,%esp
	return result;
  802079:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80207c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80207f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802082:	89 01                	mov    %eax,(%ecx)
  802084:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	c9                   	leave  
  80208b:	c2 04 00             	ret    $0x4

0080208e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	ff 75 10             	pushl  0x10(%ebp)
  802098:	ff 75 0c             	pushl  0xc(%ebp)
  80209b:	ff 75 08             	pushl  0x8(%ebp)
  80209e:	6a 12                	push   $0x12
  8020a0:	e8 9b fb ff ff       	call   801c40 <syscall>
  8020a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a8:	90                   	nop
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <sys_rcr2>:
uint32 sys_rcr2()
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 25                	push   $0x25
  8020ba:	e8 81 fb ff ff       	call   801c40 <syscall>
  8020bf:	83 c4 18             	add    $0x18,%esp
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	83 ec 04             	sub    $0x4,%esp
  8020ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020d0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	50                   	push   %eax
  8020dd:	6a 26                	push   $0x26
  8020df:	e8 5c fb ff ff       	call   801c40 <syscall>
  8020e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e7:	90                   	nop
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <rsttst>:
void rsttst()
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 28                	push   $0x28
  8020f9:	e8 42 fb ff ff       	call   801c40 <syscall>
  8020fe:	83 c4 18             	add    $0x18,%esp
	return ;
  802101:	90                   	nop
}
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	83 ec 04             	sub    $0x4,%esp
  80210a:	8b 45 14             	mov    0x14(%ebp),%eax
  80210d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802110:	8b 55 18             	mov    0x18(%ebp),%edx
  802113:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802117:	52                   	push   %edx
  802118:	50                   	push   %eax
  802119:	ff 75 10             	pushl  0x10(%ebp)
  80211c:	ff 75 0c             	pushl  0xc(%ebp)
  80211f:	ff 75 08             	pushl  0x8(%ebp)
  802122:	6a 27                	push   $0x27
  802124:	e8 17 fb ff ff       	call   801c40 <syscall>
  802129:	83 c4 18             	add    $0x18,%esp
	return ;
  80212c:	90                   	nop
}
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <chktst>:
void chktst(uint32 n)
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	ff 75 08             	pushl  0x8(%ebp)
  80213d:	6a 29                	push   $0x29
  80213f:	e8 fc fa ff ff       	call   801c40 <syscall>
  802144:	83 c4 18             	add    $0x18,%esp
	return ;
  802147:	90                   	nop
}
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <inctst>:

void inctst()
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 2a                	push   $0x2a
  802159:	e8 e2 fa ff ff       	call   801c40 <syscall>
  80215e:	83 c4 18             	add    $0x18,%esp
	return ;
  802161:	90                   	nop
}
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <gettst>:
uint32 gettst()
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 2b                	push   $0x2b
  802173:	e8 c8 fa ff ff       	call   801c40 <syscall>
  802178:	83 c4 18             	add    $0x18,%esp
}
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    

0080217d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
  802180:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 2c                	push   $0x2c
  80218f:	e8 ac fa ff ff       	call   801c40 <syscall>
  802194:	83 c4 18             	add    $0x18,%esp
  802197:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80219a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80219e:	75 07                	jne    8021a7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a5:	eb 05                	jmp    8021ac <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ac:	c9                   	leave  
  8021ad:	c3                   	ret    

008021ae <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
  8021b1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 2c                	push   $0x2c
  8021c0:	e8 7b fa ff ff       	call   801c40 <syscall>
  8021c5:	83 c4 18             	add    $0x18,%esp
  8021c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021cb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021cf:	75 07                	jne    8021d8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8021d6:	eb 05                	jmp    8021dd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 2c                	push   $0x2c
  8021f1:	e8 4a fa ff ff       	call   801c40 <syscall>
  8021f6:	83 c4 18             	add    $0x18,%esp
  8021f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021fc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802200:	75 07                	jne    802209 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802202:	b8 01 00 00 00       	mov    $0x1,%eax
  802207:	eb 05                	jmp    80220e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802209:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
  802213:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 2c                	push   $0x2c
  802222:	e8 19 fa ff ff       	call   801c40 <syscall>
  802227:	83 c4 18             	add    $0x18,%esp
  80222a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80222d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802231:	75 07                	jne    80223a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802233:	b8 01 00 00 00       	mov    $0x1,%eax
  802238:	eb 05                	jmp    80223f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80223a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	ff 75 08             	pushl  0x8(%ebp)
  80224f:	6a 2d                	push   $0x2d
  802251:	e8 ea f9 ff ff       	call   801c40 <syscall>
  802256:	83 c4 18             	add    $0x18,%esp
	return ;
  802259:	90                   	nop
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
  80225f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802260:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802263:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802266:	8b 55 0c             	mov    0xc(%ebp),%edx
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	6a 00                	push   $0x0
  80226e:	53                   	push   %ebx
  80226f:	51                   	push   %ecx
  802270:	52                   	push   %edx
  802271:	50                   	push   %eax
  802272:	6a 2e                	push   $0x2e
  802274:	e8 c7 f9 ff ff       	call   801c40 <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
}
  80227c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80227f:	c9                   	leave  
  802280:	c3                   	ret    

00802281 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802284:	8b 55 0c             	mov    0xc(%ebp),%edx
  802287:	8b 45 08             	mov    0x8(%ebp),%eax
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	52                   	push   %edx
  802291:	50                   	push   %eax
  802292:	6a 2f                	push   $0x2f
  802294:	e8 a7 f9 ff ff       	call   801c40 <syscall>
  802299:	83 c4 18             	add    $0x18,%esp
}
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
  8022a1:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8022a4:	83 ec 0c             	sub    $0xc,%esp
  8022a7:	68 dc 3e 80 00       	push   $0x803edc
  8022ac:	e8 21 e7 ff ff       	call   8009d2 <cprintf>
  8022b1:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022bb:	83 ec 0c             	sub    $0xc,%esp
  8022be:	68 08 3f 80 00       	push   $0x803f08
  8022c3:	e8 0a e7 ff ff       	call   8009d2 <cprintf>
  8022c8:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022cb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022cf:	a1 38 51 80 00       	mov    0x805138,%eax
  8022d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d7:	eb 56                	jmp    80232f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022dd:	74 1c                	je     8022fb <print_mem_block_lists+0x5d>
  8022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e2:	8b 50 08             	mov    0x8(%eax),%edx
  8022e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e8:	8b 48 08             	mov    0x8(%eax),%ecx
  8022eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f1:	01 c8                	add    %ecx,%eax
  8022f3:	39 c2                	cmp    %eax,%edx
  8022f5:	73 04                	jae    8022fb <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8022f7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fe:	8b 50 08             	mov    0x8(%eax),%edx
  802301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802304:	8b 40 0c             	mov    0xc(%eax),%eax
  802307:	01 c2                	add    %eax,%edx
  802309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230c:	8b 40 08             	mov    0x8(%eax),%eax
  80230f:	83 ec 04             	sub    $0x4,%esp
  802312:	52                   	push   %edx
  802313:	50                   	push   %eax
  802314:	68 1d 3f 80 00       	push   $0x803f1d
  802319:	e8 b4 e6 ff ff       	call   8009d2 <cprintf>
  80231e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802327:	a1 40 51 80 00       	mov    0x805140,%eax
  80232c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802333:	74 07                	je     80233c <print_mem_block_lists+0x9e>
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	8b 00                	mov    (%eax),%eax
  80233a:	eb 05                	jmp    802341 <print_mem_block_lists+0xa3>
  80233c:	b8 00 00 00 00       	mov    $0x0,%eax
  802341:	a3 40 51 80 00       	mov    %eax,0x805140
  802346:	a1 40 51 80 00       	mov    0x805140,%eax
  80234b:	85 c0                	test   %eax,%eax
  80234d:	75 8a                	jne    8022d9 <print_mem_block_lists+0x3b>
  80234f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802353:	75 84                	jne    8022d9 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802355:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802359:	75 10                	jne    80236b <print_mem_block_lists+0xcd>
  80235b:	83 ec 0c             	sub    $0xc,%esp
  80235e:	68 2c 3f 80 00       	push   $0x803f2c
  802363:	e8 6a e6 ff ff       	call   8009d2 <cprintf>
  802368:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80236b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802372:	83 ec 0c             	sub    $0xc,%esp
  802375:	68 50 3f 80 00       	push   $0x803f50
  80237a:	e8 53 e6 ff ff       	call   8009d2 <cprintf>
  80237f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802382:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802386:	a1 40 50 80 00       	mov    0x805040,%eax
  80238b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80238e:	eb 56                	jmp    8023e6 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802390:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802394:	74 1c                	je     8023b2 <print_mem_block_lists+0x114>
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 50 08             	mov    0x8(%eax),%edx
  80239c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239f:	8b 48 08             	mov    0x8(%eax),%ecx
  8023a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a8:	01 c8                	add    %ecx,%eax
  8023aa:	39 c2                	cmp    %eax,%edx
  8023ac:	73 04                	jae    8023b2 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023ae:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	8b 50 08             	mov    0x8(%eax),%edx
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8023be:	01 c2                	add    %eax,%edx
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	8b 40 08             	mov    0x8(%eax),%eax
  8023c6:	83 ec 04             	sub    $0x4,%esp
  8023c9:	52                   	push   %edx
  8023ca:	50                   	push   %eax
  8023cb:	68 1d 3f 80 00       	push   $0x803f1d
  8023d0:	e8 fd e5 ff ff       	call   8009d2 <cprintf>
  8023d5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023de:	a1 48 50 80 00       	mov    0x805048,%eax
  8023e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ea:	74 07                	je     8023f3 <print_mem_block_lists+0x155>
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	8b 00                	mov    (%eax),%eax
  8023f1:	eb 05                	jmp    8023f8 <print_mem_block_lists+0x15a>
  8023f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f8:	a3 48 50 80 00       	mov    %eax,0x805048
  8023fd:	a1 48 50 80 00       	mov    0x805048,%eax
  802402:	85 c0                	test   %eax,%eax
  802404:	75 8a                	jne    802390 <print_mem_block_lists+0xf2>
  802406:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240a:	75 84                	jne    802390 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80240c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802410:	75 10                	jne    802422 <print_mem_block_lists+0x184>
  802412:	83 ec 0c             	sub    $0xc,%esp
  802415:	68 68 3f 80 00       	push   $0x803f68
  80241a:	e8 b3 e5 ff ff       	call   8009d2 <cprintf>
  80241f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802422:	83 ec 0c             	sub    $0xc,%esp
  802425:	68 dc 3e 80 00       	push   $0x803edc
  80242a:	e8 a3 e5 ff ff       	call   8009d2 <cprintf>
  80242f:	83 c4 10             	add    $0x10,%esp

}
  802432:	90                   	nop
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
  802438:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80243b:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802442:	00 00 00 
  802445:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80244c:	00 00 00 
  80244f:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802456:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802459:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802460:	e9 9e 00 00 00       	jmp    802503 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802465:	a1 50 50 80 00       	mov    0x805050,%eax
  80246a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246d:	c1 e2 04             	shl    $0x4,%edx
  802470:	01 d0                	add    %edx,%eax
  802472:	85 c0                	test   %eax,%eax
  802474:	75 14                	jne    80248a <initialize_MemBlocksList+0x55>
  802476:	83 ec 04             	sub    $0x4,%esp
  802479:	68 90 3f 80 00       	push   $0x803f90
  80247e:	6a 43                	push   $0x43
  802480:	68 b3 3f 80 00       	push   $0x803fb3
  802485:	e8 94 e2 ff ff       	call   80071e <_panic>
  80248a:	a1 50 50 80 00       	mov    0x805050,%eax
  80248f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802492:	c1 e2 04             	shl    $0x4,%edx
  802495:	01 d0                	add    %edx,%eax
  802497:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80249d:	89 10                	mov    %edx,(%eax)
  80249f:	8b 00                	mov    (%eax),%eax
  8024a1:	85 c0                	test   %eax,%eax
  8024a3:	74 18                	je     8024bd <initialize_MemBlocksList+0x88>
  8024a5:	a1 48 51 80 00       	mov    0x805148,%eax
  8024aa:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8024b0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024b3:	c1 e1 04             	shl    $0x4,%ecx
  8024b6:	01 ca                	add    %ecx,%edx
  8024b8:	89 50 04             	mov    %edx,0x4(%eax)
  8024bb:	eb 12                	jmp    8024cf <initialize_MemBlocksList+0x9a>
  8024bd:	a1 50 50 80 00       	mov    0x805050,%eax
  8024c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c5:	c1 e2 04             	shl    $0x4,%edx
  8024c8:	01 d0                	add    %edx,%eax
  8024ca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024cf:	a1 50 50 80 00       	mov    0x805050,%eax
  8024d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d7:	c1 e2 04             	shl    $0x4,%edx
  8024da:	01 d0                	add    %edx,%eax
  8024dc:	a3 48 51 80 00       	mov    %eax,0x805148
  8024e1:	a1 50 50 80 00       	mov    0x805050,%eax
  8024e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e9:	c1 e2 04             	shl    $0x4,%edx
  8024ec:	01 d0                	add    %edx,%eax
  8024ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f5:	a1 54 51 80 00       	mov    0x805154,%eax
  8024fa:	40                   	inc    %eax
  8024fb:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802500:	ff 45 f4             	incl   -0xc(%ebp)
  802503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802506:	3b 45 08             	cmp    0x8(%ebp),%eax
  802509:	0f 82 56 ff ff ff    	jb     802465 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  80250f:	90                   	nop
  802510:	c9                   	leave  
  802511:	c3                   	ret    

00802512 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802512:	55                   	push   %ebp
  802513:	89 e5                	mov    %esp,%ebp
  802515:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802518:	a1 38 51 80 00       	mov    0x805138,%eax
  80251d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802520:	eb 18                	jmp    80253a <find_block+0x28>
	{
		if (ele->sva==va)
  802522:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802525:	8b 40 08             	mov    0x8(%eax),%eax
  802528:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80252b:	75 05                	jne    802532 <find_block+0x20>
			return ele;
  80252d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802530:	eb 7b                	jmp    8025ad <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802532:	a1 40 51 80 00       	mov    0x805140,%eax
  802537:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80253a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80253e:	74 07                	je     802547 <find_block+0x35>
  802540:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802543:	8b 00                	mov    (%eax),%eax
  802545:	eb 05                	jmp    80254c <find_block+0x3a>
  802547:	b8 00 00 00 00       	mov    $0x0,%eax
  80254c:	a3 40 51 80 00       	mov    %eax,0x805140
  802551:	a1 40 51 80 00       	mov    0x805140,%eax
  802556:	85 c0                	test   %eax,%eax
  802558:	75 c8                	jne    802522 <find_block+0x10>
  80255a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80255e:	75 c2                	jne    802522 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802560:	a1 40 50 80 00       	mov    0x805040,%eax
  802565:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802568:	eb 18                	jmp    802582 <find_block+0x70>
	{
		if (ele->sva==va)
  80256a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80256d:	8b 40 08             	mov    0x8(%eax),%eax
  802570:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802573:	75 05                	jne    80257a <find_block+0x68>
					return ele;
  802575:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802578:	eb 33                	jmp    8025ad <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80257a:	a1 48 50 80 00       	mov    0x805048,%eax
  80257f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802582:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802586:	74 07                	je     80258f <find_block+0x7d>
  802588:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80258b:	8b 00                	mov    (%eax),%eax
  80258d:	eb 05                	jmp    802594 <find_block+0x82>
  80258f:	b8 00 00 00 00       	mov    $0x0,%eax
  802594:	a3 48 50 80 00       	mov    %eax,0x805048
  802599:	a1 48 50 80 00       	mov    0x805048,%eax
  80259e:	85 c0                	test   %eax,%eax
  8025a0:	75 c8                	jne    80256a <find_block+0x58>
  8025a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025a6:	75 c2                	jne    80256a <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  8025a8:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8025ad:	c9                   	leave  
  8025ae:	c3                   	ret    

008025af <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
  8025b2:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  8025b5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025ba:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  8025bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025c1:	75 62                	jne    802625 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8025c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025c7:	75 14                	jne    8025dd <insert_sorted_allocList+0x2e>
  8025c9:	83 ec 04             	sub    $0x4,%esp
  8025cc:	68 90 3f 80 00       	push   $0x803f90
  8025d1:	6a 69                	push   $0x69
  8025d3:	68 b3 3f 80 00       	push   $0x803fb3
  8025d8:	e8 41 e1 ff ff       	call   80071e <_panic>
  8025dd:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8025e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e6:	89 10                	mov    %edx,(%eax)
  8025e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025eb:	8b 00                	mov    (%eax),%eax
  8025ed:	85 c0                	test   %eax,%eax
  8025ef:	74 0d                	je     8025fe <insert_sorted_allocList+0x4f>
  8025f1:	a1 40 50 80 00       	mov    0x805040,%eax
  8025f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8025f9:	89 50 04             	mov    %edx,0x4(%eax)
  8025fc:	eb 08                	jmp    802606 <insert_sorted_allocList+0x57>
  8025fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802601:	a3 44 50 80 00       	mov    %eax,0x805044
  802606:	8b 45 08             	mov    0x8(%ebp),%eax
  802609:	a3 40 50 80 00       	mov    %eax,0x805040
  80260e:	8b 45 08             	mov    0x8(%ebp),%eax
  802611:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802618:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80261d:	40                   	inc    %eax
  80261e:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802623:	eb 72                	jmp    802697 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802625:	a1 40 50 80 00       	mov    0x805040,%eax
  80262a:	8b 50 08             	mov    0x8(%eax),%edx
  80262d:	8b 45 08             	mov    0x8(%ebp),%eax
  802630:	8b 40 08             	mov    0x8(%eax),%eax
  802633:	39 c2                	cmp    %eax,%edx
  802635:	76 60                	jbe    802697 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802637:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80263b:	75 14                	jne    802651 <insert_sorted_allocList+0xa2>
  80263d:	83 ec 04             	sub    $0x4,%esp
  802640:	68 90 3f 80 00       	push   $0x803f90
  802645:	6a 6d                	push   $0x6d
  802647:	68 b3 3f 80 00       	push   $0x803fb3
  80264c:	e8 cd e0 ff ff       	call   80071e <_panic>
  802651:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802657:	8b 45 08             	mov    0x8(%ebp),%eax
  80265a:	89 10                	mov    %edx,(%eax)
  80265c:	8b 45 08             	mov    0x8(%ebp),%eax
  80265f:	8b 00                	mov    (%eax),%eax
  802661:	85 c0                	test   %eax,%eax
  802663:	74 0d                	je     802672 <insert_sorted_allocList+0xc3>
  802665:	a1 40 50 80 00       	mov    0x805040,%eax
  80266a:	8b 55 08             	mov    0x8(%ebp),%edx
  80266d:	89 50 04             	mov    %edx,0x4(%eax)
  802670:	eb 08                	jmp    80267a <insert_sorted_allocList+0xcb>
  802672:	8b 45 08             	mov    0x8(%ebp),%eax
  802675:	a3 44 50 80 00       	mov    %eax,0x805044
  80267a:	8b 45 08             	mov    0x8(%ebp),%eax
  80267d:	a3 40 50 80 00       	mov    %eax,0x805040
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80268c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802691:	40                   	inc    %eax
  802692:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802697:	a1 40 50 80 00       	mov    0x805040,%eax
  80269c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269f:	e9 b9 01 00 00       	jmp    80285d <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  8026a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a7:	8b 50 08             	mov    0x8(%eax),%edx
  8026aa:	a1 40 50 80 00       	mov    0x805040,%eax
  8026af:	8b 40 08             	mov    0x8(%eax),%eax
  8026b2:	39 c2                	cmp    %eax,%edx
  8026b4:	76 7c                	jbe    802732 <insert_sorted_allocList+0x183>
  8026b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b9:	8b 50 08             	mov    0x8(%eax),%edx
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	8b 40 08             	mov    0x8(%eax),%eax
  8026c2:	39 c2                	cmp    %eax,%edx
  8026c4:	73 6c                	jae    802732 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  8026c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ca:	74 06                	je     8026d2 <insert_sorted_allocList+0x123>
  8026cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026d0:	75 14                	jne    8026e6 <insert_sorted_allocList+0x137>
  8026d2:	83 ec 04             	sub    $0x4,%esp
  8026d5:	68 cc 3f 80 00       	push   $0x803fcc
  8026da:	6a 75                	push   $0x75
  8026dc:	68 b3 3f 80 00       	push   $0x803fb3
  8026e1:	e8 38 e0 ff ff       	call   80071e <_panic>
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	8b 50 04             	mov    0x4(%eax),%edx
  8026ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ef:	89 50 04             	mov    %edx,0x4(%eax)
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f8:	89 10                	mov    %edx,(%eax)
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	8b 40 04             	mov    0x4(%eax),%eax
  802700:	85 c0                	test   %eax,%eax
  802702:	74 0d                	je     802711 <insert_sorted_allocList+0x162>
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 40 04             	mov    0x4(%eax),%eax
  80270a:	8b 55 08             	mov    0x8(%ebp),%edx
  80270d:	89 10                	mov    %edx,(%eax)
  80270f:	eb 08                	jmp    802719 <insert_sorted_allocList+0x16a>
  802711:	8b 45 08             	mov    0x8(%ebp),%eax
  802714:	a3 40 50 80 00       	mov    %eax,0x805040
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	8b 55 08             	mov    0x8(%ebp),%edx
  80271f:	89 50 04             	mov    %edx,0x4(%eax)
  802722:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802727:	40                   	inc    %eax
  802728:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  80272d:	e9 59 01 00 00       	jmp    80288b <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802732:	8b 45 08             	mov    0x8(%ebp),%eax
  802735:	8b 50 08             	mov    0x8(%eax),%edx
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 40 08             	mov    0x8(%eax),%eax
  80273e:	39 c2                	cmp    %eax,%edx
  802740:	0f 86 98 00 00 00    	jbe    8027de <insert_sorted_allocList+0x22f>
  802746:	8b 45 08             	mov    0x8(%ebp),%eax
  802749:	8b 50 08             	mov    0x8(%eax),%edx
  80274c:	a1 44 50 80 00       	mov    0x805044,%eax
  802751:	8b 40 08             	mov    0x8(%eax),%eax
  802754:	39 c2                	cmp    %eax,%edx
  802756:	0f 83 82 00 00 00    	jae    8027de <insert_sorted_allocList+0x22f>
  80275c:	8b 45 08             	mov    0x8(%ebp),%eax
  80275f:	8b 50 08             	mov    0x8(%eax),%edx
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 00                	mov    (%eax),%eax
  802767:	8b 40 08             	mov    0x8(%eax),%eax
  80276a:	39 c2                	cmp    %eax,%edx
  80276c:	73 70                	jae    8027de <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80276e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802772:	74 06                	je     80277a <insert_sorted_allocList+0x1cb>
  802774:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802778:	75 14                	jne    80278e <insert_sorted_allocList+0x1df>
  80277a:	83 ec 04             	sub    $0x4,%esp
  80277d:	68 04 40 80 00       	push   $0x804004
  802782:	6a 7c                	push   $0x7c
  802784:	68 b3 3f 80 00       	push   $0x803fb3
  802789:	e8 90 df ff ff       	call   80071e <_panic>
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 10                	mov    (%eax),%edx
  802793:	8b 45 08             	mov    0x8(%ebp),%eax
  802796:	89 10                	mov    %edx,(%eax)
  802798:	8b 45 08             	mov    0x8(%ebp),%eax
  80279b:	8b 00                	mov    (%eax),%eax
  80279d:	85 c0                	test   %eax,%eax
  80279f:	74 0b                	je     8027ac <insert_sorted_allocList+0x1fd>
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	8b 00                	mov    (%eax),%eax
  8027a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a9:	89 50 04             	mov    %edx,0x4(%eax)
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b2:	89 10                	mov    %edx,(%eax)
  8027b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ba:	89 50 04             	mov    %edx,0x4(%eax)
  8027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c0:	8b 00                	mov    (%eax),%eax
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	75 08                	jne    8027ce <insert_sorted_allocList+0x21f>
  8027c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c9:	a3 44 50 80 00       	mov    %eax,0x805044
  8027ce:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027d3:	40                   	inc    %eax
  8027d4:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  8027d9:	e9 ad 00 00 00       	jmp    80288b <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	8b 50 08             	mov    0x8(%eax),%edx
  8027e4:	a1 44 50 80 00       	mov    0x805044,%eax
  8027e9:	8b 40 08             	mov    0x8(%eax),%eax
  8027ec:	39 c2                	cmp    %eax,%edx
  8027ee:	76 65                	jbe    802855 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  8027f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027f4:	75 17                	jne    80280d <insert_sorted_allocList+0x25e>
  8027f6:	83 ec 04             	sub    $0x4,%esp
  8027f9:	68 38 40 80 00       	push   $0x804038
  8027fe:	68 80 00 00 00       	push   $0x80
  802803:	68 b3 3f 80 00       	push   $0x803fb3
  802808:	e8 11 df ff ff       	call   80071e <_panic>
  80280d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802813:	8b 45 08             	mov    0x8(%ebp),%eax
  802816:	89 50 04             	mov    %edx,0x4(%eax)
  802819:	8b 45 08             	mov    0x8(%ebp),%eax
  80281c:	8b 40 04             	mov    0x4(%eax),%eax
  80281f:	85 c0                	test   %eax,%eax
  802821:	74 0c                	je     80282f <insert_sorted_allocList+0x280>
  802823:	a1 44 50 80 00       	mov    0x805044,%eax
  802828:	8b 55 08             	mov    0x8(%ebp),%edx
  80282b:	89 10                	mov    %edx,(%eax)
  80282d:	eb 08                	jmp    802837 <insert_sorted_allocList+0x288>
  80282f:	8b 45 08             	mov    0x8(%ebp),%eax
  802832:	a3 40 50 80 00       	mov    %eax,0x805040
  802837:	8b 45 08             	mov    0x8(%ebp),%eax
  80283a:	a3 44 50 80 00       	mov    %eax,0x805044
  80283f:	8b 45 08             	mov    0x8(%ebp),%eax
  802842:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802848:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80284d:	40                   	inc    %eax
  80284e:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802853:	eb 36                	jmp    80288b <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802855:	a1 48 50 80 00       	mov    0x805048,%eax
  80285a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802861:	74 07                	je     80286a <insert_sorted_allocList+0x2bb>
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	8b 00                	mov    (%eax),%eax
  802868:	eb 05                	jmp    80286f <insert_sorted_allocList+0x2c0>
  80286a:	b8 00 00 00 00       	mov    $0x0,%eax
  80286f:	a3 48 50 80 00       	mov    %eax,0x805048
  802874:	a1 48 50 80 00       	mov    0x805048,%eax
  802879:	85 c0                	test   %eax,%eax
  80287b:	0f 85 23 fe ff ff    	jne    8026a4 <insert_sorted_allocList+0xf5>
  802881:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802885:	0f 85 19 fe ff ff    	jne    8026a4 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  80288b:	90                   	nop
  80288c:	c9                   	leave  
  80288d:	c3                   	ret    

0080288e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80288e:	55                   	push   %ebp
  80288f:	89 e5                	mov    %esp,%ebp
  802891:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802894:	a1 38 51 80 00       	mov    0x805138,%eax
  802899:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80289c:	e9 7c 01 00 00       	jmp    802a1d <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028aa:	0f 85 90 00 00 00    	jne    802940 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  8028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  8028b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ba:	75 17                	jne    8028d3 <alloc_block_FF+0x45>
  8028bc:	83 ec 04             	sub    $0x4,%esp
  8028bf:	68 5b 40 80 00       	push   $0x80405b
  8028c4:	68 ba 00 00 00       	push   $0xba
  8028c9:	68 b3 3f 80 00       	push   $0x803fb3
  8028ce:	e8 4b de ff ff       	call   80071e <_panic>
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	8b 00                	mov    (%eax),%eax
  8028d8:	85 c0                	test   %eax,%eax
  8028da:	74 10                	je     8028ec <alloc_block_FF+0x5e>
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 00                	mov    (%eax),%eax
  8028e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e4:	8b 52 04             	mov    0x4(%edx),%edx
  8028e7:	89 50 04             	mov    %edx,0x4(%eax)
  8028ea:	eb 0b                	jmp    8028f7 <alloc_block_FF+0x69>
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	8b 40 04             	mov    0x4(%eax),%eax
  8028f2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	8b 40 04             	mov    0x4(%eax),%eax
  8028fd:	85 c0                	test   %eax,%eax
  8028ff:	74 0f                	je     802910 <alloc_block_FF+0x82>
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	8b 40 04             	mov    0x4(%eax),%eax
  802907:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290a:	8b 12                	mov    (%edx),%edx
  80290c:	89 10                	mov    %edx,(%eax)
  80290e:	eb 0a                	jmp    80291a <alloc_block_FF+0x8c>
  802910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802913:	8b 00                	mov    (%eax),%eax
  802915:	a3 38 51 80 00       	mov    %eax,0x805138
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292d:	a1 44 51 80 00       	mov    0x805144,%eax
  802932:	48                   	dec    %eax
  802933:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802938:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293b:	e9 10 01 00 00       	jmp    802a50 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 40 0c             	mov    0xc(%eax),%eax
  802946:	3b 45 08             	cmp    0x8(%ebp),%eax
  802949:	0f 86 c6 00 00 00    	jbe    802a15 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  80294f:	a1 48 51 80 00       	mov    0x805148,%eax
  802954:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802957:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80295b:	75 17                	jne    802974 <alloc_block_FF+0xe6>
  80295d:	83 ec 04             	sub    $0x4,%esp
  802960:	68 5b 40 80 00       	push   $0x80405b
  802965:	68 c2 00 00 00       	push   $0xc2
  80296a:	68 b3 3f 80 00       	push   $0x803fb3
  80296f:	e8 aa dd ff ff       	call   80071e <_panic>
  802974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802977:	8b 00                	mov    (%eax),%eax
  802979:	85 c0                	test   %eax,%eax
  80297b:	74 10                	je     80298d <alloc_block_FF+0xff>
  80297d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802980:	8b 00                	mov    (%eax),%eax
  802982:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802985:	8b 52 04             	mov    0x4(%edx),%edx
  802988:	89 50 04             	mov    %edx,0x4(%eax)
  80298b:	eb 0b                	jmp    802998 <alloc_block_FF+0x10a>
  80298d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802990:	8b 40 04             	mov    0x4(%eax),%eax
  802993:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299b:	8b 40 04             	mov    0x4(%eax),%eax
  80299e:	85 c0                	test   %eax,%eax
  8029a0:	74 0f                	je     8029b1 <alloc_block_FF+0x123>
  8029a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a5:	8b 40 04             	mov    0x4(%eax),%eax
  8029a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ab:	8b 12                	mov    (%edx),%edx
  8029ad:	89 10                	mov    %edx,(%eax)
  8029af:	eb 0a                	jmp    8029bb <alloc_block_FF+0x12d>
  8029b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b4:	8b 00                	mov    (%eax),%eax
  8029b6:	a3 48 51 80 00       	mov    %eax,0x805148
  8029bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ce:	a1 54 51 80 00       	mov    0x805154,%eax
  8029d3:	48                   	dec    %eax
  8029d4:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 50 08             	mov    0x8(%eax),%edx
  8029df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e2:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  8029e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029eb:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  8029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f4:	2b 45 08             	sub    0x8(%ebp),%eax
  8029f7:	89 c2                	mov    %eax,%edx
  8029f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fc:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 50 08             	mov    0x8(%eax),%edx
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	01 c2                	add    %eax,%edx
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a13:	eb 3b                	jmp    802a50 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802a15:	a1 40 51 80 00       	mov    0x805140,%eax
  802a1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a21:	74 07                	je     802a2a <alloc_block_FF+0x19c>
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	8b 00                	mov    (%eax),%eax
  802a28:	eb 05                	jmp    802a2f <alloc_block_FF+0x1a1>
  802a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2f:	a3 40 51 80 00       	mov    %eax,0x805140
  802a34:	a1 40 51 80 00       	mov    0x805140,%eax
  802a39:	85 c0                	test   %eax,%eax
  802a3b:	0f 85 60 fe ff ff    	jne    8028a1 <alloc_block_FF+0x13>
  802a41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a45:	0f 85 56 fe ff ff    	jne    8028a1 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a50:	c9                   	leave  
  802a51:	c3                   	ret    

00802a52 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802a52:	55                   	push   %ebp
  802a53:	89 e5                	mov    %esp,%ebp
  802a55:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802a58:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802a5f:	a1 38 51 80 00       	mov    0x805138,%eax
  802a64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a67:	eb 3a                	jmp    802aa3 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a72:	72 27                	jb     802a9b <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802a74:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802a78:	75 0b                	jne    802a85 <alloc_block_BF+0x33>
					best_size= element->size;
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802a83:	eb 16                	jmp    802a9b <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	8b 50 0c             	mov    0xc(%eax),%edx
  802a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8e:	39 c2                	cmp    %eax,%edx
  802a90:	77 09                	ja     802a9b <alloc_block_BF+0x49>
					best_size=element->size;
  802a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a95:	8b 40 0c             	mov    0xc(%eax),%eax
  802a98:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802a9b:	a1 40 51 80 00       	mov    0x805140,%eax
  802aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa7:	74 07                	je     802ab0 <alloc_block_BF+0x5e>
  802aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aac:	8b 00                	mov    (%eax),%eax
  802aae:	eb 05                	jmp    802ab5 <alloc_block_BF+0x63>
  802ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab5:	a3 40 51 80 00       	mov    %eax,0x805140
  802aba:	a1 40 51 80 00       	mov    0x805140,%eax
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	75 a6                	jne    802a69 <alloc_block_BF+0x17>
  802ac3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac7:	75 a0                	jne    802a69 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802ac9:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802acd:	0f 84 d3 01 00 00    	je     802ca6 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802ad3:	a1 38 51 80 00       	mov    0x805138,%eax
  802ad8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802adb:	e9 98 01 00 00       	jmp    802c78 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae6:	0f 86 da 00 00 00    	jbe    802bc6 <alloc_block_BF+0x174>
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 50 0c             	mov    0xc(%eax),%edx
  802af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af5:	39 c2                	cmp    %eax,%edx
  802af7:	0f 85 c9 00 00 00    	jne    802bc6 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802afd:	a1 48 51 80 00       	mov    0x805148,%eax
  802b02:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802b05:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b09:	75 17                	jne    802b22 <alloc_block_BF+0xd0>
  802b0b:	83 ec 04             	sub    $0x4,%esp
  802b0e:	68 5b 40 80 00       	push   $0x80405b
  802b13:	68 ea 00 00 00       	push   $0xea
  802b18:	68 b3 3f 80 00       	push   $0x803fb3
  802b1d:	e8 fc db ff ff       	call   80071e <_panic>
  802b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b25:	8b 00                	mov    (%eax),%eax
  802b27:	85 c0                	test   %eax,%eax
  802b29:	74 10                	je     802b3b <alloc_block_BF+0xe9>
  802b2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2e:	8b 00                	mov    (%eax),%eax
  802b30:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b33:	8b 52 04             	mov    0x4(%edx),%edx
  802b36:	89 50 04             	mov    %edx,0x4(%eax)
  802b39:	eb 0b                	jmp    802b46 <alloc_block_BF+0xf4>
  802b3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3e:	8b 40 04             	mov    0x4(%eax),%eax
  802b41:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b49:	8b 40 04             	mov    0x4(%eax),%eax
  802b4c:	85 c0                	test   %eax,%eax
  802b4e:	74 0f                	je     802b5f <alloc_block_BF+0x10d>
  802b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b53:	8b 40 04             	mov    0x4(%eax),%eax
  802b56:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b59:	8b 12                	mov    (%edx),%edx
  802b5b:	89 10                	mov    %edx,(%eax)
  802b5d:	eb 0a                	jmp    802b69 <alloc_block_BF+0x117>
  802b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b62:	8b 00                	mov    (%eax),%eax
  802b64:	a3 48 51 80 00       	mov    %eax,0x805148
  802b69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7c:	a1 54 51 80 00       	mov    0x805154,%eax
  802b81:	48                   	dec    %eax
  802b82:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	8b 50 08             	mov    0x8(%eax),%edx
  802b8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b90:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b96:	8b 55 08             	mov    0x8(%ebp),%edx
  802b99:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba2:	2b 45 08             	sub    0x8(%ebp),%eax
  802ba5:	89 c2                	mov    %eax,%edx
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	8b 50 08             	mov    0x8(%eax),%edx
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	01 c2                	add    %eax,%edx
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc1:	e9 e5 00 00 00       	jmp    802cab <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc9:	8b 50 0c             	mov    0xc(%eax),%edx
  802bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcf:	39 c2                	cmp    %eax,%edx
  802bd1:	0f 85 99 00 00 00    	jne    802c70 <alloc_block_BF+0x21e>
  802bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bda:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bdd:	0f 85 8d 00 00 00    	jne    802c70 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802be9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bed:	75 17                	jne    802c06 <alloc_block_BF+0x1b4>
  802bef:	83 ec 04             	sub    $0x4,%esp
  802bf2:	68 5b 40 80 00       	push   $0x80405b
  802bf7:	68 f7 00 00 00       	push   $0xf7
  802bfc:	68 b3 3f 80 00       	push   $0x803fb3
  802c01:	e8 18 db ff ff       	call   80071e <_panic>
  802c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c09:	8b 00                	mov    (%eax),%eax
  802c0b:	85 c0                	test   %eax,%eax
  802c0d:	74 10                	je     802c1f <alloc_block_BF+0x1cd>
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	8b 00                	mov    (%eax),%eax
  802c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c17:	8b 52 04             	mov    0x4(%edx),%edx
  802c1a:	89 50 04             	mov    %edx,0x4(%eax)
  802c1d:	eb 0b                	jmp    802c2a <alloc_block_BF+0x1d8>
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	8b 40 04             	mov    0x4(%eax),%eax
  802c25:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2d:	8b 40 04             	mov    0x4(%eax),%eax
  802c30:	85 c0                	test   %eax,%eax
  802c32:	74 0f                	je     802c43 <alloc_block_BF+0x1f1>
  802c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c37:	8b 40 04             	mov    0x4(%eax),%eax
  802c3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c3d:	8b 12                	mov    (%edx),%edx
  802c3f:	89 10                	mov    %edx,(%eax)
  802c41:	eb 0a                	jmp    802c4d <alloc_block_BF+0x1fb>
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	8b 00                	mov    (%eax),%eax
  802c48:	a3 38 51 80 00       	mov    %eax,0x805138
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c60:	a1 44 51 80 00       	mov    0x805144,%eax
  802c65:	48                   	dec    %eax
  802c66:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  802c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6e:	eb 3b                	jmp    802cab <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802c70:	a1 40 51 80 00       	mov    0x805140,%eax
  802c75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c7c:	74 07                	je     802c85 <alloc_block_BF+0x233>
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	8b 00                	mov    (%eax),%eax
  802c83:	eb 05                	jmp    802c8a <alloc_block_BF+0x238>
  802c85:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8a:	a3 40 51 80 00       	mov    %eax,0x805140
  802c8f:	a1 40 51 80 00       	mov    0x805140,%eax
  802c94:	85 c0                	test   %eax,%eax
  802c96:	0f 85 44 fe ff ff    	jne    802ae0 <alloc_block_BF+0x8e>
  802c9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca0:	0f 85 3a fe ff ff    	jne    802ae0 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802ca6:	b8 00 00 00 00       	mov    $0x0,%eax
  802cab:	c9                   	leave  
  802cac:	c3                   	ret    

00802cad <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802cad:	55                   	push   %ebp
  802cae:	89 e5                	mov    %esp,%ebp
  802cb0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802cb3:	83 ec 04             	sub    $0x4,%esp
  802cb6:	68 7c 40 80 00       	push   $0x80407c
  802cbb:	68 04 01 00 00       	push   $0x104
  802cc0:	68 b3 3f 80 00       	push   $0x803fb3
  802cc5:	e8 54 da ff ff       	call   80071e <_panic>

00802cca <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802cca:	55                   	push   %ebp
  802ccb:	89 e5                	mov    %esp,%ebp
  802ccd:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802cd0:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802cd8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cdd:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802ce0:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce5:	85 c0                	test   %eax,%eax
  802ce7:	75 68                	jne    802d51 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802ce9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ced:	75 17                	jne    802d06 <insert_sorted_with_merge_freeList+0x3c>
  802cef:	83 ec 04             	sub    $0x4,%esp
  802cf2:	68 90 3f 80 00       	push   $0x803f90
  802cf7:	68 14 01 00 00       	push   $0x114
  802cfc:	68 b3 3f 80 00       	push   $0x803fb3
  802d01:	e8 18 da ff ff       	call   80071e <_panic>
  802d06:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0f:	89 10                	mov    %edx,(%eax)
  802d11:	8b 45 08             	mov    0x8(%ebp),%eax
  802d14:	8b 00                	mov    (%eax),%eax
  802d16:	85 c0                	test   %eax,%eax
  802d18:	74 0d                	je     802d27 <insert_sorted_with_merge_freeList+0x5d>
  802d1a:	a1 38 51 80 00       	mov    0x805138,%eax
  802d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d22:	89 50 04             	mov    %edx,0x4(%eax)
  802d25:	eb 08                	jmp    802d2f <insert_sorted_with_merge_freeList+0x65>
  802d27:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d32:	a3 38 51 80 00       	mov    %eax,0x805138
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d41:	a1 44 51 80 00       	mov    0x805144,%eax
  802d46:	40                   	inc    %eax
  802d47:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802d4c:	e9 d2 06 00 00       	jmp    803423 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802d51:	8b 45 08             	mov    0x8(%ebp),%eax
  802d54:	8b 50 08             	mov    0x8(%eax),%edx
  802d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5a:	8b 40 08             	mov    0x8(%eax),%eax
  802d5d:	39 c2                	cmp    %eax,%edx
  802d5f:	0f 83 22 01 00 00    	jae    802e87 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	8b 50 08             	mov    0x8(%eax),%edx
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d71:	01 c2                	add    %eax,%edx
  802d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d76:	8b 40 08             	mov    0x8(%eax),%eax
  802d79:	39 c2                	cmp    %eax,%edx
  802d7b:	0f 85 9e 00 00 00    	jne    802e1f <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802d81:	8b 45 08             	mov    0x8(%ebp),%eax
  802d84:	8b 50 08             	mov    0x8(%eax),%edx
  802d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8a:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d90:	8b 50 0c             	mov    0xc(%eax),%edx
  802d93:	8b 45 08             	mov    0x8(%ebp),%eax
  802d96:	8b 40 0c             	mov    0xc(%eax),%eax
  802d99:	01 c2                	add    %eax,%edx
  802d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9e:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	8b 50 08             	mov    0x8(%eax),%edx
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802db7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dbb:	75 17                	jne    802dd4 <insert_sorted_with_merge_freeList+0x10a>
  802dbd:	83 ec 04             	sub    $0x4,%esp
  802dc0:	68 90 3f 80 00       	push   $0x803f90
  802dc5:	68 21 01 00 00       	push   $0x121
  802dca:	68 b3 3f 80 00       	push   $0x803fb3
  802dcf:	e8 4a d9 ff ff       	call   80071e <_panic>
  802dd4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802dda:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddd:	89 10                	mov    %edx,(%eax)
  802ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  802de2:	8b 00                	mov    (%eax),%eax
  802de4:	85 c0                	test   %eax,%eax
  802de6:	74 0d                	je     802df5 <insert_sorted_with_merge_freeList+0x12b>
  802de8:	a1 48 51 80 00       	mov    0x805148,%eax
  802ded:	8b 55 08             	mov    0x8(%ebp),%edx
  802df0:	89 50 04             	mov    %edx,0x4(%eax)
  802df3:	eb 08                	jmp    802dfd <insert_sorted_with_merge_freeList+0x133>
  802df5:	8b 45 08             	mov    0x8(%ebp),%eax
  802df8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802e00:	a3 48 51 80 00       	mov    %eax,0x805148
  802e05:	8b 45 08             	mov    0x8(%ebp),%eax
  802e08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0f:	a1 54 51 80 00       	mov    0x805154,%eax
  802e14:	40                   	inc    %eax
  802e15:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802e1a:	e9 04 06 00 00       	jmp    803423 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802e1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e23:	75 17                	jne    802e3c <insert_sorted_with_merge_freeList+0x172>
  802e25:	83 ec 04             	sub    $0x4,%esp
  802e28:	68 90 3f 80 00       	push   $0x803f90
  802e2d:	68 26 01 00 00       	push   $0x126
  802e32:	68 b3 3f 80 00       	push   $0x803fb3
  802e37:	e8 e2 d8 ff ff       	call   80071e <_panic>
  802e3c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	89 10                	mov    %edx,(%eax)
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	8b 00                	mov    (%eax),%eax
  802e4c:	85 c0                	test   %eax,%eax
  802e4e:	74 0d                	je     802e5d <insert_sorted_with_merge_freeList+0x193>
  802e50:	a1 38 51 80 00       	mov    0x805138,%eax
  802e55:	8b 55 08             	mov    0x8(%ebp),%edx
  802e58:	89 50 04             	mov    %edx,0x4(%eax)
  802e5b:	eb 08                	jmp    802e65 <insert_sorted_with_merge_freeList+0x19b>
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e65:	8b 45 08             	mov    0x8(%ebp),%eax
  802e68:	a3 38 51 80 00       	mov    %eax,0x805138
  802e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e77:	a1 44 51 80 00       	mov    0x805144,%eax
  802e7c:	40                   	inc    %eax
  802e7d:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802e82:	e9 9c 05 00 00       	jmp    803423 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	8b 50 08             	mov    0x8(%eax),%edx
  802e8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e90:	8b 40 08             	mov    0x8(%eax),%eax
  802e93:	39 c2                	cmp    %eax,%edx
  802e95:	0f 86 16 01 00 00    	jbe    802fb1 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802e9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ea1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea7:	01 c2                	add    %eax,%edx
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eac:	8b 40 08             	mov    0x8(%eax),%eax
  802eaf:	39 c2                	cmp    %eax,%edx
  802eb1:	0f 85 92 00 00 00    	jne    802f49 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802eb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eba:	8b 50 0c             	mov    0xc(%eax),%edx
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec3:	01 c2                	add    %eax,%edx
  802ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec8:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ece:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed8:	8b 50 08             	mov    0x8(%eax),%edx
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802ee1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee5:	75 17                	jne    802efe <insert_sorted_with_merge_freeList+0x234>
  802ee7:	83 ec 04             	sub    $0x4,%esp
  802eea:	68 90 3f 80 00       	push   $0x803f90
  802eef:	68 31 01 00 00       	push   $0x131
  802ef4:	68 b3 3f 80 00       	push   $0x803fb3
  802ef9:	e8 20 d8 ff ff       	call   80071e <_panic>
  802efe:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	89 10                	mov    %edx,(%eax)
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	8b 00                	mov    (%eax),%eax
  802f0e:	85 c0                	test   %eax,%eax
  802f10:	74 0d                	je     802f1f <insert_sorted_with_merge_freeList+0x255>
  802f12:	a1 48 51 80 00       	mov    0x805148,%eax
  802f17:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1a:	89 50 04             	mov    %edx,0x4(%eax)
  802f1d:	eb 08                	jmp    802f27 <insert_sorted_with_merge_freeList+0x25d>
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	a3 48 51 80 00       	mov    %eax,0x805148
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f39:	a1 54 51 80 00       	mov    0x805154,%eax
  802f3e:	40                   	inc    %eax
  802f3f:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802f44:	e9 da 04 00 00       	jmp    803423 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802f49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f4d:	75 17                	jne    802f66 <insert_sorted_with_merge_freeList+0x29c>
  802f4f:	83 ec 04             	sub    $0x4,%esp
  802f52:	68 38 40 80 00       	push   $0x804038
  802f57:	68 37 01 00 00       	push   $0x137
  802f5c:	68 b3 3f 80 00       	push   $0x803fb3
  802f61:	e8 b8 d7 ff ff       	call   80071e <_panic>
  802f66:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6f:	89 50 04             	mov    %edx,0x4(%eax)
  802f72:	8b 45 08             	mov    0x8(%ebp),%eax
  802f75:	8b 40 04             	mov    0x4(%eax),%eax
  802f78:	85 c0                	test   %eax,%eax
  802f7a:	74 0c                	je     802f88 <insert_sorted_with_merge_freeList+0x2be>
  802f7c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f81:	8b 55 08             	mov    0x8(%ebp),%edx
  802f84:	89 10                	mov    %edx,(%eax)
  802f86:	eb 08                	jmp    802f90 <insert_sorted_with_merge_freeList+0x2c6>
  802f88:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8b:	a3 38 51 80 00       	mov    %eax,0x805138
  802f90:	8b 45 08             	mov    0x8(%ebp),%eax
  802f93:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f98:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa1:	a1 44 51 80 00       	mov    0x805144,%eax
  802fa6:	40                   	inc    %eax
  802fa7:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802fac:	e9 72 04 00 00       	jmp    803423 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802fb1:	a1 38 51 80 00       	mov    0x805138,%eax
  802fb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb9:	e9 35 04 00 00       	jmp    8033f3 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc1:	8b 00                	mov    (%eax),%eax
  802fc3:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc9:	8b 50 08             	mov    0x8(%eax),%edx
  802fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcf:	8b 40 08             	mov    0x8(%eax),%eax
  802fd2:	39 c2                	cmp    %eax,%edx
  802fd4:	0f 86 11 04 00 00    	jbe    8033eb <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 50 08             	mov    0x8(%eax),%edx
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe6:	01 c2                	add    %eax,%edx
  802fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  802feb:	8b 40 08             	mov    0x8(%eax),%eax
  802fee:	39 c2                	cmp    %eax,%edx
  802ff0:	0f 83 8b 00 00 00    	jae    803081 <insert_sorted_with_merge_freeList+0x3b7>
  802ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff9:	8b 50 08             	mov    0x8(%eax),%edx
  802ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fff:	8b 40 0c             	mov    0xc(%eax),%eax
  803002:	01 c2                	add    %eax,%edx
  803004:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803007:	8b 40 08             	mov    0x8(%eax),%eax
  80300a:	39 c2                	cmp    %eax,%edx
  80300c:	73 73                	jae    803081 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  80300e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803012:	74 06                	je     80301a <insert_sorted_with_merge_freeList+0x350>
  803014:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803018:	75 17                	jne    803031 <insert_sorted_with_merge_freeList+0x367>
  80301a:	83 ec 04             	sub    $0x4,%esp
  80301d:	68 04 40 80 00       	push   $0x804004
  803022:	68 48 01 00 00       	push   $0x148
  803027:	68 b3 3f 80 00       	push   $0x803fb3
  80302c:	e8 ed d6 ff ff       	call   80071e <_panic>
  803031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803034:	8b 10                	mov    (%eax),%edx
  803036:	8b 45 08             	mov    0x8(%ebp),%eax
  803039:	89 10                	mov    %edx,(%eax)
  80303b:	8b 45 08             	mov    0x8(%ebp),%eax
  80303e:	8b 00                	mov    (%eax),%eax
  803040:	85 c0                	test   %eax,%eax
  803042:	74 0b                	je     80304f <insert_sorted_with_merge_freeList+0x385>
  803044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803047:	8b 00                	mov    (%eax),%eax
  803049:	8b 55 08             	mov    0x8(%ebp),%edx
  80304c:	89 50 04             	mov    %edx,0x4(%eax)
  80304f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803052:	8b 55 08             	mov    0x8(%ebp),%edx
  803055:	89 10                	mov    %edx,(%eax)
  803057:	8b 45 08             	mov    0x8(%ebp),%eax
  80305a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80305d:	89 50 04             	mov    %edx,0x4(%eax)
  803060:	8b 45 08             	mov    0x8(%ebp),%eax
  803063:	8b 00                	mov    (%eax),%eax
  803065:	85 c0                	test   %eax,%eax
  803067:	75 08                	jne    803071 <insert_sorted_with_merge_freeList+0x3a7>
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803071:	a1 44 51 80 00       	mov    0x805144,%eax
  803076:	40                   	inc    %eax
  803077:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  80307c:	e9 a2 03 00 00       	jmp    803423 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	8b 50 08             	mov    0x8(%eax),%edx
  803087:	8b 45 08             	mov    0x8(%ebp),%eax
  80308a:	8b 40 0c             	mov    0xc(%eax),%eax
  80308d:	01 c2                	add    %eax,%edx
  80308f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803092:	8b 40 08             	mov    0x8(%eax),%eax
  803095:	39 c2                	cmp    %eax,%edx
  803097:	0f 83 ae 00 00 00    	jae    80314b <insert_sorted_with_merge_freeList+0x481>
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	8b 50 08             	mov    0x8(%eax),%edx
  8030a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a6:	8b 48 08             	mov    0x8(%eax),%ecx
  8030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8030af:	01 c8                	add    %ecx,%eax
  8030b1:	39 c2                	cmp    %eax,%edx
  8030b3:	0f 85 92 00 00 00    	jne    80314b <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  8030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bc:	8b 50 0c             	mov    0xc(%eax),%edx
  8030bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c5:	01 c2                	add    %eax,%edx
  8030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ca:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  8030cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030da:	8b 50 08             	mov    0x8(%eax),%edx
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8030e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e7:	75 17                	jne    803100 <insert_sorted_with_merge_freeList+0x436>
  8030e9:	83 ec 04             	sub    $0x4,%esp
  8030ec:	68 90 3f 80 00       	push   $0x803f90
  8030f1:	68 51 01 00 00       	push   $0x151
  8030f6:	68 b3 3f 80 00       	push   $0x803fb3
  8030fb:	e8 1e d6 ff ff       	call   80071e <_panic>
  803100:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803106:	8b 45 08             	mov    0x8(%ebp),%eax
  803109:	89 10                	mov    %edx,(%eax)
  80310b:	8b 45 08             	mov    0x8(%ebp),%eax
  80310e:	8b 00                	mov    (%eax),%eax
  803110:	85 c0                	test   %eax,%eax
  803112:	74 0d                	je     803121 <insert_sorted_with_merge_freeList+0x457>
  803114:	a1 48 51 80 00       	mov    0x805148,%eax
  803119:	8b 55 08             	mov    0x8(%ebp),%edx
  80311c:	89 50 04             	mov    %edx,0x4(%eax)
  80311f:	eb 08                	jmp    803129 <insert_sorted_with_merge_freeList+0x45f>
  803121:	8b 45 08             	mov    0x8(%ebp),%eax
  803124:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803129:	8b 45 08             	mov    0x8(%ebp),%eax
  80312c:	a3 48 51 80 00       	mov    %eax,0x805148
  803131:	8b 45 08             	mov    0x8(%ebp),%eax
  803134:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313b:	a1 54 51 80 00       	mov    0x805154,%eax
  803140:	40                   	inc    %eax
  803141:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  803146:	e9 d8 02 00 00       	jmp    803423 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	8b 50 08             	mov    0x8(%eax),%edx
  803151:	8b 45 08             	mov    0x8(%ebp),%eax
  803154:	8b 40 0c             	mov    0xc(%eax),%eax
  803157:	01 c2                	add    %eax,%edx
  803159:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315c:	8b 40 08             	mov    0x8(%eax),%eax
  80315f:	39 c2                	cmp    %eax,%edx
  803161:	0f 85 ba 00 00 00    	jne    803221 <insert_sorted_with_merge_freeList+0x557>
  803167:	8b 45 08             	mov    0x8(%ebp),%eax
  80316a:	8b 50 08             	mov    0x8(%eax),%edx
  80316d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803170:	8b 48 08             	mov    0x8(%eax),%ecx
  803173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803176:	8b 40 0c             	mov    0xc(%eax),%eax
  803179:	01 c8                	add    %ecx,%eax
  80317b:	39 c2                	cmp    %eax,%edx
  80317d:	0f 86 9e 00 00 00    	jbe    803221 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  803183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803186:	8b 50 0c             	mov    0xc(%eax),%edx
  803189:	8b 45 08             	mov    0x8(%ebp),%eax
  80318c:	8b 40 0c             	mov    0xc(%eax),%eax
  80318f:	01 c2                	add    %eax,%edx
  803191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803194:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	8b 50 08             	mov    0x8(%eax),%edx
  80319d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a0:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b0:	8b 50 08             	mov    0x8(%eax),%edx
  8031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b6:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8031b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031bd:	75 17                	jne    8031d6 <insert_sorted_with_merge_freeList+0x50c>
  8031bf:	83 ec 04             	sub    $0x4,%esp
  8031c2:	68 90 3f 80 00       	push   $0x803f90
  8031c7:	68 5b 01 00 00       	push   $0x15b
  8031cc:	68 b3 3f 80 00       	push   $0x803fb3
  8031d1:	e8 48 d5 ff ff       	call   80071e <_panic>
  8031d6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031df:	89 10                	mov    %edx,(%eax)
  8031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e4:	8b 00                	mov    (%eax),%eax
  8031e6:	85 c0                	test   %eax,%eax
  8031e8:	74 0d                	je     8031f7 <insert_sorted_with_merge_freeList+0x52d>
  8031ea:	a1 48 51 80 00       	mov    0x805148,%eax
  8031ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f2:	89 50 04             	mov    %edx,0x4(%eax)
  8031f5:	eb 08                	jmp    8031ff <insert_sorted_with_merge_freeList+0x535>
  8031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803202:	a3 48 51 80 00       	mov    %eax,0x805148
  803207:	8b 45 08             	mov    0x8(%ebp),%eax
  80320a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803211:	a1 54 51 80 00       	mov    0x805154,%eax
  803216:	40                   	inc    %eax
  803217:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  80321c:	e9 02 02 00 00       	jmp    803423 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803221:	8b 45 08             	mov    0x8(%ebp),%eax
  803224:	8b 50 08             	mov    0x8(%eax),%edx
  803227:	8b 45 08             	mov    0x8(%ebp),%eax
  80322a:	8b 40 0c             	mov    0xc(%eax),%eax
  80322d:	01 c2                	add    %eax,%edx
  80322f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803232:	8b 40 08             	mov    0x8(%eax),%eax
  803235:	39 c2                	cmp    %eax,%edx
  803237:	0f 85 ae 01 00 00    	jne    8033eb <insert_sorted_with_merge_freeList+0x721>
  80323d:	8b 45 08             	mov    0x8(%ebp),%eax
  803240:	8b 50 08             	mov    0x8(%eax),%edx
  803243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803246:	8b 48 08             	mov    0x8(%eax),%ecx
  803249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324c:	8b 40 0c             	mov    0xc(%eax),%eax
  80324f:	01 c8                	add    %ecx,%eax
  803251:	39 c2                	cmp    %eax,%edx
  803253:	0f 85 92 01 00 00    	jne    8033eb <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  803259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325c:	8b 50 0c             	mov    0xc(%eax),%edx
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	8b 40 0c             	mov    0xc(%eax),%eax
  803265:	01 c2                	add    %eax,%edx
  803267:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326a:	8b 40 0c             	mov    0xc(%eax),%eax
  80326d:	01 c2                	add    %eax,%edx
  80326f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803272:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	8b 50 08             	mov    0x8(%eax),%edx
  803285:	8b 45 08             	mov    0x8(%ebp),%eax
  803288:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  80328b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803295:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803298:	8b 50 08             	mov    0x8(%eax),%edx
  80329b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329e:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  8032a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032a5:	75 17                	jne    8032be <insert_sorted_with_merge_freeList+0x5f4>
  8032a7:	83 ec 04             	sub    $0x4,%esp
  8032aa:	68 5b 40 80 00       	push   $0x80405b
  8032af:	68 63 01 00 00       	push   $0x163
  8032b4:	68 b3 3f 80 00       	push   $0x803fb3
  8032b9:	e8 60 d4 ff ff       	call   80071e <_panic>
  8032be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c1:	8b 00                	mov    (%eax),%eax
  8032c3:	85 c0                	test   %eax,%eax
  8032c5:	74 10                	je     8032d7 <insert_sorted_with_merge_freeList+0x60d>
  8032c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ca:	8b 00                	mov    (%eax),%eax
  8032cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032cf:	8b 52 04             	mov    0x4(%edx),%edx
  8032d2:	89 50 04             	mov    %edx,0x4(%eax)
  8032d5:	eb 0b                	jmp    8032e2 <insert_sorted_with_merge_freeList+0x618>
  8032d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032da:	8b 40 04             	mov    0x4(%eax),%eax
  8032dd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e5:	8b 40 04             	mov    0x4(%eax),%eax
  8032e8:	85 c0                	test   %eax,%eax
  8032ea:	74 0f                	je     8032fb <insert_sorted_with_merge_freeList+0x631>
  8032ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ef:	8b 40 04             	mov    0x4(%eax),%eax
  8032f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032f5:	8b 12                	mov    (%edx),%edx
  8032f7:	89 10                	mov    %edx,(%eax)
  8032f9:	eb 0a                	jmp    803305 <insert_sorted_with_merge_freeList+0x63b>
  8032fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fe:	8b 00                	mov    (%eax),%eax
  803300:	a3 38 51 80 00       	mov    %eax,0x805138
  803305:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803308:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80330e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803311:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803318:	a1 44 51 80 00       	mov    0x805144,%eax
  80331d:	48                   	dec    %eax
  80331e:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  803323:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803327:	75 17                	jne    803340 <insert_sorted_with_merge_freeList+0x676>
  803329:	83 ec 04             	sub    $0x4,%esp
  80332c:	68 90 3f 80 00       	push   $0x803f90
  803331:	68 64 01 00 00       	push   $0x164
  803336:	68 b3 3f 80 00       	push   $0x803fb3
  80333b:	e8 de d3 ff ff       	call   80071e <_panic>
  803340:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803346:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803349:	89 10                	mov    %edx,(%eax)
  80334b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334e:	8b 00                	mov    (%eax),%eax
  803350:	85 c0                	test   %eax,%eax
  803352:	74 0d                	je     803361 <insert_sorted_with_merge_freeList+0x697>
  803354:	a1 48 51 80 00       	mov    0x805148,%eax
  803359:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80335c:	89 50 04             	mov    %edx,0x4(%eax)
  80335f:	eb 08                	jmp    803369 <insert_sorted_with_merge_freeList+0x69f>
  803361:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803364:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803369:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336c:	a3 48 51 80 00       	mov    %eax,0x805148
  803371:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803374:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80337b:	a1 54 51 80 00       	mov    0x805154,%eax
  803380:	40                   	inc    %eax
  803381:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803386:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80338a:	75 17                	jne    8033a3 <insert_sorted_with_merge_freeList+0x6d9>
  80338c:	83 ec 04             	sub    $0x4,%esp
  80338f:	68 90 3f 80 00       	push   $0x803f90
  803394:	68 65 01 00 00       	push   $0x165
  803399:	68 b3 3f 80 00       	push   $0x803fb3
  80339e:	e8 7b d3 ff ff       	call   80071e <_panic>
  8033a3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ac:	89 10                	mov    %edx,(%eax)
  8033ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b1:	8b 00                	mov    (%eax),%eax
  8033b3:	85 c0                	test   %eax,%eax
  8033b5:	74 0d                	je     8033c4 <insert_sorted_with_merge_freeList+0x6fa>
  8033b7:	a1 48 51 80 00       	mov    0x805148,%eax
  8033bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8033bf:	89 50 04             	mov    %edx,0x4(%eax)
  8033c2:	eb 08                	jmp    8033cc <insert_sorted_with_merge_freeList+0x702>
  8033c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cf:	a3 48 51 80 00       	mov    %eax,0x805148
  8033d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033de:	a1 54 51 80 00       	mov    0x805154,%eax
  8033e3:	40                   	inc    %eax
  8033e4:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8033e9:	eb 38                	jmp    803423 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8033eb:	a1 40 51 80 00       	mov    0x805140,%eax
  8033f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f7:	74 07                	je     803400 <insert_sorted_with_merge_freeList+0x736>
  8033f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fc:	8b 00                	mov    (%eax),%eax
  8033fe:	eb 05                	jmp    803405 <insert_sorted_with_merge_freeList+0x73b>
  803400:	b8 00 00 00 00       	mov    $0x0,%eax
  803405:	a3 40 51 80 00       	mov    %eax,0x805140
  80340a:	a1 40 51 80 00       	mov    0x805140,%eax
  80340f:	85 c0                	test   %eax,%eax
  803411:	0f 85 a7 fb ff ff    	jne    802fbe <insert_sorted_with_merge_freeList+0x2f4>
  803417:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80341b:	0f 85 9d fb ff ff    	jne    802fbe <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  803421:	eb 00                	jmp    803423 <insert_sorted_with_merge_freeList+0x759>
  803423:	90                   	nop
  803424:	c9                   	leave  
  803425:	c3                   	ret    

00803426 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803426:	55                   	push   %ebp
  803427:	89 e5                	mov    %esp,%ebp
  803429:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80342c:	8b 55 08             	mov    0x8(%ebp),%edx
  80342f:	89 d0                	mov    %edx,%eax
  803431:	c1 e0 02             	shl    $0x2,%eax
  803434:	01 d0                	add    %edx,%eax
  803436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80343d:	01 d0                	add    %edx,%eax
  80343f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803446:	01 d0                	add    %edx,%eax
  803448:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80344f:	01 d0                	add    %edx,%eax
  803451:	c1 e0 04             	shl    $0x4,%eax
  803454:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803457:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80345e:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803461:	83 ec 0c             	sub    $0xc,%esp
  803464:	50                   	push   %eax
  803465:	e8 ee eb ff ff       	call   802058 <sys_get_virtual_time>
  80346a:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80346d:	eb 41                	jmp    8034b0 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80346f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803472:	83 ec 0c             	sub    $0xc,%esp
  803475:	50                   	push   %eax
  803476:	e8 dd eb ff ff       	call   802058 <sys_get_virtual_time>
  80347b:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80347e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803481:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803484:	29 c2                	sub    %eax,%edx
  803486:	89 d0                	mov    %edx,%eax
  803488:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80348b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80348e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803491:	89 d1                	mov    %edx,%ecx
  803493:	29 c1                	sub    %eax,%ecx
  803495:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803498:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80349b:	39 c2                	cmp    %eax,%edx
  80349d:	0f 97 c0             	seta   %al
  8034a0:	0f b6 c0             	movzbl %al,%eax
  8034a3:	29 c1                	sub    %eax,%ecx
  8034a5:	89 c8                	mov    %ecx,%eax
  8034a7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8034aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8034b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8034b6:	72 b7                	jb     80346f <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8034b8:	90                   	nop
  8034b9:	c9                   	leave  
  8034ba:	c3                   	ret    

008034bb <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8034bb:	55                   	push   %ebp
  8034bc:	89 e5                	mov    %esp,%ebp
  8034be:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8034c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8034c8:	eb 03                	jmp    8034cd <busy_wait+0x12>
  8034ca:	ff 45 fc             	incl   -0x4(%ebp)
  8034cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8034d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034d3:	72 f5                	jb     8034ca <busy_wait+0xf>
	return i;
  8034d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8034d8:	c9                   	leave  
  8034d9:	c3                   	ret    
  8034da:	66 90                	xchg   %ax,%ax

008034dc <__udivdi3>:
  8034dc:	55                   	push   %ebp
  8034dd:	57                   	push   %edi
  8034de:	56                   	push   %esi
  8034df:	53                   	push   %ebx
  8034e0:	83 ec 1c             	sub    $0x1c,%esp
  8034e3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034e7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034f3:	89 ca                	mov    %ecx,%edx
  8034f5:	89 f8                	mov    %edi,%eax
  8034f7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034fb:	85 f6                	test   %esi,%esi
  8034fd:	75 2d                	jne    80352c <__udivdi3+0x50>
  8034ff:	39 cf                	cmp    %ecx,%edi
  803501:	77 65                	ja     803568 <__udivdi3+0x8c>
  803503:	89 fd                	mov    %edi,%ebp
  803505:	85 ff                	test   %edi,%edi
  803507:	75 0b                	jne    803514 <__udivdi3+0x38>
  803509:	b8 01 00 00 00       	mov    $0x1,%eax
  80350e:	31 d2                	xor    %edx,%edx
  803510:	f7 f7                	div    %edi
  803512:	89 c5                	mov    %eax,%ebp
  803514:	31 d2                	xor    %edx,%edx
  803516:	89 c8                	mov    %ecx,%eax
  803518:	f7 f5                	div    %ebp
  80351a:	89 c1                	mov    %eax,%ecx
  80351c:	89 d8                	mov    %ebx,%eax
  80351e:	f7 f5                	div    %ebp
  803520:	89 cf                	mov    %ecx,%edi
  803522:	89 fa                	mov    %edi,%edx
  803524:	83 c4 1c             	add    $0x1c,%esp
  803527:	5b                   	pop    %ebx
  803528:	5e                   	pop    %esi
  803529:	5f                   	pop    %edi
  80352a:	5d                   	pop    %ebp
  80352b:	c3                   	ret    
  80352c:	39 ce                	cmp    %ecx,%esi
  80352e:	77 28                	ja     803558 <__udivdi3+0x7c>
  803530:	0f bd fe             	bsr    %esi,%edi
  803533:	83 f7 1f             	xor    $0x1f,%edi
  803536:	75 40                	jne    803578 <__udivdi3+0x9c>
  803538:	39 ce                	cmp    %ecx,%esi
  80353a:	72 0a                	jb     803546 <__udivdi3+0x6a>
  80353c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803540:	0f 87 9e 00 00 00    	ja     8035e4 <__udivdi3+0x108>
  803546:	b8 01 00 00 00       	mov    $0x1,%eax
  80354b:	89 fa                	mov    %edi,%edx
  80354d:	83 c4 1c             	add    $0x1c,%esp
  803550:	5b                   	pop    %ebx
  803551:	5e                   	pop    %esi
  803552:	5f                   	pop    %edi
  803553:	5d                   	pop    %ebp
  803554:	c3                   	ret    
  803555:	8d 76 00             	lea    0x0(%esi),%esi
  803558:	31 ff                	xor    %edi,%edi
  80355a:	31 c0                	xor    %eax,%eax
  80355c:	89 fa                	mov    %edi,%edx
  80355e:	83 c4 1c             	add    $0x1c,%esp
  803561:	5b                   	pop    %ebx
  803562:	5e                   	pop    %esi
  803563:	5f                   	pop    %edi
  803564:	5d                   	pop    %ebp
  803565:	c3                   	ret    
  803566:	66 90                	xchg   %ax,%ax
  803568:	89 d8                	mov    %ebx,%eax
  80356a:	f7 f7                	div    %edi
  80356c:	31 ff                	xor    %edi,%edi
  80356e:	89 fa                	mov    %edi,%edx
  803570:	83 c4 1c             	add    $0x1c,%esp
  803573:	5b                   	pop    %ebx
  803574:	5e                   	pop    %esi
  803575:	5f                   	pop    %edi
  803576:	5d                   	pop    %ebp
  803577:	c3                   	ret    
  803578:	bd 20 00 00 00       	mov    $0x20,%ebp
  80357d:	89 eb                	mov    %ebp,%ebx
  80357f:	29 fb                	sub    %edi,%ebx
  803581:	89 f9                	mov    %edi,%ecx
  803583:	d3 e6                	shl    %cl,%esi
  803585:	89 c5                	mov    %eax,%ebp
  803587:	88 d9                	mov    %bl,%cl
  803589:	d3 ed                	shr    %cl,%ebp
  80358b:	89 e9                	mov    %ebp,%ecx
  80358d:	09 f1                	or     %esi,%ecx
  80358f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803593:	89 f9                	mov    %edi,%ecx
  803595:	d3 e0                	shl    %cl,%eax
  803597:	89 c5                	mov    %eax,%ebp
  803599:	89 d6                	mov    %edx,%esi
  80359b:	88 d9                	mov    %bl,%cl
  80359d:	d3 ee                	shr    %cl,%esi
  80359f:	89 f9                	mov    %edi,%ecx
  8035a1:	d3 e2                	shl    %cl,%edx
  8035a3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035a7:	88 d9                	mov    %bl,%cl
  8035a9:	d3 e8                	shr    %cl,%eax
  8035ab:	09 c2                	or     %eax,%edx
  8035ad:	89 d0                	mov    %edx,%eax
  8035af:	89 f2                	mov    %esi,%edx
  8035b1:	f7 74 24 0c          	divl   0xc(%esp)
  8035b5:	89 d6                	mov    %edx,%esi
  8035b7:	89 c3                	mov    %eax,%ebx
  8035b9:	f7 e5                	mul    %ebp
  8035bb:	39 d6                	cmp    %edx,%esi
  8035bd:	72 19                	jb     8035d8 <__udivdi3+0xfc>
  8035bf:	74 0b                	je     8035cc <__udivdi3+0xf0>
  8035c1:	89 d8                	mov    %ebx,%eax
  8035c3:	31 ff                	xor    %edi,%edi
  8035c5:	e9 58 ff ff ff       	jmp    803522 <__udivdi3+0x46>
  8035ca:	66 90                	xchg   %ax,%ax
  8035cc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035d0:	89 f9                	mov    %edi,%ecx
  8035d2:	d3 e2                	shl    %cl,%edx
  8035d4:	39 c2                	cmp    %eax,%edx
  8035d6:	73 e9                	jae    8035c1 <__udivdi3+0xe5>
  8035d8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035db:	31 ff                	xor    %edi,%edi
  8035dd:	e9 40 ff ff ff       	jmp    803522 <__udivdi3+0x46>
  8035e2:	66 90                	xchg   %ax,%ax
  8035e4:	31 c0                	xor    %eax,%eax
  8035e6:	e9 37 ff ff ff       	jmp    803522 <__udivdi3+0x46>
  8035eb:	90                   	nop

008035ec <__umoddi3>:
  8035ec:	55                   	push   %ebp
  8035ed:	57                   	push   %edi
  8035ee:	56                   	push   %esi
  8035ef:	53                   	push   %ebx
  8035f0:	83 ec 1c             	sub    $0x1c,%esp
  8035f3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035f7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035ff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803603:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803607:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80360b:	89 f3                	mov    %esi,%ebx
  80360d:	89 fa                	mov    %edi,%edx
  80360f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803613:	89 34 24             	mov    %esi,(%esp)
  803616:	85 c0                	test   %eax,%eax
  803618:	75 1a                	jne    803634 <__umoddi3+0x48>
  80361a:	39 f7                	cmp    %esi,%edi
  80361c:	0f 86 a2 00 00 00    	jbe    8036c4 <__umoddi3+0xd8>
  803622:	89 c8                	mov    %ecx,%eax
  803624:	89 f2                	mov    %esi,%edx
  803626:	f7 f7                	div    %edi
  803628:	89 d0                	mov    %edx,%eax
  80362a:	31 d2                	xor    %edx,%edx
  80362c:	83 c4 1c             	add    $0x1c,%esp
  80362f:	5b                   	pop    %ebx
  803630:	5e                   	pop    %esi
  803631:	5f                   	pop    %edi
  803632:	5d                   	pop    %ebp
  803633:	c3                   	ret    
  803634:	39 f0                	cmp    %esi,%eax
  803636:	0f 87 ac 00 00 00    	ja     8036e8 <__umoddi3+0xfc>
  80363c:	0f bd e8             	bsr    %eax,%ebp
  80363f:	83 f5 1f             	xor    $0x1f,%ebp
  803642:	0f 84 ac 00 00 00    	je     8036f4 <__umoddi3+0x108>
  803648:	bf 20 00 00 00       	mov    $0x20,%edi
  80364d:	29 ef                	sub    %ebp,%edi
  80364f:	89 fe                	mov    %edi,%esi
  803651:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803655:	89 e9                	mov    %ebp,%ecx
  803657:	d3 e0                	shl    %cl,%eax
  803659:	89 d7                	mov    %edx,%edi
  80365b:	89 f1                	mov    %esi,%ecx
  80365d:	d3 ef                	shr    %cl,%edi
  80365f:	09 c7                	or     %eax,%edi
  803661:	89 e9                	mov    %ebp,%ecx
  803663:	d3 e2                	shl    %cl,%edx
  803665:	89 14 24             	mov    %edx,(%esp)
  803668:	89 d8                	mov    %ebx,%eax
  80366a:	d3 e0                	shl    %cl,%eax
  80366c:	89 c2                	mov    %eax,%edx
  80366e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803672:	d3 e0                	shl    %cl,%eax
  803674:	89 44 24 04          	mov    %eax,0x4(%esp)
  803678:	8b 44 24 08          	mov    0x8(%esp),%eax
  80367c:	89 f1                	mov    %esi,%ecx
  80367e:	d3 e8                	shr    %cl,%eax
  803680:	09 d0                	or     %edx,%eax
  803682:	d3 eb                	shr    %cl,%ebx
  803684:	89 da                	mov    %ebx,%edx
  803686:	f7 f7                	div    %edi
  803688:	89 d3                	mov    %edx,%ebx
  80368a:	f7 24 24             	mull   (%esp)
  80368d:	89 c6                	mov    %eax,%esi
  80368f:	89 d1                	mov    %edx,%ecx
  803691:	39 d3                	cmp    %edx,%ebx
  803693:	0f 82 87 00 00 00    	jb     803720 <__umoddi3+0x134>
  803699:	0f 84 91 00 00 00    	je     803730 <__umoddi3+0x144>
  80369f:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036a3:	29 f2                	sub    %esi,%edx
  8036a5:	19 cb                	sbb    %ecx,%ebx
  8036a7:	89 d8                	mov    %ebx,%eax
  8036a9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036ad:	d3 e0                	shl    %cl,%eax
  8036af:	89 e9                	mov    %ebp,%ecx
  8036b1:	d3 ea                	shr    %cl,%edx
  8036b3:	09 d0                	or     %edx,%eax
  8036b5:	89 e9                	mov    %ebp,%ecx
  8036b7:	d3 eb                	shr    %cl,%ebx
  8036b9:	89 da                	mov    %ebx,%edx
  8036bb:	83 c4 1c             	add    $0x1c,%esp
  8036be:	5b                   	pop    %ebx
  8036bf:	5e                   	pop    %esi
  8036c0:	5f                   	pop    %edi
  8036c1:	5d                   	pop    %ebp
  8036c2:	c3                   	ret    
  8036c3:	90                   	nop
  8036c4:	89 fd                	mov    %edi,%ebp
  8036c6:	85 ff                	test   %edi,%edi
  8036c8:	75 0b                	jne    8036d5 <__umoddi3+0xe9>
  8036ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8036cf:	31 d2                	xor    %edx,%edx
  8036d1:	f7 f7                	div    %edi
  8036d3:	89 c5                	mov    %eax,%ebp
  8036d5:	89 f0                	mov    %esi,%eax
  8036d7:	31 d2                	xor    %edx,%edx
  8036d9:	f7 f5                	div    %ebp
  8036db:	89 c8                	mov    %ecx,%eax
  8036dd:	f7 f5                	div    %ebp
  8036df:	89 d0                	mov    %edx,%eax
  8036e1:	e9 44 ff ff ff       	jmp    80362a <__umoddi3+0x3e>
  8036e6:	66 90                	xchg   %ax,%ax
  8036e8:	89 c8                	mov    %ecx,%eax
  8036ea:	89 f2                	mov    %esi,%edx
  8036ec:	83 c4 1c             	add    $0x1c,%esp
  8036ef:	5b                   	pop    %ebx
  8036f0:	5e                   	pop    %esi
  8036f1:	5f                   	pop    %edi
  8036f2:	5d                   	pop    %ebp
  8036f3:	c3                   	ret    
  8036f4:	3b 04 24             	cmp    (%esp),%eax
  8036f7:	72 06                	jb     8036ff <__umoddi3+0x113>
  8036f9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036fd:	77 0f                	ja     80370e <__umoddi3+0x122>
  8036ff:	89 f2                	mov    %esi,%edx
  803701:	29 f9                	sub    %edi,%ecx
  803703:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803707:	89 14 24             	mov    %edx,(%esp)
  80370a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80370e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803712:	8b 14 24             	mov    (%esp),%edx
  803715:	83 c4 1c             	add    $0x1c,%esp
  803718:	5b                   	pop    %ebx
  803719:	5e                   	pop    %esi
  80371a:	5f                   	pop    %edi
  80371b:	5d                   	pop    %ebp
  80371c:	c3                   	ret    
  80371d:	8d 76 00             	lea    0x0(%esi),%esi
  803720:	2b 04 24             	sub    (%esp),%eax
  803723:	19 fa                	sbb    %edi,%edx
  803725:	89 d1                	mov    %edx,%ecx
  803727:	89 c6                	mov    %eax,%esi
  803729:	e9 71 ff ff ff       	jmp    80369f <__umoddi3+0xb3>
  80372e:	66 90                	xchg   %ax,%ax
  803730:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803734:	72 ea                	jb     803720 <__umoddi3+0x134>
  803736:	89 d9                	mov    %ebx,%ecx
  803738:	e9 62 ff ff ff       	jmp    80369f <__umoddi3+0xb3>
