
obj/user/ef_tst_sharing_1:     file format elf32-i386


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
  800031:	e8 64 03 00 00       	call   80039a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 40 80 00       	mov    0x804020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 60 34 80 00       	push   $0x803460
  800092:	6a 12                	push   $0x12
  800094:	68 7c 34 80 00       	push   $0x80347c
  800099:	e8 38 04 00 00       	call   8004d6 <_panic>
	}

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 94 34 80 00       	push   $0x803494
  8000a6:	e8 df 06 00 00       	call   80078a <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ae:	e8 31 1a 00 00       	call   801ae4 <sys_calculate_free_frames>
  8000b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	6a 01                	push   $0x1
  8000bb:	68 00 10 00 00       	push   $0x1000
  8000c0:	68 cb 34 80 00       	push   $0x8034cb
  8000c5:	e8 3b 17 00 00       	call   801805 <smalloc>
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000d0:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d7:	74 14                	je     8000ed <_main+0xb5>
  8000d9:	83 ec 04             	sub    $0x4,%esp
  8000dc:	68 d0 34 80 00       	push   $0x8034d0
  8000e1:	6a 1a                	push   $0x1a
  8000e3:	68 7c 34 80 00       	push   $0x80347c
  8000e8:	e8 e9 03 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f0:	e8 ef 19 00 00       	call   801ae4 <sys_calculate_free_frames>
  8000f5:	29 c3                	sub    %eax,%ebx
  8000f7:	89 d8                	mov    %ebx,%eax
  8000f9:	83 f8 04             	cmp    $0x4,%eax
  8000fc:	74 28                	je     800126 <_main+0xee>
  8000fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800101:	e8 de 19 00 00       	call   801ae4 <sys_calculate_free_frames>
  800106:	29 c3                	sub    %eax,%ebx
  800108:	e8 d7 19 00 00       	call   801ae4 <sys_calculate_free_frames>
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	53                   	push   %ebx
  800111:	50                   	push   %eax
  800112:	ff 75 e8             	pushl  -0x18(%ebp)
  800115:	68 3c 35 80 00       	push   $0x80353c
  80011a:	6a 1b                	push   $0x1b
  80011c:	68 7c 34 80 00       	push   $0x80347c
  800121:	e8 b0 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800126:	e8 b9 19 00 00       	call   801ae4 <sys_calculate_free_frames>
  80012b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("y", PAGE_SIZE + 4, 1);
  80012e:	83 ec 04             	sub    $0x4,%esp
  800131:	6a 01                	push   $0x1
  800133:	68 04 10 00 00       	push   $0x1004
  800138:	68 c3 35 80 00       	push   $0x8035c3
  80013d:	e8 c3 16 00 00       	call   801805 <smalloc>
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800148:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 d0 34 80 00       	push   $0x8034d0
  800159:	6a 1f                	push   $0x1f
  80015b:	68 7c 34 80 00       	push   $0x80347c
  800160:	e8 71 03 00 00       	call   8004d6 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  800165:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800168:	e8 77 19 00 00       	call   801ae4 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	83 f8 04             	cmp    $0x4,%eax
  800174:	74 28                	je     80019e <_main+0x166>
  800176:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800179:	e8 66 19 00 00       	call   801ae4 <sys_calculate_free_frames>
  80017e:	29 c3                	sub    %eax,%ebx
  800180:	e8 5f 19 00 00       	call   801ae4 <sys_calculate_free_frames>
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	53                   	push   %ebx
  800189:	50                   	push   %eax
  80018a:	ff 75 e8             	pushl  -0x18(%ebp)
  80018d:	68 3c 35 80 00       	push   $0x80353c
  800192:	6a 21                	push   $0x21
  800194:	68 7c 34 80 00       	push   $0x80347c
  800199:	e8 38 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019e:	e8 41 19 00 00       	call   801ae4 <sys_calculate_free_frames>
  8001a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("z", 4, 1);
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	6a 01                	push   $0x1
  8001ab:	6a 04                	push   $0x4
  8001ad:	68 c5 35 80 00       	push   $0x8035c5
  8001b2:	e8 4e 16 00 00       	call   801805 <smalloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001bd:	81 7d dc 00 30 00 80 	cmpl   $0x80003000,-0x24(%ebp)
  8001c4:	74 14                	je     8001da <_main+0x1a2>
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 d0 34 80 00       	push   $0x8034d0
  8001ce:	6a 25                	push   $0x25
  8001d0:	68 7c 34 80 00       	push   $0x80347c
  8001d5:	e8 fc 02 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001da:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001dd:	e8 02 19 00 00       	call   801ae4 <sys_calculate_free_frames>
  8001e2:	29 c3                	sub    %eax,%ebx
  8001e4:	89 d8                	mov    %ebx,%eax
  8001e6:	83 f8 03             	cmp    $0x3,%eax
  8001e9:	74 14                	je     8001ff <_main+0x1c7>
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	68 c8 35 80 00       	push   $0x8035c8
  8001f3:	6a 26                	push   $0x26
  8001f5:	68 7c 34 80 00       	push   $0x80347c
  8001fa:	e8 d7 02 00 00       	call   8004d6 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	68 48 36 80 00       	push   $0x803648
  800207:	e8 7e 05 00 00       	call   80078a <cprintf>
  80020c:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	68 70 36 80 00       	push   $0x803670
  800217:	e8 6e 05 00 00       	call   80078a <cprintf>
  80021c:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  80021f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  800226:	eb 2d                	jmp    800255 <_main+0x21d>
		{
			x[i] = -1;
  800228:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80022b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800232:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800235:	01 d0                	add    %edx,%eax
  800237:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  80023d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800240:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800247:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80024a:	01 d0                	add    %edx,%eax
  80024c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  800252:	ff 45 ec             	incl   -0x14(%ebp)
  800255:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  80025c:	7e ca                	jle    800228 <_main+0x1f0>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  80025e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  800265:	eb 18                	jmp    80027f <_main+0x247>
		{
			z[i] = -1;
  800267:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80026a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800271:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800274:	01 d0                	add    %edx,%eax
  800276:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  80027c:	ff 45 ec             	incl   -0x14(%ebp)
  80027f:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800286:	7e df                	jle    800267 <_main+0x22f>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800288:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028b:	8b 00                	mov    (%eax),%eax
  80028d:	83 f8 ff             	cmp    $0xffffffff,%eax
  800290:	74 14                	je     8002a6 <_main+0x26e>
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	68 98 36 80 00       	push   $0x803698
  80029a:	6a 3a                	push   $0x3a
  80029c:	68 7c 34 80 00       	push   $0x80347c
  8002a1:	e8 30 02 00 00       	call   8004d6 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b3:	74 14                	je     8002c9 <_main+0x291>
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	68 98 36 80 00       	push   $0x803698
  8002bd:	6a 3b                	push   $0x3b
  8002bf:	68 7c 34 80 00       	push   $0x80347c
  8002c4:	e8 0d 02 00 00       	call   8004d6 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d1:	74 14                	je     8002e7 <_main+0x2af>
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	68 98 36 80 00       	push   $0x803698
  8002db:	6a 3d                	push   $0x3d
  8002dd:	68 7c 34 80 00       	push   $0x80347c
  8002e2:	e8 ef 01 00 00       	call   8004d6 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ea:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ef:	8b 00                	mov    (%eax),%eax
  8002f1:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f4:	74 14                	je     80030a <_main+0x2d2>
  8002f6:	83 ec 04             	sub    $0x4,%esp
  8002f9:	68 98 36 80 00       	push   $0x803698
  8002fe:	6a 3e                	push   $0x3e
  800300:	68 7c 34 80 00       	push   $0x80347c
  800305:	e8 cc 01 00 00       	call   8004d6 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030d:	8b 00                	mov    (%eax),%eax
  80030f:	83 f8 ff             	cmp    $0xffffffff,%eax
  800312:	74 14                	je     800328 <_main+0x2f0>
  800314:	83 ec 04             	sub    $0x4,%esp
  800317:	68 98 36 80 00       	push   $0x803698
  80031c:	6a 40                	push   $0x40
  80031e:	68 7c 34 80 00       	push   $0x80347c
  800323:	e8 ae 01 00 00       	call   8004d6 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800328:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032b:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	83 f8 ff             	cmp    $0xffffffff,%eax
  800335:	74 14                	je     80034b <_main+0x313>
  800337:	83 ec 04             	sub    $0x4,%esp
  80033a:	68 98 36 80 00       	push   $0x803698
  80033f:	6a 41                	push   $0x41
  800341:	68 7c 34 80 00       	push   $0x80347c
  800346:	e8 8b 01 00 00       	call   8004d6 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	68 c4 36 80 00       	push   $0x8036c4
  800353:	e8 32 04 00 00       	call   80078a <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80035b:	e8 7d 1a 00 00       	call   801ddd <sys_getparentenvid>
  800360:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if(parentenvID > 0)
  800363:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800367:	7e 2b                	jle    800394 <_main+0x35c>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  800369:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	68 18 37 80 00       	push   $0x803718
  800378:	ff 75 d8             	pushl  -0x28(%ebp)
  80037b:	e8 2e 15 00 00       	call   8018ae <sget>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		(*finishedCount)++ ;
  800386:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	8d 50 01             	lea    0x1(%eax),%edx
  80038e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800391:	89 10                	mov    %edx,(%eax)
	}

	return;
  800393:	90                   	nop
  800394:	90                   	nop
}
  800395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800398:	c9                   	leave  
  800399:	c3                   	ret    

0080039a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003a0:	e8 1f 1a 00 00       	call   801dc4 <sys_getenvindex>
  8003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003ab:	89 d0                	mov    %edx,%eax
  8003ad:	c1 e0 03             	shl    $0x3,%eax
  8003b0:	01 d0                	add    %edx,%eax
  8003b2:	01 c0                	add    %eax,%eax
  8003b4:	01 d0                	add    %edx,%eax
  8003b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bd:	01 d0                	add    %edx,%eax
  8003bf:	c1 e0 04             	shl    $0x4,%eax
  8003c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003c7:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d1:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003d7:	84 c0                	test   %al,%al
  8003d9:	74 0f                	je     8003ea <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003db:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e0:	05 5c 05 00 00       	add    $0x55c,%eax
  8003e5:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003ee:	7e 0a                	jle    8003fa <libmain+0x60>
		binaryname = argv[0];
  8003f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f3:	8b 00                	mov    (%eax),%eax
  8003f5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003fa:	83 ec 08             	sub    $0x8,%esp
  8003fd:	ff 75 0c             	pushl  0xc(%ebp)
  800400:	ff 75 08             	pushl  0x8(%ebp)
  800403:	e8 30 fc ff ff       	call   800038 <_main>
  800408:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80040b:	e8 c1 17 00 00       	call   801bd1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800410:	83 ec 0c             	sub    $0xc,%esp
  800413:	68 40 37 80 00       	push   $0x803740
  800418:	e8 6d 03 00 00       	call   80078a <cprintf>
  80041d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800420:	a1 20 40 80 00       	mov    0x804020,%eax
  800425:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80042b:	a1 20 40 80 00       	mov    0x804020,%eax
  800430:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	52                   	push   %edx
  80043a:	50                   	push   %eax
  80043b:	68 68 37 80 00       	push   $0x803768
  800440:	e8 45 03 00 00       	call   80078a <cprintf>
  800445:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800448:	a1 20 40 80 00       	mov    0x804020,%eax
  80044d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800453:	a1 20 40 80 00       	mov    0x804020,%eax
  800458:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80045e:	a1 20 40 80 00       	mov    0x804020,%eax
  800463:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800469:	51                   	push   %ecx
  80046a:	52                   	push   %edx
  80046b:	50                   	push   %eax
  80046c:	68 90 37 80 00       	push   $0x803790
  800471:	e8 14 03 00 00       	call   80078a <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
  80047e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	50                   	push   %eax
  800488:	68 e8 37 80 00       	push   $0x8037e8
  80048d:	e8 f8 02 00 00       	call   80078a <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	68 40 37 80 00       	push   $0x803740
  80049d:	e8 e8 02 00 00       	call   80078a <cprintf>
  8004a2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004a5:	e8 41 17 00 00       	call   801beb <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004aa:	e8 19 00 00 00       	call   8004c8 <exit>
}
  8004af:	90                   	nop
  8004b0:	c9                   	leave  
  8004b1:	c3                   	ret    

008004b2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004b8:	83 ec 0c             	sub    $0xc,%esp
  8004bb:	6a 00                	push   $0x0
  8004bd:	e8 ce 18 00 00       	call   801d90 <sys_destroy_env>
  8004c2:	83 c4 10             	add    $0x10,%esp
}
  8004c5:	90                   	nop
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <exit>:

void
exit(void)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ce:	e8 23 19 00 00       	call   801df6 <sys_exit_env>
}
  8004d3:	90                   	nop
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    

008004d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004dc:	8d 45 10             	lea    0x10(%ebp),%eax
  8004df:	83 c0 04             	add    $0x4,%eax
  8004e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004e5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004ea:	85 c0                	test   %eax,%eax
  8004ec:	74 16                	je     800504 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004ee:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	50                   	push   %eax
  8004f7:	68 fc 37 80 00       	push   $0x8037fc
  8004fc:	e8 89 02 00 00       	call   80078a <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800504:	a1 00 40 80 00       	mov    0x804000,%eax
  800509:	ff 75 0c             	pushl  0xc(%ebp)
  80050c:	ff 75 08             	pushl  0x8(%ebp)
  80050f:	50                   	push   %eax
  800510:	68 01 38 80 00       	push   $0x803801
  800515:	e8 70 02 00 00       	call   80078a <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80051d:	8b 45 10             	mov    0x10(%ebp),%eax
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	ff 75 f4             	pushl  -0xc(%ebp)
  800526:	50                   	push   %eax
  800527:	e8 f3 01 00 00       	call   80071f <vcprintf>
  80052c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	6a 00                	push   $0x0
  800534:	68 1d 38 80 00       	push   $0x80381d
  800539:	e8 e1 01 00 00       	call   80071f <vcprintf>
  80053e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800541:	e8 82 ff ff ff       	call   8004c8 <exit>

	// should not return here
	while (1) ;
  800546:	eb fe                	jmp    800546 <_panic+0x70>

00800548 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800548:	55                   	push   %ebp
  800549:	89 e5                	mov    %esp,%ebp
  80054b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80054e:	a1 20 40 80 00       	mov    0x804020,%eax
  800553:	8b 50 74             	mov    0x74(%eax),%edx
  800556:	8b 45 0c             	mov    0xc(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 20 38 80 00       	push   $0x803820
  800565:	6a 26                	push   $0x26
  800567:	68 6c 38 80 00       	push   $0x80386c
  80056c:	e8 65 ff ff ff       	call   8004d6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800571:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800578:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80057f:	e9 c2 00 00 00       	jmp    800646 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800587:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058e:	8b 45 08             	mov    0x8(%ebp),%eax
  800591:	01 d0                	add    %edx,%eax
  800593:	8b 00                	mov    (%eax),%eax
  800595:	85 c0                	test   %eax,%eax
  800597:	75 08                	jne    8005a1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800599:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80059c:	e9 a2 00 00 00       	jmp    800643 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005af:	eb 69                	jmp    80061a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8005b6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005bf:	89 d0                	mov    %edx,%eax
  8005c1:	01 c0                	add    %eax,%eax
  8005c3:	01 d0                	add    %edx,%eax
  8005c5:	c1 e0 03             	shl    $0x3,%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8a 40 04             	mov    0x4(%eax),%al
  8005cd:	84 c0                	test   %al,%al
  8005cf:	75 46                	jne    800617 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005d1:	a1 20 40 80 00       	mov    0x804020,%eax
  8005d6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005df:	89 d0                	mov    %edx,%eax
  8005e1:	01 c0                	add    %eax,%eax
  8005e3:	01 d0                	add    %edx,%eax
  8005e5:	c1 e0 03             	shl    $0x3,%eax
  8005e8:	01 c8                	add    %ecx,%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005f7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800603:	8b 45 08             	mov    0x8(%ebp),%eax
  800606:	01 c8                	add    %ecx,%eax
  800608:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80060a:	39 c2                	cmp    %eax,%edx
  80060c:	75 09                	jne    800617 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80060e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800615:	eb 12                	jmp    800629 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800617:	ff 45 e8             	incl   -0x18(%ebp)
  80061a:	a1 20 40 80 00       	mov    0x804020,%eax
  80061f:	8b 50 74             	mov    0x74(%eax),%edx
  800622:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800625:	39 c2                	cmp    %eax,%edx
  800627:	77 88                	ja     8005b1 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800629:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80062d:	75 14                	jne    800643 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80062f:	83 ec 04             	sub    $0x4,%esp
  800632:	68 78 38 80 00       	push   $0x803878
  800637:	6a 3a                	push   $0x3a
  800639:	68 6c 38 80 00       	push   $0x80386c
  80063e:	e8 93 fe ff ff       	call   8004d6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800643:	ff 45 f0             	incl   -0x10(%ebp)
  800646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800649:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80064c:	0f 8c 32 ff ff ff    	jl     800584 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800652:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800659:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800660:	eb 26                	jmp    800688 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800662:	a1 20 40 80 00       	mov    0x804020,%eax
  800667:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80066d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800670:	89 d0                	mov    %edx,%eax
  800672:	01 c0                	add    %eax,%eax
  800674:	01 d0                	add    %edx,%eax
  800676:	c1 e0 03             	shl    $0x3,%eax
  800679:	01 c8                	add    %ecx,%eax
  80067b:	8a 40 04             	mov    0x4(%eax),%al
  80067e:	3c 01                	cmp    $0x1,%al
  800680:	75 03                	jne    800685 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800682:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800685:	ff 45 e0             	incl   -0x20(%ebp)
  800688:	a1 20 40 80 00       	mov    0x804020,%eax
  80068d:	8b 50 74             	mov    0x74(%eax),%edx
  800690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800693:	39 c2                	cmp    %eax,%edx
  800695:	77 cb                	ja     800662 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80069a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80069d:	74 14                	je     8006b3 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80069f:	83 ec 04             	sub    $0x4,%esp
  8006a2:	68 cc 38 80 00       	push   $0x8038cc
  8006a7:	6a 44                	push   $0x44
  8006a9:	68 6c 38 80 00       	push   $0x80386c
  8006ae:	e8 23 fe ff ff       	call   8004d6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006b3:	90                   	nop
  8006b4:	c9                   	leave  
  8006b5:	c3                   	ret    

008006b6 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006b6:	55                   	push   %ebp
  8006b7:	89 e5                	mov    %esp,%ebp
  8006b9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	8d 48 01             	lea    0x1(%eax),%ecx
  8006c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c7:	89 0a                	mov    %ecx,(%edx)
  8006c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8006cc:	88 d1                	mov    %dl,%cl
  8006ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006df:	75 2c                	jne    80070d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006e1:	a0 24 40 80 00       	mov    0x804024,%al
  8006e6:	0f b6 c0             	movzbl %al,%eax
  8006e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ec:	8b 12                	mov    (%edx),%edx
  8006ee:	89 d1                	mov    %edx,%ecx
  8006f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f3:	83 c2 08             	add    $0x8,%edx
  8006f6:	83 ec 04             	sub    $0x4,%esp
  8006f9:	50                   	push   %eax
  8006fa:	51                   	push   %ecx
  8006fb:	52                   	push   %edx
  8006fc:	e8 22 13 00 00       	call   801a23 <sys_cputs>
  800701:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800704:	8b 45 0c             	mov    0xc(%ebp),%eax
  800707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80070d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800710:	8b 40 04             	mov    0x4(%eax),%eax
  800713:	8d 50 01             	lea    0x1(%eax),%edx
  800716:	8b 45 0c             	mov    0xc(%ebp),%eax
  800719:	89 50 04             	mov    %edx,0x4(%eax)
}
  80071c:	90                   	nop
  80071d:	c9                   	leave  
  80071e:	c3                   	ret    

0080071f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800728:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80072f:	00 00 00 
	b.cnt = 0;
  800732:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800739:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	ff 75 08             	pushl  0x8(%ebp)
  800742:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800748:	50                   	push   %eax
  800749:	68 b6 06 80 00       	push   $0x8006b6
  80074e:	e8 11 02 00 00       	call   800964 <vprintfmt>
  800753:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800756:	a0 24 40 80 00       	mov    0x804024,%al
  80075b:	0f b6 c0             	movzbl %al,%eax
  80075e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	50                   	push   %eax
  800768:	52                   	push   %edx
  800769:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076f:	83 c0 08             	add    $0x8,%eax
  800772:	50                   	push   %eax
  800773:	e8 ab 12 00 00       	call   801a23 <sys_cputs>
  800778:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80077b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800782:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <cprintf>:

int cprintf(const char *fmt, ...) {
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800790:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800797:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a6:	50                   	push   %eax
  8007a7:	e8 73 ff ff ff       	call   80071f <vcprintf>
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b5:	c9                   	leave  
  8007b6:	c3                   	ret    

008007b7 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007bd:	e8 0f 14 00 00       	call   801bd1 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d1:	50                   	push   %eax
  8007d2:	e8 48 ff ff ff       	call   80071f <vcprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007dd:	e8 09 14 00 00       	call   801beb <sys_enable_interrupt>
	return cnt;
  8007e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	53                   	push   %ebx
  8007eb:	83 ec 14             	sub    $0x14,%esp
  8007ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8007fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800802:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800805:	77 55                	ja     80085c <printnum+0x75>
  800807:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80080a:	72 05                	jb     800811 <printnum+0x2a>
  80080c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80080f:	77 4b                	ja     80085c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800811:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800814:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800817:	8b 45 18             	mov    0x18(%ebp),%eax
  80081a:	ba 00 00 00 00       	mov    $0x0,%edx
  80081f:	52                   	push   %edx
  800820:	50                   	push   %eax
  800821:	ff 75 f4             	pushl  -0xc(%ebp)
  800824:	ff 75 f0             	pushl  -0x10(%ebp)
  800827:	e8 b4 29 00 00       	call   8031e0 <__udivdi3>
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	ff 75 20             	pushl  0x20(%ebp)
  800835:	53                   	push   %ebx
  800836:	ff 75 18             	pushl  0x18(%ebp)
  800839:	52                   	push   %edx
  80083a:	50                   	push   %eax
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	ff 75 08             	pushl  0x8(%ebp)
  800841:	e8 a1 ff ff ff       	call   8007e7 <printnum>
  800846:	83 c4 20             	add    $0x20,%esp
  800849:	eb 1a                	jmp    800865 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	ff 75 20             	pushl  0x20(%ebp)
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	ff d0                	call   *%eax
  800859:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80085c:	ff 4d 1c             	decl   0x1c(%ebp)
  80085f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800863:	7f e6                	jg     80084b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800865:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800868:	bb 00 00 00 00       	mov    $0x0,%ebx
  80086d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800870:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800873:	53                   	push   %ebx
  800874:	51                   	push   %ecx
  800875:	52                   	push   %edx
  800876:	50                   	push   %eax
  800877:	e8 74 2a 00 00       	call   8032f0 <__umoddi3>
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	05 34 3b 80 00       	add    $0x803b34,%eax
  800884:	8a 00                	mov    (%eax),%al
  800886:	0f be c0             	movsbl %al,%eax
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	ff 75 0c             	pushl  0xc(%ebp)
  80088f:	50                   	push   %eax
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	ff d0                	call   *%eax
  800895:	83 c4 10             	add    $0x10,%esp
}
  800898:	90                   	nop
  800899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089c:	c9                   	leave  
  80089d:	c3                   	ret    

0080089e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008a5:	7e 1c                	jle    8008c3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	8d 50 08             	lea    0x8(%eax),%edx
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	89 10                	mov    %edx,(%eax)
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	83 e8 08             	sub    $0x8,%eax
  8008bc:	8b 50 04             	mov    0x4(%eax),%edx
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	eb 40                	jmp    800903 <getuint+0x65>
	else if (lflag)
  8008c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c7:	74 1e                	je     8008e7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	8d 50 04             	lea    0x4(%eax),%edx
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	89 10                	mov    %edx,(%eax)
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e5:	eb 1c                	jmp    800903 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	8d 50 04             	lea    0x4(%eax),%edx
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	89 10                	mov    %edx,(%eax)
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	83 e8 04             	sub    $0x4,%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800908:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80090c:	7e 1c                	jle    80092a <getint+0x25>
		return va_arg(*ap, long long);
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	8d 50 08             	lea    0x8(%eax),%edx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	89 10                	mov    %edx,(%eax)
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	83 e8 08             	sub    $0x8,%eax
  800923:	8b 50 04             	mov    0x4(%eax),%edx
  800926:	8b 00                	mov    (%eax),%eax
  800928:	eb 38                	jmp    800962 <getint+0x5d>
	else if (lflag)
  80092a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092e:	74 1a                	je     80094a <getint+0x45>
		return va_arg(*ap, long);
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	8d 50 04             	lea    0x4(%eax),%edx
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	89 10                	mov    %edx,(%eax)
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	83 e8 04             	sub    $0x4,%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	99                   	cltd   
  800948:	eb 18                	jmp    800962 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	8d 50 04             	lea    0x4(%eax),%edx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	89 10                	mov    %edx,(%eax)
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	83 e8 04             	sub    $0x4,%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	99                   	cltd   
}
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	56                   	push   %esi
  800968:	53                   	push   %ebx
  800969:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096c:	eb 17                	jmp    800985 <vprintfmt+0x21>
			if (ch == '\0')
  80096e:	85 db                	test   %ebx,%ebx
  800970:	0f 84 af 03 00 00    	je     800d25 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	53                   	push   %ebx
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800985:	8b 45 10             	mov    0x10(%ebp),%eax
  800988:	8d 50 01             	lea    0x1(%eax),%edx
  80098b:	89 55 10             	mov    %edx,0x10(%ebp)
  80098e:	8a 00                	mov    (%eax),%al
  800990:	0f b6 d8             	movzbl %al,%ebx
  800993:	83 fb 25             	cmp    $0x25,%ebx
  800996:	75 d6                	jne    80096e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800998:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80099c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bb:	8d 50 01             	lea    0x1(%eax),%edx
  8009be:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f b6 d8             	movzbl %al,%ebx
  8009c6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009c9:	83 f8 55             	cmp    $0x55,%eax
  8009cc:	0f 87 2b 03 00 00    	ja     800cfd <vprintfmt+0x399>
  8009d2:	8b 04 85 58 3b 80 00 	mov    0x803b58(,%eax,4),%eax
  8009d9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009db:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009df:	eb d7                	jmp    8009b8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009e1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009e5:	eb d1                	jmp    8009b8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f1:	89 d0                	mov    %edx,%eax
  8009f3:	c1 e0 02             	shl    $0x2,%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	01 c0                	add    %eax,%eax
  8009fa:	01 d8                	add    %ebx,%eax
  8009fc:	83 e8 30             	sub    $0x30,%eax
  8009ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a02:	8b 45 10             	mov    0x10(%ebp),%eax
  800a05:	8a 00                	mov    (%eax),%al
  800a07:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a0a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a0d:	7e 3e                	jle    800a4d <vprintfmt+0xe9>
  800a0f:	83 fb 39             	cmp    $0x39,%ebx
  800a12:	7f 39                	jg     800a4d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a14:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a17:	eb d5                	jmp    8009ee <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	83 c0 04             	add    $0x4,%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a22:	8b 45 14             	mov    0x14(%ebp),%eax
  800a25:	83 e8 04             	sub    $0x4,%eax
  800a28:	8b 00                	mov    (%eax),%eax
  800a2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a2d:	eb 1f                	jmp    800a4e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a33:	79 83                	jns    8009b8 <vprintfmt+0x54>
				width = 0;
  800a35:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a3c:	e9 77 ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a41:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a48:	e9 6b ff ff ff       	jmp    8009b8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a4d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a52:	0f 89 60 ff ff ff    	jns    8009b8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a65:	e9 4e ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a6a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a6d:	e9 46 ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a72:	8b 45 14             	mov    0x14(%ebp),%eax
  800a75:	83 c0 04             	add    $0x4,%eax
  800a78:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	83 e8 04             	sub    $0x4,%eax
  800a81:	8b 00                	mov    (%eax),%eax
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	50                   	push   %eax
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			break;
  800a92:	e9 89 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aa8:	85 db                	test   %ebx,%ebx
  800aaa:	79 02                	jns    800aae <vprintfmt+0x14a>
				err = -err;
  800aac:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aae:	83 fb 64             	cmp    $0x64,%ebx
  800ab1:	7f 0b                	jg     800abe <vprintfmt+0x15a>
  800ab3:	8b 34 9d a0 39 80 00 	mov    0x8039a0(,%ebx,4),%esi
  800aba:	85 f6                	test   %esi,%esi
  800abc:	75 19                	jne    800ad7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800abe:	53                   	push   %ebx
  800abf:	68 45 3b 80 00       	push   $0x803b45
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	ff 75 08             	pushl  0x8(%ebp)
  800aca:	e8 5e 02 00 00       	call   800d2d <printfmt>
  800acf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad2:	e9 49 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad7:	56                   	push   %esi
  800ad8:	68 4e 3b 80 00       	push   $0x803b4e
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	ff 75 08             	pushl  0x8(%ebp)
  800ae3:	e8 45 02 00 00       	call   800d2d <printfmt>
  800ae8:	83 c4 10             	add    $0x10,%esp
			break;
  800aeb:	e9 30 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800af0:	8b 45 14             	mov    0x14(%ebp),%eax
  800af3:	83 c0 04             	add    $0x4,%eax
  800af6:	89 45 14             	mov    %eax,0x14(%ebp)
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	83 e8 04             	sub    $0x4,%eax
  800aff:	8b 30                	mov    (%eax),%esi
  800b01:	85 f6                	test   %esi,%esi
  800b03:	75 05                	jne    800b0a <vprintfmt+0x1a6>
				p = "(null)";
  800b05:	be 51 3b 80 00       	mov    $0x803b51,%esi
			if (width > 0 && padc != '-')
  800b0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0e:	7e 6d                	jle    800b7d <vprintfmt+0x219>
  800b10:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b14:	74 67                	je     800b7d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	50                   	push   %eax
  800b1d:	56                   	push   %esi
  800b1e:	e8 0c 03 00 00       	call   800e2f <strnlen>
  800b23:	83 c4 10             	add    $0x10,%esp
  800b26:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b29:	eb 16                	jmp    800b41 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b2b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	50                   	push   %eax
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b45:	7f e4                	jg     800b2b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b47:	eb 34                	jmp    800b7d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b49:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b4d:	74 1c                	je     800b6b <vprintfmt+0x207>
  800b4f:	83 fb 1f             	cmp    $0x1f,%ebx
  800b52:	7e 05                	jle    800b59 <vprintfmt+0x1f5>
  800b54:	83 fb 7e             	cmp    $0x7e,%ebx
  800b57:	7e 12                	jle    800b6b <vprintfmt+0x207>
					putch('?', putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	6a 3f                	push   $0x3f
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	ff d0                	call   *%eax
  800b66:	83 c4 10             	add    $0x10,%esp
  800b69:	eb 0f                	jmp    800b7a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	53                   	push   %ebx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	ff d0                	call   *%eax
  800b77:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b7d:	89 f0                	mov    %esi,%eax
  800b7f:	8d 70 01             	lea    0x1(%eax),%esi
  800b82:	8a 00                	mov    (%eax),%al
  800b84:	0f be d8             	movsbl %al,%ebx
  800b87:	85 db                	test   %ebx,%ebx
  800b89:	74 24                	je     800baf <vprintfmt+0x24b>
  800b8b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b8f:	78 b8                	js     800b49 <vprintfmt+0x1e5>
  800b91:	ff 4d e0             	decl   -0x20(%ebp)
  800b94:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b98:	79 af                	jns    800b49 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9a:	eb 13                	jmp    800baf <vprintfmt+0x24b>
				putch(' ', putdat);
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	6a 20                	push   $0x20
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	ff d0                	call   *%eax
  800ba9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bac:	ff 4d e4             	decl   -0x1c(%ebp)
  800baf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb3:	7f e7                	jg     800b9c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bb5:	e9 66 01 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bba:	83 ec 08             	sub    $0x8,%esp
  800bbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc3:	50                   	push   %eax
  800bc4:	e8 3c fd ff ff       	call   800905 <getint>
  800bc9:	83 c4 10             	add    $0x10,%esp
  800bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd8:	85 d2                	test   %edx,%edx
  800bda:	79 23                	jns    800bff <vprintfmt+0x29b>
				putch('-', putdat);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 0c             	pushl  0xc(%ebp)
  800be2:	6a 2d                	push   $0x2d
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	ff d0                	call   *%eax
  800be9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf2:	f7 d8                	neg    %eax
  800bf4:	83 d2 00             	adc    $0x0,%edx
  800bf7:	f7 da                	neg    %edx
  800bf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c06:	e9 bc 00 00 00       	jmp    800cc7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c11:	8d 45 14             	lea    0x14(%ebp),%eax
  800c14:	50                   	push   %eax
  800c15:	e8 84 fc ff ff       	call   80089e <getuint>
  800c1a:	83 c4 10             	add    $0x10,%esp
  800c1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c20:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c23:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2a:	e9 98 00 00 00       	jmp    800cc7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c2f:	83 ec 08             	sub    $0x8,%esp
  800c32:	ff 75 0c             	pushl  0xc(%ebp)
  800c35:	6a 58                	push   $0x58
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	ff d0                	call   *%eax
  800c3c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	6a 58                	push   $0x58
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	ff d0                	call   *%eax
  800c4c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	6a 58                	push   $0x58
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			break;
  800c5f:	e9 bc 00 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c64:	83 ec 08             	sub    $0x8,%esp
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	6a 30                	push   $0x30
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	ff d0                	call   *%eax
  800c71:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	6a 78                	push   $0x78
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c84:	8b 45 14             	mov    0x14(%ebp),%eax
  800c87:	83 c0 04             	add    $0x4,%eax
  800c8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c90:	83 e8 04             	sub    $0x4,%eax
  800c93:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c9f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ca6:	eb 1f                	jmp    800cc7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ca8:	83 ec 08             	sub    $0x8,%esp
  800cab:	ff 75 e8             	pushl  -0x18(%ebp)
  800cae:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb1:	50                   	push   %eax
  800cb2:	e8 e7 fb ff ff       	call   80089e <getuint>
  800cb7:	83 c4 10             	add    $0x10,%esp
  800cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cc0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cce:	83 ec 04             	sub    $0x4,%esp
  800cd1:	52                   	push   %edx
  800cd2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cd5:	50                   	push   %eax
  800cd6:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd9:	ff 75 f0             	pushl  -0x10(%ebp)
  800cdc:	ff 75 0c             	pushl  0xc(%ebp)
  800cdf:	ff 75 08             	pushl  0x8(%ebp)
  800ce2:	e8 00 fb ff ff       	call   8007e7 <printnum>
  800ce7:	83 c4 20             	add    $0x20,%esp
			break;
  800cea:	eb 34                	jmp    800d20 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cec:	83 ec 08             	sub    $0x8,%esp
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	53                   	push   %ebx
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	ff d0                	call   *%eax
  800cf8:	83 c4 10             	add    $0x10,%esp
			break;
  800cfb:	eb 23                	jmp    800d20 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cfd:	83 ec 08             	sub    $0x8,%esp
  800d00:	ff 75 0c             	pushl  0xc(%ebp)
  800d03:	6a 25                	push   $0x25
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	ff d0                	call   *%eax
  800d0a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0d:	ff 4d 10             	decl   0x10(%ebp)
  800d10:	eb 03                	jmp    800d15 <vprintfmt+0x3b1>
  800d12:	ff 4d 10             	decl   0x10(%ebp)
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	48                   	dec    %eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	3c 25                	cmp    $0x25,%al
  800d1d:	75 f3                	jne    800d12 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d1f:	90                   	nop
		}
	}
  800d20:	e9 47 fc ff ff       	jmp    80096c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d25:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d33:	8d 45 10             	lea    0x10(%ebp),%eax
  800d36:	83 c0 04             	add    $0x4,%eax
  800d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d42:	50                   	push   %eax
  800d43:	ff 75 0c             	pushl  0xc(%ebp)
  800d46:	ff 75 08             	pushl  0x8(%ebp)
  800d49:	e8 16 fc ff ff       	call   800964 <vprintfmt>
  800d4e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d51:	90                   	nop
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8b 40 08             	mov    0x8(%eax),%eax
  800d5d:	8d 50 01             	lea    0x1(%eax),%edx
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d69:	8b 10                	mov    (%eax),%edx
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	8b 40 04             	mov    0x4(%eax),%eax
  800d71:	39 c2                	cmp    %eax,%edx
  800d73:	73 12                	jae    800d87 <sprintputch+0x33>
		*b->buf++ = ch;
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	8d 48 01             	lea    0x1(%eax),%ecx
  800d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d80:	89 0a                	mov    %ecx,(%edx)
  800d82:	8b 55 08             	mov    0x8(%ebp),%edx
  800d85:	88 10                	mov    %dl,(%eax)
}
  800d87:	90                   	nop
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	01 d0                	add    %edx,%eax
  800da1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800daf:	74 06                	je     800db7 <vsnprintf+0x2d>
  800db1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db5:	7f 07                	jg     800dbe <vsnprintf+0x34>
		return -E_INVAL;
  800db7:	b8 03 00 00 00       	mov    $0x3,%eax
  800dbc:	eb 20                	jmp    800dde <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dbe:	ff 75 14             	pushl  0x14(%ebp)
  800dc1:	ff 75 10             	pushl  0x10(%ebp)
  800dc4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc7:	50                   	push   %eax
  800dc8:	68 54 0d 80 00       	push   $0x800d54
  800dcd:	e8 92 fb ff ff       	call   800964 <vprintfmt>
  800dd2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800de6:	8d 45 10             	lea    0x10(%ebp),%eax
  800de9:	83 c0 04             	add    $0x4,%eax
  800dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	ff 75 f4             	pushl  -0xc(%ebp)
  800df5:	50                   	push   %eax
  800df6:	ff 75 0c             	pushl  0xc(%ebp)
  800df9:	ff 75 08             	pushl  0x8(%ebp)
  800dfc:	e8 89 ff ff ff       	call   800d8a <vsnprintf>
  800e01:	83 c4 10             	add    $0x10,%esp
  800e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    

00800e0c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e19:	eb 06                	jmp    800e21 <strlen+0x15>
		n++;
  800e1b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1e:	ff 45 08             	incl   0x8(%ebp)
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8a 00                	mov    (%eax),%al
  800e26:	84 c0                	test   %al,%al
  800e28:	75 f1                	jne    800e1b <strlen+0xf>
		n++;
	return n;
  800e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2d:	c9                   	leave  
  800e2e:	c3                   	ret    

00800e2f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3c:	eb 09                	jmp    800e47 <strnlen+0x18>
		n++;
  800e3e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e41:	ff 45 08             	incl   0x8(%ebp)
  800e44:	ff 4d 0c             	decl   0xc(%ebp)
  800e47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e4b:	74 09                	je     800e56 <strnlen+0x27>
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	84 c0                	test   %al,%al
  800e54:	75 e8                	jne    800e3e <strnlen+0xf>
		n++;
	return n;
  800e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e67:	90                   	nop
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8d 50 01             	lea    0x1(%eax),%edx
  800e6e:	89 55 08             	mov    %edx,0x8(%ebp)
  800e71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e74:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e77:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e7a:	8a 12                	mov    (%edx),%dl
  800e7c:	88 10                	mov    %dl,(%eax)
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	84 c0                	test   %al,%al
  800e82:	75 e4                	jne    800e68 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e9c:	eb 1f                	jmp    800ebd <strncpy+0x34>
		*dst++ = *src;
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8d 50 01             	lea    0x1(%eax),%edx
  800ea4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eaa:	8a 12                	mov    (%edx),%dl
  800eac:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	84 c0                	test   %al,%al
  800eb5:	74 03                	je     800eba <strncpy+0x31>
			src++;
  800eb7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eba:	ff 45 fc             	incl   -0x4(%ebp)
  800ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ec3:	72 d9                	jb     800e9e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ec5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ed6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eda:	74 30                	je     800f0c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800edc:	eb 16                	jmp    800ef4 <strlcpy+0x2a>
			*dst++ = *src++;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ef0:	8a 12                	mov    (%edx),%dl
  800ef2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ef4:	ff 4d 10             	decl   0x10(%ebp)
  800ef7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efb:	74 09                	je     800f06 <strlcpy+0x3c>
  800efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	84 c0                	test   %al,%al
  800f04:	75 d8                	jne    800ede <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f12:	29 c2                	sub    %eax,%edx
  800f14:	89 d0                	mov    %edx,%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f1b:	eb 06                	jmp    800f23 <strcmp+0xb>
		p++, q++;
  800f1d:	ff 45 08             	incl   0x8(%ebp)
  800f20:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	84 c0                	test   %al,%al
  800f2a:	74 0e                	je     800f3a <strcmp+0x22>
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 10                	mov    (%eax),%dl
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	38 c2                	cmp    %al,%dl
  800f38:	74 e3                	je     800f1d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	0f b6 d0             	movzbl %al,%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f b6 c0             	movzbl %al,%eax
  800f4a:	29 c2                	sub    %eax,%edx
  800f4c:	89 d0                	mov    %edx,%eax
}
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f53:	eb 09                	jmp    800f5e <strncmp+0xe>
		n--, p++, q++;
  800f55:	ff 4d 10             	decl   0x10(%ebp)
  800f58:	ff 45 08             	incl   0x8(%ebp)
  800f5b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f62:	74 17                	je     800f7b <strncmp+0x2b>
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	84 c0                	test   %al,%al
  800f6b:	74 0e                	je     800f7b <strncmp+0x2b>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 10                	mov    (%eax),%dl
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	38 c2                	cmp    %al,%dl
  800f79:	74 da                	je     800f55 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7f:	75 07                	jne    800f88 <strncmp+0x38>
		return 0;
  800f81:	b8 00 00 00 00       	mov    $0x0,%eax
  800f86:	eb 14                	jmp    800f9c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	0f b6 d0             	movzbl %al,%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	0f b6 c0             	movzbl %al,%eax
  800f98:	29 c2                	sub    %eax,%edx
  800f9a:	89 d0                	mov    %edx,%eax
}
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    

00800f9e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800faa:	eb 12                	jmp    800fbe <strchr+0x20>
		if (*s == c)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb4:	75 05                	jne    800fbb <strchr+0x1d>
			return (char *) s;
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	eb 11                	jmp    800fcc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fbb:	ff 45 08             	incl   0x8(%ebp)
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	84 c0                	test   %al,%al
  800fc5:	75 e5                	jne    800fac <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fcc:	c9                   	leave  
  800fcd:	c3                   	ret    

00800fce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	83 ec 04             	sub    $0x4,%esp
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fda:	eb 0d                	jmp    800fe9 <strfind+0x1b>
		if (*s == c)
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe4:	74 0e                	je     800ff4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fe6:	ff 45 08             	incl   0x8(%ebp)
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	84 c0                	test   %al,%al
  800ff0:	75 ea                	jne    800fdc <strfind+0xe>
  800ff2:	eb 01                	jmp    800ff5 <strfind+0x27>
		if (*s == c)
			break;
  800ff4:	90                   	nop
	return (char *) s;
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff8:	c9                   	leave  
  800ff9:	c3                   	ret    

00800ffa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801006:	8b 45 10             	mov    0x10(%ebp),%eax
  801009:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80100c:	eb 0e                	jmp    80101c <memset+0x22>
		*p++ = c;
  80100e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801011:	8d 50 01             	lea    0x1(%eax),%edx
  801014:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801017:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80101c:	ff 4d f8             	decl   -0x8(%ebp)
  80101f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801023:	79 e9                	jns    80100e <memset+0x14>
		*p++ = c;

	return v;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80103c:	eb 16                	jmp    801054 <memcpy+0x2a>
		*d++ = *s++;
  80103e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801041:	8d 50 01             	lea    0x1(%eax),%edx
  801044:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801047:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80104a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80104d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801050:	8a 12                	mov    (%edx),%dl
  801052:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	8d 50 ff             	lea    -0x1(%eax),%edx
  80105a:	89 55 10             	mov    %edx,0x10(%ebp)
  80105d:	85 c0                	test   %eax,%eax
  80105f:	75 dd                	jne    80103e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80106c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801078:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80107e:	73 50                	jae    8010d0 <memmove+0x6a>
  801080:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	01 d0                	add    %edx,%eax
  801088:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80108b:	76 43                	jbe    8010d0 <memmove+0x6a>
		s += n;
  80108d:	8b 45 10             	mov    0x10(%ebp),%eax
  801090:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801099:	eb 10                	jmp    8010ab <memmove+0x45>
			*--d = *--s;
  80109b:	ff 4d f8             	decl   -0x8(%ebp)
  80109e:	ff 4d fc             	decl   -0x4(%ebp)
  8010a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a4:	8a 10                	mov    (%eax),%dl
  8010a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	75 e3                	jne    80109b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010b8:	eb 23                	jmp    8010dd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	8d 50 01             	lea    0x1(%eax),%edx
  8010c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010cc:	8a 12                	mov    (%edx),%dl
  8010ce:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	75 dd                	jne    8010ba <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e0:	c9                   	leave  
  8010e1:	c3                   	ret    

008010e2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010f4:	eb 2a                	jmp    801120 <memcmp+0x3e>
		if (*s1 != *s2)
  8010f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f9:	8a 10                	mov    (%eax),%dl
  8010fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	38 c2                	cmp    %al,%dl
  801102:	74 16                	je     80111a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801104:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	0f b6 d0             	movzbl %al,%edx
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	0f b6 c0             	movzbl %al,%eax
  801114:	29 c2                	sub    %eax,%edx
  801116:	89 d0                	mov    %edx,%eax
  801118:	eb 18                	jmp    801132 <memcmp+0x50>
		s1++, s2++;
  80111a:	ff 45 fc             	incl   -0x4(%ebp)
  80111d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801120:	8b 45 10             	mov    0x10(%ebp),%eax
  801123:	8d 50 ff             	lea    -0x1(%eax),%edx
  801126:	89 55 10             	mov    %edx,0x10(%ebp)
  801129:	85 c0                	test   %eax,%eax
  80112b:	75 c9                	jne    8010f6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80112d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801132:	c9                   	leave  
  801133:	c3                   	ret    

00801134 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
  801137:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80113a:	8b 55 08             	mov    0x8(%ebp),%edx
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	01 d0                	add    %edx,%eax
  801142:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801145:	eb 15                	jmp    80115c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	0f b6 d0             	movzbl %al,%edx
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	39 c2                	cmp    %eax,%edx
  801157:	74 0d                	je     801166 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801159:	ff 45 08             	incl   0x8(%ebp)
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801162:	72 e3                	jb     801147 <memfind+0x13>
  801164:	eb 01                	jmp    801167 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801166:	90                   	nop
	return (void *) s;
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801172:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801180:	eb 03                	jmp    801185 <strtol+0x19>
		s++;
  801182:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	3c 20                	cmp    $0x20,%al
  80118c:	74 f4                	je     801182 <strtol+0x16>
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	3c 09                	cmp    $0x9,%al
  801195:	74 eb                	je     801182 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 2b                	cmp    $0x2b,%al
  80119e:	75 05                	jne    8011a5 <strtol+0x39>
		s++;
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	eb 13                	jmp    8011b8 <strtol+0x4c>
	else if (*s == '-')
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3c 2d                	cmp    $0x2d,%al
  8011ac:	75 0a                	jne    8011b8 <strtol+0x4c>
		s++, neg = 1;
  8011ae:	ff 45 08             	incl   0x8(%ebp)
  8011b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011bc:	74 06                	je     8011c4 <strtol+0x58>
  8011be:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011c2:	75 20                	jne    8011e4 <strtol+0x78>
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	3c 30                	cmp    $0x30,%al
  8011cb:	75 17                	jne    8011e4 <strtol+0x78>
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	40                   	inc    %eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	3c 78                	cmp    $0x78,%al
  8011d5:	75 0d                	jne    8011e4 <strtol+0x78>
		s += 2, base = 16;
  8011d7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011db:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011e2:	eb 28                	jmp    80120c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e8:	75 15                	jne    8011ff <strtol+0x93>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 30                	cmp    $0x30,%al
  8011f1:	75 0c                	jne    8011ff <strtol+0x93>
		s++, base = 8;
  8011f3:	ff 45 08             	incl   0x8(%ebp)
  8011f6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011fd:	eb 0d                	jmp    80120c <strtol+0xa0>
	else if (base == 0)
  8011ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801203:	75 07                	jne    80120c <strtol+0xa0>
		base = 10;
  801205:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 2f                	cmp    $0x2f,%al
  801213:	7e 19                	jle    80122e <strtol+0xc2>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	3c 39                	cmp    $0x39,%al
  80121c:	7f 10                	jg     80122e <strtol+0xc2>
			dig = *s - '0';
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	0f be c0             	movsbl %al,%eax
  801226:	83 e8 30             	sub    $0x30,%eax
  801229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80122c:	eb 42                	jmp    801270 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	3c 60                	cmp    $0x60,%al
  801235:	7e 19                	jle    801250 <strtol+0xe4>
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	3c 7a                	cmp    $0x7a,%al
  80123e:	7f 10                	jg     801250 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	0f be c0             	movsbl %al,%eax
  801248:	83 e8 57             	sub    $0x57,%eax
  80124b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80124e:	eb 20                	jmp    801270 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	3c 40                	cmp    $0x40,%al
  801257:	7e 39                	jle    801292 <strtol+0x126>
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	3c 5a                	cmp    $0x5a,%al
  801260:	7f 30                	jg     801292 <strtol+0x126>
			dig = *s - 'A' + 10;
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	0f be c0             	movsbl %al,%eax
  80126a:	83 e8 37             	sub    $0x37,%eax
  80126d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801273:	3b 45 10             	cmp    0x10(%ebp),%eax
  801276:	7d 19                	jge    801291 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801278:	ff 45 08             	incl   0x8(%ebp)
  80127b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801282:	89 c2                	mov    %eax,%edx
  801284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801287:	01 d0                	add    %edx,%eax
  801289:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80128c:	e9 7b ff ff ff       	jmp    80120c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801291:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801292:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801296:	74 08                	je     8012a0 <strtol+0x134>
		*endptr = (char *) s;
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	8b 55 08             	mov    0x8(%ebp),%edx
  80129e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012a4:	74 07                	je     8012ad <strtol+0x141>
  8012a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a9:	f7 d8                	neg    %eax
  8012ab:	eb 03                	jmp    8012b0 <strtol+0x144>
  8012ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <ltostr>:

void
ltostr(long value, char *str)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ca:	79 13                	jns    8012df <ltostr+0x2d>
	{
		neg = 1;
  8012cc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012d9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012dc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012e7:	99                   	cltd   
  8012e8:	f7 f9                	idiv   %ecx
  8012ea:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f0:	8d 50 01             	lea    0x1(%eax),%edx
  8012f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fb:	01 d0                	add    %edx,%eax
  8012fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801300:	83 c2 30             	add    $0x30,%edx
  801303:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801305:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801308:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80130d:	f7 e9                	imul   %ecx
  80130f:	c1 fa 02             	sar    $0x2,%edx
  801312:	89 c8                	mov    %ecx,%eax
  801314:	c1 f8 1f             	sar    $0x1f,%eax
  801317:	29 c2                	sub    %eax,%edx
  801319:	89 d0                	mov    %edx,%eax
  80131b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80131e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801321:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801326:	f7 e9                	imul   %ecx
  801328:	c1 fa 02             	sar    $0x2,%edx
  80132b:	89 c8                	mov    %ecx,%eax
  80132d:	c1 f8 1f             	sar    $0x1f,%eax
  801330:	29 c2                	sub    %eax,%edx
  801332:	89 d0                	mov    %edx,%eax
  801334:	c1 e0 02             	shl    $0x2,%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	01 c0                	add    %eax,%eax
  80133b:	29 c1                	sub    %eax,%ecx
  80133d:	89 ca                	mov    %ecx,%edx
  80133f:	85 d2                	test   %edx,%edx
  801341:	75 9c                	jne    8012df <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801343:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80134a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134d:	48                   	dec    %eax
  80134e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801351:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801355:	74 3d                	je     801394 <ltostr+0xe2>
		start = 1 ;
  801357:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80135e:	eb 34                	jmp    801394 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801363:	8b 45 0c             	mov    0xc(%ebp),%eax
  801366:	01 d0                	add    %edx,%eax
  801368:	8a 00                	mov    (%eax),%al
  80136a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80136d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 c2                	add    %eax,%edx
  801375:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	01 c8                	add    %ecx,%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801381:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 c2                	add    %eax,%edx
  801389:	8a 45 eb             	mov    -0x15(%ebp),%al
  80138c:	88 02                	mov    %al,(%edx)
		start++ ;
  80138e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801391:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801397:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80139a:	7c c4                	jl     801360 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80139c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80139f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a2:	01 d0                	add    %edx,%eax
  8013a4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013a7:	90                   	nop
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013b0:	ff 75 08             	pushl  0x8(%ebp)
  8013b3:	e8 54 fa ff ff       	call   800e0c <strlen>
  8013b8:	83 c4 04             	add    $0x4,%esp
  8013bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013be:	ff 75 0c             	pushl  0xc(%ebp)
  8013c1:	e8 46 fa ff ff       	call   800e0c <strlen>
  8013c6:	83 c4 04             	add    $0x4,%esp
  8013c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013da:	eb 17                	jmp    8013f3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013df:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e2:	01 c2                	add    %eax,%edx
  8013e4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	01 c8                	add    %ecx,%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013f0:	ff 45 fc             	incl   -0x4(%ebp)
  8013f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013f9:	7c e1                	jl     8013dc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801402:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801409:	eb 1f                	jmp    80142a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140e:	8d 50 01             	lea    0x1(%eax),%edx
  801411:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801414:	89 c2                	mov    %eax,%edx
  801416:	8b 45 10             	mov    0x10(%ebp),%eax
  801419:	01 c2                	add    %eax,%edx
  80141b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80141e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801421:	01 c8                	add    %ecx,%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801427:	ff 45 f8             	incl   -0x8(%ebp)
  80142a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801430:	7c d9                	jl     80140b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801432:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801435:	8b 45 10             	mov    0x10(%ebp),%eax
  801438:	01 d0                	add    %edx,%eax
  80143a:	c6 00 00             	movb   $0x0,(%eax)
}
  80143d:	90                   	nop
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801443:	8b 45 14             	mov    0x14(%ebp),%eax
  801446:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80144c:	8b 45 14             	mov    0x14(%ebp),%eax
  80144f:	8b 00                	mov    (%eax),%eax
  801451:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801458:	8b 45 10             	mov    0x10(%ebp),%eax
  80145b:	01 d0                	add    %edx,%eax
  80145d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801463:	eb 0c                	jmp    801471 <strsplit+0x31>
			*string++ = 0;
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8d 50 01             	lea    0x1(%eax),%edx
  80146b:	89 55 08             	mov    %edx,0x8(%ebp)
  80146e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	8a 00                	mov    (%eax),%al
  801476:	84 c0                	test   %al,%al
  801478:	74 18                	je     801492 <strsplit+0x52>
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	0f be c0             	movsbl %al,%eax
  801482:	50                   	push   %eax
  801483:	ff 75 0c             	pushl  0xc(%ebp)
  801486:	e8 13 fb ff ff       	call   800f9e <strchr>
  80148b:	83 c4 08             	add    $0x8,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	75 d3                	jne    801465 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	84 c0                	test   %al,%al
  801499:	74 5a                	je     8014f5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80149b:	8b 45 14             	mov    0x14(%ebp),%eax
  80149e:	8b 00                	mov    (%eax),%eax
  8014a0:	83 f8 0f             	cmp    $0xf,%eax
  8014a3:	75 07                	jne    8014ac <strsplit+0x6c>
		{
			return 0;
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014aa:	eb 66                	jmp    801512 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8014af:	8b 00                	mov    (%eax),%eax
  8014b1:	8d 48 01             	lea    0x1(%eax),%ecx
  8014b4:	8b 55 14             	mov    0x14(%ebp),%edx
  8014b7:	89 0a                	mov    %ecx,(%edx)
  8014b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c3:	01 c2                	add    %eax,%edx
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014ca:	eb 03                	jmp    8014cf <strsplit+0x8f>
			string++;
  8014cc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8a 00                	mov    (%eax),%al
  8014d4:	84 c0                	test   %al,%al
  8014d6:	74 8b                	je     801463 <strsplit+0x23>
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	0f be c0             	movsbl %al,%eax
  8014e0:	50                   	push   %eax
  8014e1:	ff 75 0c             	pushl  0xc(%ebp)
  8014e4:	e8 b5 fa ff ff       	call   800f9e <strchr>
  8014e9:	83 c4 08             	add    $0x8,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	74 dc                	je     8014cc <strsplit+0x8c>
			string++;
	}
  8014f0:	e9 6e ff ff ff       	jmp    801463 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014f5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801502:	8b 45 10             	mov    0x10(%ebp),%eax
  801505:	01 d0                	add    %edx,%eax
  801507:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80150d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80151a:	a1 04 40 80 00       	mov    0x804004,%eax
  80151f:	85 c0                	test   %eax,%eax
  801521:	74 1f                	je     801542 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801523:	e8 1d 00 00 00       	call   801545 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801528:	83 ec 0c             	sub    $0xc,%esp
  80152b:	68 b0 3c 80 00       	push   $0x803cb0
  801530:	e8 55 f2 ff ff       	call   80078a <cprintf>
  801535:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801538:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80153f:	00 00 00 
	}
}
  801542:	90                   	nop
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80154b:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801552:	00 00 00 
  801555:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80155c:	00 00 00 
  80155f:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801566:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801569:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801570:	00 00 00 
  801573:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80157a:	00 00 00 
  80157d:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801584:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801587:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80158e:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801591:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015a0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015a5:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  8015aa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015b1:	a1 20 41 80 00       	mov    0x804120,%eax
  8015b6:	c1 e0 04             	shl    $0x4,%eax
  8015b9:	89 c2                	mov    %eax,%edx
  8015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015be:	01 d0                	add    %edx,%eax
  8015c0:	48                   	dec    %eax
  8015c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015cc:	f7 75 f0             	divl   -0x10(%ebp)
  8015cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d2:	29 d0                	sub    %edx,%eax
  8015d4:	89 c2                	mov    %eax,%edx
  8015d6:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8015dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015e5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015ea:	83 ec 04             	sub    $0x4,%esp
  8015ed:	6a 06                	push   $0x6
  8015ef:	52                   	push   %edx
  8015f0:	50                   	push   %eax
  8015f1:	e8 71 05 00 00       	call   801b67 <sys_allocate_chunk>
  8015f6:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015f9:	a1 20 41 80 00       	mov    0x804120,%eax
  8015fe:	83 ec 0c             	sub    $0xc,%esp
  801601:	50                   	push   %eax
  801602:	e8 e6 0b 00 00       	call   8021ed <initialize_MemBlocksList>
  801607:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  80160a:	a1 48 41 80 00       	mov    0x804148,%eax
  80160f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801612:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801616:	75 14                	jne    80162c <initialize_dyn_block_system+0xe7>
  801618:	83 ec 04             	sub    $0x4,%esp
  80161b:	68 d5 3c 80 00       	push   $0x803cd5
  801620:	6a 2b                	push   $0x2b
  801622:	68 f3 3c 80 00       	push   $0x803cf3
  801627:	e8 aa ee ff ff       	call   8004d6 <_panic>
  80162c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80162f:	8b 00                	mov    (%eax),%eax
  801631:	85 c0                	test   %eax,%eax
  801633:	74 10                	je     801645 <initialize_dyn_block_system+0x100>
  801635:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801638:	8b 00                	mov    (%eax),%eax
  80163a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80163d:	8b 52 04             	mov    0x4(%edx),%edx
  801640:	89 50 04             	mov    %edx,0x4(%eax)
  801643:	eb 0b                	jmp    801650 <initialize_dyn_block_system+0x10b>
  801645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801648:	8b 40 04             	mov    0x4(%eax),%eax
  80164b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801653:	8b 40 04             	mov    0x4(%eax),%eax
  801656:	85 c0                	test   %eax,%eax
  801658:	74 0f                	je     801669 <initialize_dyn_block_system+0x124>
  80165a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80165d:	8b 40 04             	mov    0x4(%eax),%eax
  801660:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801663:	8b 12                	mov    (%edx),%edx
  801665:	89 10                	mov    %edx,(%eax)
  801667:	eb 0a                	jmp    801673 <initialize_dyn_block_system+0x12e>
  801669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80166c:	8b 00                	mov    (%eax),%eax
  80166e:	a3 48 41 80 00       	mov    %eax,0x804148
  801673:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801676:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80167c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80167f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801686:	a1 54 41 80 00       	mov    0x804154,%eax
  80168b:	48                   	dec    %eax
  80168c:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  801691:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801694:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  80169b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80169e:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  8016a5:	83 ec 0c             	sub    $0xc,%esp
  8016a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016ab:	e8 d2 13 00 00       	call   802a82 <insert_sorted_with_merge_freeList>
  8016b0:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8016b3:	90                   	nop
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016bc:	e8 53 fe ff ff       	call   801514 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016c5:	75 07                	jne    8016ce <malloc+0x18>
  8016c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cc:	eb 61                	jmp    80172f <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8016ce:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016db:	01 d0                	add    %edx,%eax
  8016dd:	48                   	dec    %eax
  8016de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e9:	f7 75 f4             	divl   -0xc(%ebp)
  8016ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ef:	29 d0                	sub    %edx,%eax
  8016f1:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016f4:	e8 3c 08 00 00       	call   801f35 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	74 2d                	je     80172a <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8016fd:	83 ec 0c             	sub    $0xc,%esp
  801700:	ff 75 08             	pushl  0x8(%ebp)
  801703:	e8 3e 0f 00 00       	call   802646 <alloc_block_FF>
  801708:	83 c4 10             	add    $0x10,%esp
  80170b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  80170e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801712:	74 16                	je     80172a <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801714:	83 ec 0c             	sub    $0xc,%esp
  801717:	ff 75 ec             	pushl  -0x14(%ebp)
  80171a:	e8 48 0c 00 00       	call   802367 <insert_sorted_allocList>
  80171f:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801722:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801725:	8b 40 08             	mov    0x8(%eax),%eax
  801728:	eb 05                	jmp    80172f <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  80172a:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
  801734:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80173d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801740:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801745:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	83 ec 08             	sub    $0x8,%esp
  80174e:	50                   	push   %eax
  80174f:	68 40 40 80 00       	push   $0x804040
  801754:	e8 71 0b 00 00       	call   8022ca <find_block>
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  80175f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801762:	8b 50 0c             	mov    0xc(%eax),%edx
  801765:	8b 45 08             	mov    0x8(%ebp),%eax
  801768:	83 ec 08             	sub    $0x8,%esp
  80176b:	52                   	push   %edx
  80176c:	50                   	push   %eax
  80176d:	e8 bd 03 00 00       	call   801b2f <sys_free_user_mem>
  801772:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801775:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801779:	75 14                	jne    80178f <free+0x5e>
  80177b:	83 ec 04             	sub    $0x4,%esp
  80177e:	68 d5 3c 80 00       	push   $0x803cd5
  801783:	6a 71                	push   $0x71
  801785:	68 f3 3c 80 00       	push   $0x803cf3
  80178a:	e8 47 ed ff ff       	call   8004d6 <_panic>
  80178f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801792:	8b 00                	mov    (%eax),%eax
  801794:	85 c0                	test   %eax,%eax
  801796:	74 10                	je     8017a8 <free+0x77>
  801798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179b:	8b 00                	mov    (%eax),%eax
  80179d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a0:	8b 52 04             	mov    0x4(%edx),%edx
  8017a3:	89 50 04             	mov    %edx,0x4(%eax)
  8017a6:	eb 0b                	jmp    8017b3 <free+0x82>
  8017a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ab:	8b 40 04             	mov    0x4(%eax),%eax
  8017ae:	a3 44 40 80 00       	mov    %eax,0x804044
  8017b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b6:	8b 40 04             	mov    0x4(%eax),%eax
  8017b9:	85 c0                	test   %eax,%eax
  8017bb:	74 0f                	je     8017cc <free+0x9b>
  8017bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c0:	8b 40 04             	mov    0x4(%eax),%eax
  8017c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017c6:	8b 12                	mov    (%edx),%edx
  8017c8:	89 10                	mov    %edx,(%eax)
  8017ca:	eb 0a                	jmp    8017d6 <free+0xa5>
  8017cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cf:	8b 00                	mov    (%eax),%eax
  8017d1:	a3 40 40 80 00       	mov    %eax,0x804040
  8017d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8017e9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8017ee:	48                   	dec    %eax
  8017ef:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8017f4:	83 ec 0c             	sub    $0xc,%esp
  8017f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8017fa:	e8 83 12 00 00       	call   802a82 <insert_sorted_with_merge_freeList>
  8017ff:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801802:	90                   	nop
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	83 ec 28             	sub    $0x28,%esp
  80180b:	8b 45 10             	mov    0x10(%ebp),%eax
  80180e:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801811:	e8 fe fc ff ff       	call   801514 <InitializeUHeap>
	if (size == 0) return NULL ;
  801816:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80181a:	75 0a                	jne    801826 <smalloc+0x21>
  80181c:	b8 00 00 00 00       	mov    $0x0,%eax
  801821:	e9 86 00 00 00       	jmp    8018ac <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801826:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80182d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801833:	01 d0                	add    %edx,%eax
  801835:	48                   	dec    %eax
  801836:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183c:	ba 00 00 00 00       	mov    $0x0,%edx
  801841:	f7 75 f4             	divl   -0xc(%ebp)
  801844:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801847:	29 d0                	sub    %edx,%eax
  801849:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80184c:	e8 e4 06 00 00       	call   801f35 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801851:	85 c0                	test   %eax,%eax
  801853:	74 52                	je     8018a7 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801855:	83 ec 0c             	sub    $0xc,%esp
  801858:	ff 75 0c             	pushl  0xc(%ebp)
  80185b:	e8 e6 0d 00 00       	call   802646 <alloc_block_FF>
  801860:	83 c4 10             	add    $0x10,%esp
  801863:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801866:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80186a:	75 07                	jne    801873 <smalloc+0x6e>
			return NULL ;
  80186c:	b8 00 00 00 00       	mov    $0x0,%eax
  801871:	eb 39                	jmp    8018ac <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801873:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801876:	8b 40 08             	mov    0x8(%eax),%eax
  801879:	89 c2                	mov    %eax,%edx
  80187b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80187f:	52                   	push   %edx
  801880:	50                   	push   %eax
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	ff 75 08             	pushl  0x8(%ebp)
  801887:	e8 2e 04 00 00       	call   801cba <sys_createSharedObject>
  80188c:	83 c4 10             	add    $0x10,%esp
  80188f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801892:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801896:	79 07                	jns    80189f <smalloc+0x9a>
			return (void*)NULL ;
  801898:	b8 00 00 00 00       	mov    $0x0,%eax
  80189d:	eb 0d                	jmp    8018ac <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  80189f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a2:	8b 40 08             	mov    0x8(%eax),%eax
  8018a5:	eb 05                	jmp    8018ac <smalloc+0xa7>
		}
		return (void*)NULL ;
  8018a7:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018b4:	e8 5b fc ff ff       	call   801514 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018b9:	83 ec 08             	sub    $0x8,%esp
  8018bc:	ff 75 0c             	pushl  0xc(%ebp)
  8018bf:	ff 75 08             	pushl  0x8(%ebp)
  8018c2:	e8 1d 04 00 00       	call   801ce4 <sys_getSizeOfSharedObject>
  8018c7:	83 c4 10             	add    $0x10,%esp
  8018ca:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8018cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018d1:	75 0a                	jne    8018dd <sget+0x2f>
			return NULL ;
  8018d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d8:	e9 83 00 00 00       	jmp    801960 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8018dd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ea:	01 d0                	add    %edx,%eax
  8018ec:	48                   	dec    %eax
  8018ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f8:	f7 75 f0             	divl   -0x10(%ebp)
  8018fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018fe:	29 d0                	sub    %edx,%eax
  801900:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801903:	e8 2d 06 00 00       	call   801f35 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801908:	85 c0                	test   %eax,%eax
  80190a:	74 4f                	je     80195b <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  80190c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190f:	83 ec 0c             	sub    $0xc,%esp
  801912:	50                   	push   %eax
  801913:	e8 2e 0d 00 00       	call   802646 <alloc_block_FF>
  801918:	83 c4 10             	add    $0x10,%esp
  80191b:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  80191e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801922:	75 07                	jne    80192b <sget+0x7d>
					return (void*)NULL ;
  801924:	b8 00 00 00 00       	mov    $0x0,%eax
  801929:	eb 35                	jmp    801960 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  80192b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80192e:	8b 40 08             	mov    0x8(%eax),%eax
  801931:	83 ec 04             	sub    $0x4,%esp
  801934:	50                   	push   %eax
  801935:	ff 75 0c             	pushl  0xc(%ebp)
  801938:	ff 75 08             	pushl  0x8(%ebp)
  80193b:	e8 c1 03 00 00       	call   801d01 <sys_getSharedObject>
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801946:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80194a:	79 07                	jns    801953 <sget+0xa5>
				return (void*)NULL ;
  80194c:	b8 00 00 00 00       	mov    $0x0,%eax
  801951:	eb 0d                	jmp    801960 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801953:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801956:	8b 40 08             	mov    0x8(%eax),%eax
  801959:	eb 05                	jmp    801960 <sget+0xb2>


		}
	return (void*)NULL ;
  80195b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801968:	e8 a7 fb ff ff       	call   801514 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80196d:	83 ec 04             	sub    $0x4,%esp
  801970:	68 00 3d 80 00       	push   $0x803d00
  801975:	68 f9 00 00 00       	push   $0xf9
  80197a:	68 f3 3c 80 00       	push   $0x803cf3
  80197f:	e8 52 eb ff ff       	call   8004d6 <_panic>

00801984 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80198a:	83 ec 04             	sub    $0x4,%esp
  80198d:	68 28 3d 80 00       	push   $0x803d28
  801992:	68 0d 01 00 00       	push   $0x10d
  801997:	68 f3 3c 80 00       	push   $0x803cf3
  80199c:	e8 35 eb ff ff       	call   8004d6 <_panic>

008019a1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019a7:	83 ec 04             	sub    $0x4,%esp
  8019aa:	68 4c 3d 80 00       	push   $0x803d4c
  8019af:	68 18 01 00 00       	push   $0x118
  8019b4:	68 f3 3c 80 00       	push   $0x803cf3
  8019b9:	e8 18 eb ff ff       	call   8004d6 <_panic>

008019be <shrink>:

}
void shrink(uint32 newSize)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019c4:	83 ec 04             	sub    $0x4,%esp
  8019c7:	68 4c 3d 80 00       	push   $0x803d4c
  8019cc:	68 1d 01 00 00       	push   $0x11d
  8019d1:	68 f3 3c 80 00       	push   $0x803cf3
  8019d6:	e8 fb ea ff ff       	call   8004d6 <_panic>

008019db <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019e1:	83 ec 04             	sub    $0x4,%esp
  8019e4:	68 4c 3d 80 00       	push   $0x803d4c
  8019e9:	68 22 01 00 00       	push   $0x122
  8019ee:	68 f3 3c 80 00       	push   $0x803cf3
  8019f3:	e8 de ea ff ff       	call   8004d6 <_panic>

008019f8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	57                   	push   %edi
  8019fc:	56                   	push   %esi
  8019fd:	53                   	push   %ebx
  8019fe:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a07:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a0a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a0d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a10:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a13:	cd 30                	int    $0x30
  801a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a1b:	83 c4 10             	add    $0x10,%esp
  801a1e:	5b                   	pop    %ebx
  801a1f:	5e                   	pop    %esi
  801a20:	5f                   	pop    %edi
  801a21:	5d                   	pop    %ebp
  801a22:	c3                   	ret    

00801a23 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	83 ec 04             	sub    $0x4,%esp
  801a29:	8b 45 10             	mov    0x10(%ebp),%eax
  801a2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a2f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	52                   	push   %edx
  801a3b:	ff 75 0c             	pushl  0xc(%ebp)
  801a3e:	50                   	push   %eax
  801a3f:	6a 00                	push   $0x0
  801a41:	e8 b2 ff ff ff       	call   8019f8 <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	90                   	nop
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sys_cgetc>:

int
sys_cgetc(void)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 01                	push   $0x1
  801a5b:	e8 98 ff ff ff       	call   8019f8 <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	52                   	push   %edx
  801a75:	50                   	push   %eax
  801a76:	6a 05                	push   $0x5
  801a78:	e8 7b ff ff ff       	call   8019f8 <syscall>
  801a7d:	83 c4 18             	add    $0x18,%esp
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	56                   	push   %esi
  801a86:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a87:	8b 75 18             	mov    0x18(%ebp),%esi
  801a8a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a8d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	56                   	push   %esi
  801a97:	53                   	push   %ebx
  801a98:	51                   	push   %ecx
  801a99:	52                   	push   %edx
  801a9a:	50                   	push   %eax
  801a9b:	6a 06                	push   $0x6
  801a9d:	e8 56 ff ff ff       	call   8019f8 <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa8:	5b                   	pop    %ebx
  801aa9:	5e                   	pop    %esi
  801aaa:	5d                   	pop    %ebp
  801aab:	c3                   	ret    

00801aac <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801aaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	52                   	push   %edx
  801abc:	50                   	push   %eax
  801abd:	6a 07                	push   $0x7
  801abf:	e8 34 ff ff ff       	call   8019f8 <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	ff 75 0c             	pushl  0xc(%ebp)
  801ad5:	ff 75 08             	pushl  0x8(%ebp)
  801ad8:	6a 08                	push   $0x8
  801ada:	e8 19 ff ff ff       	call   8019f8 <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 09                	push   $0x9
  801af3:	e8 00 ff ff ff       	call   8019f8 <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 0a                	push   $0xa
  801b0c:	e8 e7 fe ff ff       	call   8019f8 <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 0b                	push   $0xb
  801b25:	e8 ce fe ff ff       	call   8019f8 <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	ff 75 0c             	pushl  0xc(%ebp)
  801b3b:	ff 75 08             	pushl  0x8(%ebp)
  801b3e:	6a 0f                	push   $0xf
  801b40:	e8 b3 fe ff ff       	call   8019f8 <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
	return;
  801b48:	90                   	nop
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	ff 75 0c             	pushl  0xc(%ebp)
  801b57:	ff 75 08             	pushl  0x8(%ebp)
  801b5a:	6a 10                	push   $0x10
  801b5c:	e8 97 fe ff ff       	call   8019f8 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
	return ;
  801b64:	90                   	nop
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	ff 75 10             	pushl  0x10(%ebp)
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	ff 75 08             	pushl  0x8(%ebp)
  801b77:	6a 11                	push   $0x11
  801b79:	e8 7a fe ff ff       	call   8019f8 <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b81:	90                   	nop
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 0c                	push   $0xc
  801b93:	e8 60 fe ff ff       	call   8019f8 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	ff 75 08             	pushl  0x8(%ebp)
  801bab:	6a 0d                	push   $0xd
  801bad:	e8 46 fe ff ff       	call   8019f8 <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 0e                	push   $0xe
  801bc6:	e8 2d fe ff ff       	call   8019f8 <syscall>
  801bcb:	83 c4 18             	add    $0x18,%esp
}
  801bce:	90                   	nop
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 13                	push   $0x13
  801be0:	e8 13 fe ff ff       	call   8019f8 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	90                   	nop
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 14                	push   $0x14
  801bfa:	e8 f9 fd ff ff       	call   8019f8 <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
}
  801c02:	90                   	nop
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	83 ec 04             	sub    $0x4,%esp
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c11:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	50                   	push   %eax
  801c1e:	6a 15                	push   $0x15
  801c20:	e8 d3 fd ff ff       	call   8019f8 <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
}
  801c28:	90                   	nop
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 16                	push   $0x16
  801c3a:	e8 b9 fd ff ff       	call   8019f8 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	90                   	nop
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	ff 75 0c             	pushl  0xc(%ebp)
  801c54:	50                   	push   %eax
  801c55:	6a 17                	push   $0x17
  801c57:	e8 9c fd ff ff       	call   8019f8 <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c67:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	52                   	push   %edx
  801c71:	50                   	push   %eax
  801c72:	6a 1a                	push   $0x1a
  801c74:	e8 7f fd ff ff       	call   8019f8 <syscall>
  801c79:	83 c4 18             	add    $0x18,%esp
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	52                   	push   %edx
  801c8e:	50                   	push   %eax
  801c8f:	6a 18                	push   $0x18
  801c91:	e8 62 fd ff ff       	call   8019f8 <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
}
  801c99:	90                   	nop
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	52                   	push   %edx
  801cac:	50                   	push   %eax
  801cad:	6a 19                	push   $0x19
  801caf:	e8 44 fd ff ff       	call   8019f8 <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
}
  801cb7:	90                   	nop
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	83 ec 04             	sub    $0x4,%esp
  801cc0:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cc6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cc9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd0:	6a 00                	push   $0x0
  801cd2:	51                   	push   %ecx
  801cd3:	52                   	push   %edx
  801cd4:	ff 75 0c             	pushl  0xc(%ebp)
  801cd7:	50                   	push   %eax
  801cd8:	6a 1b                	push   $0x1b
  801cda:	e8 19 fd ff ff       	call   8019f8 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
}
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	52                   	push   %edx
  801cf4:	50                   	push   %eax
  801cf5:	6a 1c                	push   $0x1c
  801cf7:	e8 fc fc ff ff       	call   8019f8 <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d04:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	51                   	push   %ecx
  801d12:	52                   	push   %edx
  801d13:	50                   	push   %eax
  801d14:	6a 1d                	push   $0x1d
  801d16:	e8 dd fc ff ff       	call   8019f8 <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
}
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	52                   	push   %edx
  801d30:	50                   	push   %eax
  801d31:	6a 1e                	push   $0x1e
  801d33:	e8 c0 fc ff ff       	call   8019f8 <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 1f                	push   $0x1f
  801d4c:	e8 a7 fc ff ff       	call   8019f8 <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d59:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5c:	6a 00                	push   $0x0
  801d5e:	ff 75 14             	pushl  0x14(%ebp)
  801d61:	ff 75 10             	pushl  0x10(%ebp)
  801d64:	ff 75 0c             	pushl  0xc(%ebp)
  801d67:	50                   	push   %eax
  801d68:	6a 20                	push   $0x20
  801d6a:	e8 89 fc ff ff       	call   8019f8 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d77:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	50                   	push   %eax
  801d83:	6a 21                	push   $0x21
  801d85:	e8 6e fc ff ff       	call   8019f8 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
}
  801d8d:	90                   	nop
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	50                   	push   %eax
  801d9f:	6a 22                	push   $0x22
  801da1:	e8 52 fc ff ff       	call   8019f8 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 02                	push   $0x2
  801dba:	e8 39 fc ff ff       	call   8019f8 <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 03                	push   $0x3
  801dd3:	e8 20 fc ff ff       	call   8019f8 <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 04                	push   $0x4
  801dec:	e8 07 fc ff ff       	call   8019f8 <syscall>
  801df1:	83 c4 18             	add    $0x18,%esp
}
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <sys_exit_env>:


void sys_exit_env(void)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 23                	push   $0x23
  801e05:	e8 ee fb ff ff       	call   8019f8 <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
}
  801e0d:	90                   	nop
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e16:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e19:	8d 50 04             	lea    0x4(%eax),%edx
  801e1c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	52                   	push   %edx
  801e26:	50                   	push   %eax
  801e27:	6a 24                	push   $0x24
  801e29:	e8 ca fb ff ff       	call   8019f8 <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
	return result;
  801e31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e34:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e37:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e3a:	89 01                	mov    %eax,(%ecx)
  801e3c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	c9                   	leave  
  801e43:	c2 04 00             	ret    $0x4

00801e46 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	ff 75 10             	pushl  0x10(%ebp)
  801e50:	ff 75 0c             	pushl  0xc(%ebp)
  801e53:	ff 75 08             	pushl  0x8(%ebp)
  801e56:	6a 12                	push   $0x12
  801e58:	e8 9b fb ff ff       	call   8019f8 <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e60:	90                   	nop
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 25                	push   $0x25
  801e72:	e8 81 fb ff ff       	call   8019f8 <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	83 ec 04             	sub    $0x4,%esp
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e88:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	50                   	push   %eax
  801e95:	6a 26                	push   $0x26
  801e97:	e8 5c fb ff ff       	call   8019f8 <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9f:	90                   	nop
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <rsttst>:
void rsttst()
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 28                	push   $0x28
  801eb1:	e8 42 fb ff ff       	call   8019f8 <syscall>
  801eb6:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb9:	90                   	nop
}
  801eba:	c9                   	leave  
  801ebb:	c3                   	ret    

00801ebc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	83 ec 04             	sub    $0x4,%esp
  801ec2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ec8:	8b 55 18             	mov    0x18(%ebp),%edx
  801ecb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ecf:	52                   	push   %edx
  801ed0:	50                   	push   %eax
  801ed1:	ff 75 10             	pushl  0x10(%ebp)
  801ed4:	ff 75 0c             	pushl  0xc(%ebp)
  801ed7:	ff 75 08             	pushl  0x8(%ebp)
  801eda:	6a 27                	push   $0x27
  801edc:	e8 17 fb ff ff       	call   8019f8 <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee4:	90                   	nop
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <chktst>:
void chktst(uint32 n)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	ff 75 08             	pushl  0x8(%ebp)
  801ef5:	6a 29                	push   $0x29
  801ef7:	e8 fc fa ff ff       	call   8019f8 <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
	return ;
  801eff:	90                   	nop
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <inctst>:

void inctst()
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 2a                	push   $0x2a
  801f11:	e8 e2 fa ff ff       	call   8019f8 <syscall>
  801f16:	83 c4 18             	add    $0x18,%esp
	return ;
  801f19:	90                   	nop
}
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <gettst>:
uint32 gettst()
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 2b                	push   $0x2b
  801f2b:	e8 c8 fa ff ff       	call   8019f8 <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 2c                	push   $0x2c
  801f47:	e8 ac fa ff ff       	call   8019f8 <syscall>
  801f4c:	83 c4 18             	add    $0x18,%esp
  801f4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f52:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f56:	75 07                	jne    801f5f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f58:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5d:	eb 05                	jmp    801f64 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f64:	c9                   	leave  
  801f65:	c3                   	ret    

00801f66 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
  801f69:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 2c                	push   $0x2c
  801f78:	e8 7b fa ff ff       	call   8019f8 <syscall>
  801f7d:	83 c4 18             	add    $0x18,%esp
  801f80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f83:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f87:	75 07                	jne    801f90 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f89:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8e:	eb 05                	jmp    801f95 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
  801f9a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 2c                	push   $0x2c
  801fa9:	e8 4a fa ff ff       	call   8019f8 <syscall>
  801fae:	83 c4 18             	add    $0x18,%esp
  801fb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fb4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fb8:	75 07                	jne    801fc1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fba:	b8 01 00 00 00       	mov    $0x1,%eax
  801fbf:	eb 05                	jmp    801fc6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 2c                	push   $0x2c
  801fda:	e8 19 fa ff ff       	call   8019f8 <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
  801fe2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fe5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fe9:	75 07                	jne    801ff2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801feb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff0:	eb 05                	jmp    801ff7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ff2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	ff 75 08             	pushl  0x8(%ebp)
  802007:	6a 2d                	push   $0x2d
  802009:	e8 ea f9 ff ff       	call   8019f8 <syscall>
  80200e:	83 c4 18             	add    $0x18,%esp
	return ;
  802011:	90                   	nop
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802018:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80201b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80201e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	6a 00                	push   $0x0
  802026:	53                   	push   %ebx
  802027:	51                   	push   %ecx
  802028:	52                   	push   %edx
  802029:	50                   	push   %eax
  80202a:	6a 2e                	push   $0x2e
  80202c:	e8 c7 f9 ff ff       	call   8019f8 <syscall>
  802031:	83 c4 18             	add    $0x18,%esp
}
  802034:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80203c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	52                   	push   %edx
  802049:	50                   	push   %eax
  80204a:	6a 2f                	push   $0x2f
  80204c:	e8 a7 f9 ff ff       	call   8019f8 <syscall>
  802051:	83 c4 18             	add    $0x18,%esp
}
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80205c:	83 ec 0c             	sub    $0xc,%esp
  80205f:	68 5c 3d 80 00       	push   $0x803d5c
  802064:	e8 21 e7 ff ff       	call   80078a <cprintf>
  802069:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80206c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802073:	83 ec 0c             	sub    $0xc,%esp
  802076:	68 88 3d 80 00       	push   $0x803d88
  80207b:	e8 0a e7 ff ff       	call   80078a <cprintf>
  802080:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802083:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802087:	a1 38 41 80 00       	mov    0x804138,%eax
  80208c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80208f:	eb 56                	jmp    8020e7 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802091:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802095:	74 1c                	je     8020b3 <print_mem_block_lists+0x5d>
  802097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209a:	8b 50 08             	mov    0x8(%eax),%edx
  80209d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a0:	8b 48 08             	mov    0x8(%eax),%ecx
  8020a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a9:	01 c8                	add    %ecx,%eax
  8020ab:	39 c2                	cmp    %eax,%edx
  8020ad:	73 04                	jae    8020b3 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020af:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b6:	8b 50 08             	mov    0x8(%eax),%edx
  8020b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8020bf:	01 c2                	add    %eax,%edx
  8020c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c4:	8b 40 08             	mov    0x8(%eax),%eax
  8020c7:	83 ec 04             	sub    $0x4,%esp
  8020ca:	52                   	push   %edx
  8020cb:	50                   	push   %eax
  8020cc:	68 9d 3d 80 00       	push   $0x803d9d
  8020d1:	e8 b4 e6 ff ff       	call   80078a <cprintf>
  8020d6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020df:	a1 40 41 80 00       	mov    0x804140,%eax
  8020e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020eb:	74 07                	je     8020f4 <print_mem_block_lists+0x9e>
  8020ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f0:	8b 00                	mov    (%eax),%eax
  8020f2:	eb 05                	jmp    8020f9 <print_mem_block_lists+0xa3>
  8020f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f9:	a3 40 41 80 00       	mov    %eax,0x804140
  8020fe:	a1 40 41 80 00       	mov    0x804140,%eax
  802103:	85 c0                	test   %eax,%eax
  802105:	75 8a                	jne    802091 <print_mem_block_lists+0x3b>
  802107:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80210b:	75 84                	jne    802091 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80210d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802111:	75 10                	jne    802123 <print_mem_block_lists+0xcd>
  802113:	83 ec 0c             	sub    $0xc,%esp
  802116:	68 ac 3d 80 00       	push   $0x803dac
  80211b:	e8 6a e6 ff ff       	call   80078a <cprintf>
  802120:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802123:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80212a:	83 ec 0c             	sub    $0xc,%esp
  80212d:	68 d0 3d 80 00       	push   $0x803dd0
  802132:	e8 53 e6 ff ff       	call   80078a <cprintf>
  802137:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80213a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80213e:	a1 40 40 80 00       	mov    0x804040,%eax
  802143:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802146:	eb 56                	jmp    80219e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802148:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80214c:	74 1c                	je     80216a <print_mem_block_lists+0x114>
  80214e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802151:	8b 50 08             	mov    0x8(%eax),%edx
  802154:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802157:	8b 48 08             	mov    0x8(%eax),%ecx
  80215a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215d:	8b 40 0c             	mov    0xc(%eax),%eax
  802160:	01 c8                	add    %ecx,%eax
  802162:	39 c2                	cmp    %eax,%edx
  802164:	73 04                	jae    80216a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802166:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80216a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216d:	8b 50 08             	mov    0x8(%eax),%edx
  802170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802173:	8b 40 0c             	mov    0xc(%eax),%eax
  802176:	01 c2                	add    %eax,%edx
  802178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217b:	8b 40 08             	mov    0x8(%eax),%eax
  80217e:	83 ec 04             	sub    $0x4,%esp
  802181:	52                   	push   %edx
  802182:	50                   	push   %eax
  802183:	68 9d 3d 80 00       	push   $0x803d9d
  802188:	e8 fd e5 ff ff       	call   80078a <cprintf>
  80218d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802193:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802196:	a1 48 40 80 00       	mov    0x804048,%eax
  80219b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80219e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a2:	74 07                	je     8021ab <print_mem_block_lists+0x155>
  8021a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a7:	8b 00                	mov    (%eax),%eax
  8021a9:	eb 05                	jmp    8021b0 <print_mem_block_lists+0x15a>
  8021ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b0:	a3 48 40 80 00       	mov    %eax,0x804048
  8021b5:	a1 48 40 80 00       	mov    0x804048,%eax
  8021ba:	85 c0                	test   %eax,%eax
  8021bc:	75 8a                	jne    802148 <print_mem_block_lists+0xf2>
  8021be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c2:	75 84                	jne    802148 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021c4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021c8:	75 10                	jne    8021da <print_mem_block_lists+0x184>
  8021ca:	83 ec 0c             	sub    $0xc,%esp
  8021cd:	68 e8 3d 80 00       	push   $0x803de8
  8021d2:	e8 b3 e5 ff ff       	call   80078a <cprintf>
  8021d7:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021da:	83 ec 0c             	sub    $0xc,%esp
  8021dd:	68 5c 3d 80 00       	push   $0x803d5c
  8021e2:	e8 a3 e5 ff ff       	call   80078a <cprintf>
  8021e7:	83 c4 10             	add    $0x10,%esp

}
  8021ea:	90                   	nop
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8021f3:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8021fa:	00 00 00 
  8021fd:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802204:	00 00 00 
  802207:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80220e:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802218:	e9 9e 00 00 00       	jmp    8022bb <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  80221d:	a1 50 40 80 00       	mov    0x804050,%eax
  802222:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802225:	c1 e2 04             	shl    $0x4,%edx
  802228:	01 d0                	add    %edx,%eax
  80222a:	85 c0                	test   %eax,%eax
  80222c:	75 14                	jne    802242 <initialize_MemBlocksList+0x55>
  80222e:	83 ec 04             	sub    $0x4,%esp
  802231:	68 10 3e 80 00       	push   $0x803e10
  802236:	6a 43                	push   $0x43
  802238:	68 33 3e 80 00       	push   $0x803e33
  80223d:	e8 94 e2 ff ff       	call   8004d6 <_panic>
  802242:	a1 50 40 80 00       	mov    0x804050,%eax
  802247:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224a:	c1 e2 04             	shl    $0x4,%edx
  80224d:	01 d0                	add    %edx,%eax
  80224f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802255:	89 10                	mov    %edx,(%eax)
  802257:	8b 00                	mov    (%eax),%eax
  802259:	85 c0                	test   %eax,%eax
  80225b:	74 18                	je     802275 <initialize_MemBlocksList+0x88>
  80225d:	a1 48 41 80 00       	mov    0x804148,%eax
  802262:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802268:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80226b:	c1 e1 04             	shl    $0x4,%ecx
  80226e:	01 ca                	add    %ecx,%edx
  802270:	89 50 04             	mov    %edx,0x4(%eax)
  802273:	eb 12                	jmp    802287 <initialize_MemBlocksList+0x9a>
  802275:	a1 50 40 80 00       	mov    0x804050,%eax
  80227a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227d:	c1 e2 04             	shl    $0x4,%edx
  802280:	01 d0                	add    %edx,%eax
  802282:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802287:	a1 50 40 80 00       	mov    0x804050,%eax
  80228c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228f:	c1 e2 04             	shl    $0x4,%edx
  802292:	01 d0                	add    %edx,%eax
  802294:	a3 48 41 80 00       	mov    %eax,0x804148
  802299:	a1 50 40 80 00       	mov    0x804050,%eax
  80229e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a1:	c1 e2 04             	shl    $0x4,%edx
  8022a4:	01 d0                	add    %edx,%eax
  8022a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ad:	a1 54 41 80 00       	mov    0x804154,%eax
  8022b2:	40                   	inc    %eax
  8022b3:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8022b8:	ff 45 f4             	incl   -0xc(%ebp)
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022c1:	0f 82 56 ff ff ff    	jb     80221d <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8022c7:	90                   	nop
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8022d0:	a1 38 41 80 00       	mov    0x804138,%eax
  8022d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022d8:	eb 18                	jmp    8022f2 <find_block+0x28>
	{
		if (ele->sva==va)
  8022da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022dd:	8b 40 08             	mov    0x8(%eax),%eax
  8022e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022e3:	75 05                	jne    8022ea <find_block+0x20>
			return ele;
  8022e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022e8:	eb 7b                	jmp    802365 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8022ea:	a1 40 41 80 00       	mov    0x804140,%eax
  8022ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022f6:	74 07                	je     8022ff <find_block+0x35>
  8022f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022fb:	8b 00                	mov    (%eax),%eax
  8022fd:	eb 05                	jmp    802304 <find_block+0x3a>
  8022ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802304:	a3 40 41 80 00       	mov    %eax,0x804140
  802309:	a1 40 41 80 00       	mov    0x804140,%eax
  80230e:	85 c0                	test   %eax,%eax
  802310:	75 c8                	jne    8022da <find_block+0x10>
  802312:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802316:	75 c2                	jne    8022da <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802318:	a1 40 40 80 00       	mov    0x804040,%eax
  80231d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802320:	eb 18                	jmp    80233a <find_block+0x70>
	{
		if (ele->sva==va)
  802322:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802325:	8b 40 08             	mov    0x8(%eax),%eax
  802328:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80232b:	75 05                	jne    802332 <find_block+0x68>
					return ele;
  80232d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802330:	eb 33                	jmp    802365 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802332:	a1 48 40 80 00       	mov    0x804048,%eax
  802337:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80233a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80233e:	74 07                	je     802347 <find_block+0x7d>
  802340:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802343:	8b 00                	mov    (%eax),%eax
  802345:	eb 05                	jmp    80234c <find_block+0x82>
  802347:	b8 00 00 00 00       	mov    $0x0,%eax
  80234c:	a3 48 40 80 00       	mov    %eax,0x804048
  802351:	a1 48 40 80 00       	mov    0x804048,%eax
  802356:	85 c0                	test   %eax,%eax
  802358:	75 c8                	jne    802322 <find_block+0x58>
  80235a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80235e:	75 c2                	jne    802322 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802360:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
  80236a:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  80236d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802372:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802375:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802379:	75 62                	jne    8023dd <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80237b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80237f:	75 14                	jne    802395 <insert_sorted_allocList+0x2e>
  802381:	83 ec 04             	sub    $0x4,%esp
  802384:	68 10 3e 80 00       	push   $0x803e10
  802389:	6a 69                	push   $0x69
  80238b:	68 33 3e 80 00       	push   $0x803e33
  802390:	e8 41 e1 ff ff       	call   8004d6 <_panic>
  802395:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	89 10                	mov    %edx,(%eax)
  8023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a3:	8b 00                	mov    (%eax),%eax
  8023a5:	85 c0                	test   %eax,%eax
  8023a7:	74 0d                	je     8023b6 <insert_sorted_allocList+0x4f>
  8023a9:	a1 40 40 80 00       	mov    0x804040,%eax
  8023ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b1:	89 50 04             	mov    %edx,0x4(%eax)
  8023b4:	eb 08                	jmp    8023be <insert_sorted_allocList+0x57>
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	a3 44 40 80 00       	mov    %eax,0x804044
  8023be:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c1:	a3 40 40 80 00       	mov    %eax,0x804040
  8023c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023d0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023d5:	40                   	inc    %eax
  8023d6:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8023db:	eb 72                	jmp    80244f <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8023dd:	a1 40 40 80 00       	mov    0x804040,%eax
  8023e2:	8b 50 08             	mov    0x8(%eax),%edx
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	8b 40 08             	mov    0x8(%eax),%eax
  8023eb:	39 c2                	cmp    %eax,%edx
  8023ed:	76 60                	jbe    80244f <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8023ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023f3:	75 14                	jne    802409 <insert_sorted_allocList+0xa2>
  8023f5:	83 ec 04             	sub    $0x4,%esp
  8023f8:	68 10 3e 80 00       	push   $0x803e10
  8023fd:	6a 6d                	push   $0x6d
  8023ff:	68 33 3e 80 00       	push   $0x803e33
  802404:	e8 cd e0 ff ff       	call   8004d6 <_panic>
  802409:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	89 10                	mov    %edx,(%eax)
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	8b 00                	mov    (%eax),%eax
  802419:	85 c0                	test   %eax,%eax
  80241b:	74 0d                	je     80242a <insert_sorted_allocList+0xc3>
  80241d:	a1 40 40 80 00       	mov    0x804040,%eax
  802422:	8b 55 08             	mov    0x8(%ebp),%edx
  802425:	89 50 04             	mov    %edx,0x4(%eax)
  802428:	eb 08                	jmp    802432 <insert_sorted_allocList+0xcb>
  80242a:	8b 45 08             	mov    0x8(%ebp),%eax
  80242d:	a3 44 40 80 00       	mov    %eax,0x804044
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	a3 40 40 80 00       	mov    %eax,0x804040
  80243a:	8b 45 08             	mov    0x8(%ebp),%eax
  80243d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802444:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802449:	40                   	inc    %eax
  80244a:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80244f:	a1 40 40 80 00       	mov    0x804040,%eax
  802454:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802457:	e9 b9 01 00 00       	jmp    802615 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	8b 50 08             	mov    0x8(%eax),%edx
  802462:	a1 40 40 80 00       	mov    0x804040,%eax
  802467:	8b 40 08             	mov    0x8(%eax),%eax
  80246a:	39 c2                	cmp    %eax,%edx
  80246c:	76 7c                	jbe    8024ea <insert_sorted_allocList+0x183>
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	8b 50 08             	mov    0x8(%eax),%edx
  802474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802477:	8b 40 08             	mov    0x8(%eax),%eax
  80247a:	39 c2                	cmp    %eax,%edx
  80247c:	73 6c                	jae    8024ea <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  80247e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802482:	74 06                	je     80248a <insert_sorted_allocList+0x123>
  802484:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802488:	75 14                	jne    80249e <insert_sorted_allocList+0x137>
  80248a:	83 ec 04             	sub    $0x4,%esp
  80248d:	68 4c 3e 80 00       	push   $0x803e4c
  802492:	6a 75                	push   $0x75
  802494:	68 33 3e 80 00       	push   $0x803e33
  802499:	e8 38 e0 ff ff       	call   8004d6 <_panic>
  80249e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a1:	8b 50 04             	mov    0x4(%eax),%edx
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	89 50 04             	mov    %edx,0x4(%eax)
  8024aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b0:	89 10                	mov    %edx,(%eax)
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	8b 40 04             	mov    0x4(%eax),%eax
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	74 0d                	je     8024c9 <insert_sorted_allocList+0x162>
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	8b 40 04             	mov    0x4(%eax),%eax
  8024c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c5:	89 10                	mov    %edx,(%eax)
  8024c7:	eb 08                	jmp    8024d1 <insert_sorted_allocList+0x16a>
  8024c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cc:	a3 40 40 80 00       	mov    %eax,0x804040
  8024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d7:	89 50 04             	mov    %edx,0x4(%eax)
  8024da:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024df:	40                   	inc    %eax
  8024e0:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  8024e5:	e9 59 01 00 00       	jmp    802643 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ed:	8b 50 08             	mov    0x8(%eax),%edx
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	8b 40 08             	mov    0x8(%eax),%eax
  8024f6:	39 c2                	cmp    %eax,%edx
  8024f8:	0f 86 98 00 00 00    	jbe    802596 <insert_sorted_allocList+0x22f>
  8024fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802501:	8b 50 08             	mov    0x8(%eax),%edx
  802504:	a1 44 40 80 00       	mov    0x804044,%eax
  802509:	8b 40 08             	mov    0x8(%eax),%eax
  80250c:	39 c2                	cmp    %eax,%edx
  80250e:	0f 83 82 00 00 00    	jae    802596 <insert_sorted_allocList+0x22f>
  802514:	8b 45 08             	mov    0x8(%ebp),%eax
  802517:	8b 50 08             	mov    0x8(%eax),%edx
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	8b 00                	mov    (%eax),%eax
  80251f:	8b 40 08             	mov    0x8(%eax),%eax
  802522:	39 c2                	cmp    %eax,%edx
  802524:	73 70                	jae    802596 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802526:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252a:	74 06                	je     802532 <insert_sorted_allocList+0x1cb>
  80252c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802530:	75 14                	jne    802546 <insert_sorted_allocList+0x1df>
  802532:	83 ec 04             	sub    $0x4,%esp
  802535:	68 84 3e 80 00       	push   $0x803e84
  80253a:	6a 7c                	push   $0x7c
  80253c:	68 33 3e 80 00       	push   $0x803e33
  802541:	e8 90 df ff ff       	call   8004d6 <_panic>
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 10                	mov    (%eax),%edx
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	89 10                	mov    %edx,(%eax)
  802550:	8b 45 08             	mov    0x8(%ebp),%eax
  802553:	8b 00                	mov    (%eax),%eax
  802555:	85 c0                	test   %eax,%eax
  802557:	74 0b                	je     802564 <insert_sorted_allocList+0x1fd>
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	8b 00                	mov    (%eax),%eax
  80255e:	8b 55 08             	mov    0x8(%ebp),%edx
  802561:	89 50 04             	mov    %edx,0x4(%eax)
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	8b 55 08             	mov    0x8(%ebp),%edx
  80256a:	89 10                	mov    %edx,(%eax)
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802572:	89 50 04             	mov    %edx,0x4(%eax)
  802575:	8b 45 08             	mov    0x8(%ebp),%eax
  802578:	8b 00                	mov    (%eax),%eax
  80257a:	85 c0                	test   %eax,%eax
  80257c:	75 08                	jne    802586 <insert_sorted_allocList+0x21f>
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	a3 44 40 80 00       	mov    %eax,0x804044
  802586:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80258b:	40                   	inc    %eax
  80258c:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802591:	e9 ad 00 00 00       	jmp    802643 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802596:	8b 45 08             	mov    0x8(%ebp),%eax
  802599:	8b 50 08             	mov    0x8(%eax),%edx
  80259c:	a1 44 40 80 00       	mov    0x804044,%eax
  8025a1:	8b 40 08             	mov    0x8(%eax),%eax
  8025a4:	39 c2                	cmp    %eax,%edx
  8025a6:	76 65                	jbe    80260d <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  8025a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025ac:	75 17                	jne    8025c5 <insert_sorted_allocList+0x25e>
  8025ae:	83 ec 04             	sub    $0x4,%esp
  8025b1:	68 b8 3e 80 00       	push   $0x803eb8
  8025b6:	68 80 00 00 00       	push   $0x80
  8025bb:	68 33 3e 80 00       	push   $0x803e33
  8025c0:	e8 11 df ff ff       	call   8004d6 <_panic>
  8025c5:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8025cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ce:	89 50 04             	mov    %edx,0x4(%eax)
  8025d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d4:	8b 40 04             	mov    0x4(%eax),%eax
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	74 0c                	je     8025e7 <insert_sorted_allocList+0x280>
  8025db:	a1 44 40 80 00       	mov    0x804044,%eax
  8025e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e3:	89 10                	mov    %edx,(%eax)
  8025e5:	eb 08                	jmp    8025ef <insert_sorted_allocList+0x288>
  8025e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ea:	a3 40 40 80 00       	mov    %eax,0x804040
  8025ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f2:	a3 44 40 80 00       	mov    %eax,0x804044
  8025f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802600:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802605:	40                   	inc    %eax
  802606:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  80260b:	eb 36                	jmp    802643 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80260d:	a1 48 40 80 00       	mov    0x804048,%eax
  802612:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802619:	74 07                	je     802622 <insert_sorted_allocList+0x2bb>
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	8b 00                	mov    (%eax),%eax
  802620:	eb 05                	jmp    802627 <insert_sorted_allocList+0x2c0>
  802622:	b8 00 00 00 00       	mov    $0x0,%eax
  802627:	a3 48 40 80 00       	mov    %eax,0x804048
  80262c:	a1 48 40 80 00       	mov    0x804048,%eax
  802631:	85 c0                	test   %eax,%eax
  802633:	0f 85 23 fe ff ff    	jne    80245c <insert_sorted_allocList+0xf5>
  802639:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263d:	0f 85 19 fe ff ff    	jne    80245c <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802643:	90                   	nop
  802644:	c9                   	leave  
  802645:	c3                   	ret    

00802646 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802646:	55                   	push   %ebp
  802647:	89 e5                	mov    %esp,%ebp
  802649:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80264c:	a1 38 41 80 00       	mov    0x804138,%eax
  802651:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802654:	e9 7c 01 00 00       	jmp    8027d5 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	8b 40 0c             	mov    0xc(%eax),%eax
  80265f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802662:	0f 85 90 00 00 00    	jne    8026f8 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  80266e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802672:	75 17                	jne    80268b <alloc_block_FF+0x45>
  802674:	83 ec 04             	sub    $0x4,%esp
  802677:	68 db 3e 80 00       	push   $0x803edb
  80267c:	68 ba 00 00 00       	push   $0xba
  802681:	68 33 3e 80 00       	push   $0x803e33
  802686:	e8 4b de ff ff       	call   8004d6 <_panic>
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	8b 00                	mov    (%eax),%eax
  802690:	85 c0                	test   %eax,%eax
  802692:	74 10                	je     8026a4 <alloc_block_FF+0x5e>
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	8b 00                	mov    (%eax),%eax
  802699:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269c:	8b 52 04             	mov    0x4(%edx),%edx
  80269f:	89 50 04             	mov    %edx,0x4(%eax)
  8026a2:	eb 0b                	jmp    8026af <alloc_block_FF+0x69>
  8026a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a7:	8b 40 04             	mov    0x4(%eax),%eax
  8026aa:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	8b 40 04             	mov    0x4(%eax),%eax
  8026b5:	85 c0                	test   %eax,%eax
  8026b7:	74 0f                	je     8026c8 <alloc_block_FF+0x82>
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 40 04             	mov    0x4(%eax),%eax
  8026bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c2:	8b 12                	mov    (%edx),%edx
  8026c4:	89 10                	mov    %edx,(%eax)
  8026c6:	eb 0a                	jmp    8026d2 <alloc_block_FF+0x8c>
  8026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cb:	8b 00                	mov    (%eax),%eax
  8026cd:	a3 38 41 80 00       	mov    %eax,0x804138
  8026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e5:	a1 44 41 80 00       	mov    0x804144,%eax
  8026ea:	48                   	dec    %eax
  8026eb:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8026f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f3:	e9 10 01 00 00       	jmp    802808 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802701:	0f 86 c6 00 00 00    	jbe    8027cd <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802707:	a1 48 41 80 00       	mov    0x804148,%eax
  80270c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80270f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802713:	75 17                	jne    80272c <alloc_block_FF+0xe6>
  802715:	83 ec 04             	sub    $0x4,%esp
  802718:	68 db 3e 80 00       	push   $0x803edb
  80271d:	68 c2 00 00 00       	push   $0xc2
  802722:	68 33 3e 80 00       	push   $0x803e33
  802727:	e8 aa dd ff ff       	call   8004d6 <_panic>
  80272c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272f:	8b 00                	mov    (%eax),%eax
  802731:	85 c0                	test   %eax,%eax
  802733:	74 10                	je     802745 <alloc_block_FF+0xff>
  802735:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802738:	8b 00                	mov    (%eax),%eax
  80273a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80273d:	8b 52 04             	mov    0x4(%edx),%edx
  802740:	89 50 04             	mov    %edx,0x4(%eax)
  802743:	eb 0b                	jmp    802750 <alloc_block_FF+0x10a>
  802745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802748:	8b 40 04             	mov    0x4(%eax),%eax
  80274b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802753:	8b 40 04             	mov    0x4(%eax),%eax
  802756:	85 c0                	test   %eax,%eax
  802758:	74 0f                	je     802769 <alloc_block_FF+0x123>
  80275a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275d:	8b 40 04             	mov    0x4(%eax),%eax
  802760:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802763:	8b 12                	mov    (%edx),%edx
  802765:	89 10                	mov    %edx,(%eax)
  802767:	eb 0a                	jmp    802773 <alloc_block_FF+0x12d>
  802769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276c:	8b 00                	mov    (%eax),%eax
  80276e:	a3 48 41 80 00       	mov    %eax,0x804148
  802773:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802776:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80277c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802786:	a1 54 41 80 00       	mov    0x804154,%eax
  80278b:	48                   	dec    %eax
  80278c:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 50 08             	mov    0x8(%eax),%edx
  802797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279a:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  80279d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a3:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ac:	2b 45 08             	sub    0x8(%ebp),%eax
  8027af:	89 c2                	mov    %eax,%edx
  8027b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b4:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	8b 50 08             	mov    0x8(%eax),%edx
  8027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c0:	01 c2                	add    %eax,%edx
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8027c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cb:	eb 3b                	jmp    802808 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8027cd:	a1 40 41 80 00       	mov    0x804140,%eax
  8027d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d9:	74 07                	je     8027e2 <alloc_block_FF+0x19c>
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 00                	mov    (%eax),%eax
  8027e0:	eb 05                	jmp    8027e7 <alloc_block_FF+0x1a1>
  8027e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e7:	a3 40 41 80 00       	mov    %eax,0x804140
  8027ec:	a1 40 41 80 00       	mov    0x804140,%eax
  8027f1:	85 c0                	test   %eax,%eax
  8027f3:	0f 85 60 fe ff ff    	jne    802659 <alloc_block_FF+0x13>
  8027f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fd:	0f 85 56 fe ff ff    	jne    802659 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802803:	b8 00 00 00 00       	mov    $0x0,%eax
  802808:	c9                   	leave  
  802809:	c3                   	ret    

0080280a <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  80280a:	55                   	push   %ebp
  80280b:	89 e5                	mov    %esp,%ebp
  80280d:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802810:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802817:	a1 38 41 80 00       	mov    0x804138,%eax
  80281c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80281f:	eb 3a                	jmp    80285b <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	8b 40 0c             	mov    0xc(%eax),%eax
  802827:	3b 45 08             	cmp    0x8(%ebp),%eax
  80282a:	72 27                	jb     802853 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  80282c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802830:	75 0b                	jne    80283d <alloc_block_BF+0x33>
					best_size= element->size;
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	8b 40 0c             	mov    0xc(%eax),%eax
  802838:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80283b:	eb 16                	jmp    802853 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	8b 50 0c             	mov    0xc(%eax),%edx
  802843:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802846:	39 c2                	cmp    %eax,%edx
  802848:	77 09                	ja     802853 <alloc_block_BF+0x49>
					best_size=element->size;
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	8b 40 0c             	mov    0xc(%eax),%eax
  802850:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802853:	a1 40 41 80 00       	mov    0x804140,%eax
  802858:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285f:	74 07                	je     802868 <alloc_block_BF+0x5e>
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	8b 00                	mov    (%eax),%eax
  802866:	eb 05                	jmp    80286d <alloc_block_BF+0x63>
  802868:	b8 00 00 00 00       	mov    $0x0,%eax
  80286d:	a3 40 41 80 00       	mov    %eax,0x804140
  802872:	a1 40 41 80 00       	mov    0x804140,%eax
  802877:	85 c0                	test   %eax,%eax
  802879:	75 a6                	jne    802821 <alloc_block_BF+0x17>
  80287b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287f:	75 a0                	jne    802821 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802881:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802885:	0f 84 d3 01 00 00    	je     802a5e <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80288b:	a1 38 41 80 00       	mov    0x804138,%eax
  802890:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802893:	e9 98 01 00 00       	jmp    802a30 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80289e:	0f 86 da 00 00 00    	jbe    80297e <alloc_block_BF+0x174>
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 50 0c             	mov    0xc(%eax),%edx
  8028aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ad:	39 c2                	cmp    %eax,%edx
  8028af:	0f 85 c9 00 00 00    	jne    80297e <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  8028b5:	a1 48 41 80 00       	mov    0x804148,%eax
  8028ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8028bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028c1:	75 17                	jne    8028da <alloc_block_BF+0xd0>
  8028c3:	83 ec 04             	sub    $0x4,%esp
  8028c6:	68 db 3e 80 00       	push   $0x803edb
  8028cb:	68 ea 00 00 00       	push   $0xea
  8028d0:	68 33 3e 80 00       	push   $0x803e33
  8028d5:	e8 fc db ff ff       	call   8004d6 <_panic>
  8028da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028dd:	8b 00                	mov    (%eax),%eax
  8028df:	85 c0                	test   %eax,%eax
  8028e1:	74 10                	je     8028f3 <alloc_block_BF+0xe9>
  8028e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e6:	8b 00                	mov    (%eax),%eax
  8028e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028eb:	8b 52 04             	mov    0x4(%edx),%edx
  8028ee:	89 50 04             	mov    %edx,0x4(%eax)
  8028f1:	eb 0b                	jmp    8028fe <alloc_block_BF+0xf4>
  8028f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f6:	8b 40 04             	mov    0x4(%eax),%eax
  8028f9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802901:	8b 40 04             	mov    0x4(%eax),%eax
  802904:	85 c0                	test   %eax,%eax
  802906:	74 0f                	je     802917 <alloc_block_BF+0x10d>
  802908:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290b:	8b 40 04             	mov    0x4(%eax),%eax
  80290e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802911:	8b 12                	mov    (%edx),%edx
  802913:	89 10                	mov    %edx,(%eax)
  802915:	eb 0a                	jmp    802921 <alloc_block_BF+0x117>
  802917:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291a:	8b 00                	mov    (%eax),%eax
  80291c:	a3 48 41 80 00       	mov    %eax,0x804148
  802921:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802924:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80292a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802934:	a1 54 41 80 00       	mov    0x804154,%eax
  802939:	48                   	dec    %eax
  80293a:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  80293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802942:	8b 50 08             	mov    0x8(%eax),%edx
  802945:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802948:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  80294b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294e:	8b 55 08             	mov    0x8(%ebp),%edx
  802951:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	8b 40 0c             	mov    0xc(%eax),%eax
  80295a:	2b 45 08             	sub    0x8(%ebp),%eax
  80295d:	89 c2                	mov    %eax,%edx
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 50 08             	mov    0x8(%eax),%edx
  80296b:	8b 45 08             	mov    0x8(%ebp),%eax
  80296e:	01 c2                	add    %eax,%edx
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802976:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802979:	e9 e5 00 00 00       	jmp    802a63 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	8b 50 0c             	mov    0xc(%eax),%edx
  802984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802987:	39 c2                	cmp    %eax,%edx
  802989:	0f 85 99 00 00 00    	jne    802a28 <alloc_block_BF+0x21e>
  80298f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802992:	3b 45 08             	cmp    0x8(%ebp),%eax
  802995:	0f 85 8d 00 00 00    	jne    802a28 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  80299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  8029a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a5:	75 17                	jne    8029be <alloc_block_BF+0x1b4>
  8029a7:	83 ec 04             	sub    $0x4,%esp
  8029aa:	68 db 3e 80 00       	push   $0x803edb
  8029af:	68 f7 00 00 00       	push   $0xf7
  8029b4:	68 33 3e 80 00       	push   $0x803e33
  8029b9:	e8 18 db ff ff       	call   8004d6 <_panic>
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	8b 00                	mov    (%eax),%eax
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	74 10                	je     8029d7 <alloc_block_BF+0x1cd>
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 00                	mov    (%eax),%eax
  8029cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029cf:	8b 52 04             	mov    0x4(%edx),%edx
  8029d2:	89 50 04             	mov    %edx,0x4(%eax)
  8029d5:	eb 0b                	jmp    8029e2 <alloc_block_BF+0x1d8>
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	8b 40 04             	mov    0x4(%eax),%eax
  8029dd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e5:	8b 40 04             	mov    0x4(%eax),%eax
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	74 0f                	je     8029fb <alloc_block_BF+0x1f1>
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 40 04             	mov    0x4(%eax),%eax
  8029f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f5:	8b 12                	mov    (%edx),%edx
  8029f7:	89 10                	mov    %edx,(%eax)
  8029f9:	eb 0a                	jmp    802a05 <alloc_block_BF+0x1fb>
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	8b 00                	mov    (%eax),%eax
  802a00:	a3 38 41 80 00       	mov    %eax,0x804138
  802a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a18:	a1 44 41 80 00       	mov    0x804144,%eax
  802a1d:	48                   	dec    %eax
  802a1e:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  802a23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a26:	eb 3b                	jmp    802a63 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802a28:	a1 40 41 80 00       	mov    0x804140,%eax
  802a2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a34:	74 07                	je     802a3d <alloc_block_BF+0x233>
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	8b 00                	mov    (%eax),%eax
  802a3b:	eb 05                	jmp    802a42 <alloc_block_BF+0x238>
  802a3d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a42:	a3 40 41 80 00       	mov    %eax,0x804140
  802a47:	a1 40 41 80 00       	mov    0x804140,%eax
  802a4c:	85 c0                	test   %eax,%eax
  802a4e:	0f 85 44 fe ff ff    	jne    802898 <alloc_block_BF+0x8e>
  802a54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a58:	0f 85 3a fe ff ff    	jne    802898 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a63:	c9                   	leave  
  802a64:	c3                   	ret    

00802a65 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a65:	55                   	push   %ebp
  802a66:	89 e5                	mov    %esp,%ebp
  802a68:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802a6b:	83 ec 04             	sub    $0x4,%esp
  802a6e:	68 fc 3e 80 00       	push   $0x803efc
  802a73:	68 04 01 00 00       	push   $0x104
  802a78:	68 33 3e 80 00       	push   $0x803e33
  802a7d:	e8 54 da ff ff       	call   8004d6 <_panic>

00802a82 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802a82:	55                   	push   %ebp
  802a83:	89 e5                	mov    %esp,%ebp
  802a85:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802a88:	a1 38 41 80 00       	mov    0x804138,%eax
  802a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802a90:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a95:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802a98:	a1 38 41 80 00       	mov    0x804138,%eax
  802a9d:	85 c0                	test   %eax,%eax
  802a9f:	75 68                	jne    802b09 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802aa1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aa5:	75 17                	jne    802abe <insert_sorted_with_merge_freeList+0x3c>
  802aa7:	83 ec 04             	sub    $0x4,%esp
  802aaa:	68 10 3e 80 00       	push   $0x803e10
  802aaf:	68 14 01 00 00       	push   $0x114
  802ab4:	68 33 3e 80 00       	push   $0x803e33
  802ab9:	e8 18 da ff ff       	call   8004d6 <_panic>
  802abe:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac7:	89 10                	mov    %edx,(%eax)
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	8b 00                	mov    (%eax),%eax
  802ace:	85 c0                	test   %eax,%eax
  802ad0:	74 0d                	je     802adf <insert_sorted_with_merge_freeList+0x5d>
  802ad2:	a1 38 41 80 00       	mov    0x804138,%eax
  802ad7:	8b 55 08             	mov    0x8(%ebp),%edx
  802ada:	89 50 04             	mov    %edx,0x4(%eax)
  802add:	eb 08                	jmp    802ae7 <insert_sorted_with_merge_freeList+0x65>
  802adf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	a3 38 41 80 00       	mov    %eax,0x804138
  802aef:	8b 45 08             	mov    0x8(%ebp),%eax
  802af2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af9:	a1 44 41 80 00       	mov    0x804144,%eax
  802afe:	40                   	inc    %eax
  802aff:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802b04:	e9 d2 06 00 00       	jmp    8031db <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	8b 50 08             	mov    0x8(%eax),%edx
  802b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b12:	8b 40 08             	mov    0x8(%eax),%eax
  802b15:	39 c2                	cmp    %eax,%edx
  802b17:	0f 83 22 01 00 00    	jae    802c3f <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b20:	8b 50 08             	mov    0x8(%eax),%edx
  802b23:	8b 45 08             	mov    0x8(%ebp),%eax
  802b26:	8b 40 0c             	mov    0xc(%eax),%eax
  802b29:	01 c2                	add    %eax,%edx
  802b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2e:	8b 40 08             	mov    0x8(%eax),%eax
  802b31:	39 c2                	cmp    %eax,%edx
  802b33:	0f 85 9e 00 00 00    	jne    802bd7 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	8b 50 08             	mov    0x8(%eax),%edx
  802b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b42:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b48:	8b 50 0c             	mov    0xc(%eax),%edx
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b51:	01 c2                	add    %eax,%edx
  802b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b56:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802b59:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	8b 50 08             	mov    0x8(%eax),%edx
  802b69:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6c:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802b6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b73:	75 17                	jne    802b8c <insert_sorted_with_merge_freeList+0x10a>
  802b75:	83 ec 04             	sub    $0x4,%esp
  802b78:	68 10 3e 80 00       	push   $0x803e10
  802b7d:	68 21 01 00 00       	push   $0x121
  802b82:	68 33 3e 80 00       	push   $0x803e33
  802b87:	e8 4a d9 ff ff       	call   8004d6 <_panic>
  802b8c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b92:	8b 45 08             	mov    0x8(%ebp),%eax
  802b95:	89 10                	mov    %edx,(%eax)
  802b97:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9a:	8b 00                	mov    (%eax),%eax
  802b9c:	85 c0                	test   %eax,%eax
  802b9e:	74 0d                	je     802bad <insert_sorted_with_merge_freeList+0x12b>
  802ba0:	a1 48 41 80 00       	mov    0x804148,%eax
  802ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba8:	89 50 04             	mov    %edx,0x4(%eax)
  802bab:	eb 08                	jmp    802bb5 <insert_sorted_with_merge_freeList+0x133>
  802bad:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	a3 48 41 80 00       	mov    %eax,0x804148
  802bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc7:	a1 54 41 80 00       	mov    0x804154,%eax
  802bcc:	40                   	inc    %eax
  802bcd:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802bd2:	e9 04 06 00 00       	jmp    8031db <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802bd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bdb:	75 17                	jne    802bf4 <insert_sorted_with_merge_freeList+0x172>
  802bdd:	83 ec 04             	sub    $0x4,%esp
  802be0:	68 10 3e 80 00       	push   $0x803e10
  802be5:	68 26 01 00 00       	push   $0x126
  802bea:	68 33 3e 80 00       	push   $0x803e33
  802bef:	e8 e2 d8 ff ff       	call   8004d6 <_panic>
  802bf4:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfd:	89 10                	mov    %edx,(%eax)
  802bff:	8b 45 08             	mov    0x8(%ebp),%eax
  802c02:	8b 00                	mov    (%eax),%eax
  802c04:	85 c0                	test   %eax,%eax
  802c06:	74 0d                	je     802c15 <insert_sorted_with_merge_freeList+0x193>
  802c08:	a1 38 41 80 00       	mov    0x804138,%eax
  802c0d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c10:	89 50 04             	mov    %edx,0x4(%eax)
  802c13:	eb 08                	jmp    802c1d <insert_sorted_with_merge_freeList+0x19b>
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	a3 38 41 80 00       	mov    %eax,0x804138
  802c25:	8b 45 08             	mov    0x8(%ebp),%eax
  802c28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c2f:	a1 44 41 80 00       	mov    0x804144,%eax
  802c34:	40                   	inc    %eax
  802c35:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802c3a:	e9 9c 05 00 00       	jmp    8031db <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c42:	8b 50 08             	mov    0x8(%eax),%edx
  802c45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c48:	8b 40 08             	mov    0x8(%eax),%eax
  802c4b:	39 c2                	cmp    %eax,%edx
  802c4d:	0f 86 16 01 00 00    	jbe    802d69 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802c53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c56:	8b 50 08             	mov    0x8(%eax),%edx
  802c59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5f:	01 c2                	add    %eax,%edx
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	8b 40 08             	mov    0x8(%eax),%eax
  802c67:	39 c2                	cmp    %eax,%edx
  802c69:	0f 85 92 00 00 00    	jne    802d01 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c72:	8b 50 0c             	mov    0xc(%eax),%edx
  802c75:	8b 45 08             	mov    0x8(%ebp),%eax
  802c78:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7b:	01 c2                	add    %eax,%edx
  802c7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c80:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802c83:	8b 45 08             	mov    0x8(%ebp),%eax
  802c86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	8b 50 08             	mov    0x8(%eax),%edx
  802c93:	8b 45 08             	mov    0x8(%ebp),%eax
  802c96:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802c99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c9d:	75 17                	jne    802cb6 <insert_sorted_with_merge_freeList+0x234>
  802c9f:	83 ec 04             	sub    $0x4,%esp
  802ca2:	68 10 3e 80 00       	push   $0x803e10
  802ca7:	68 31 01 00 00       	push   $0x131
  802cac:	68 33 3e 80 00       	push   $0x803e33
  802cb1:	e8 20 d8 ff ff       	call   8004d6 <_panic>
  802cb6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbf:	89 10                	mov    %edx,(%eax)
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	8b 00                	mov    (%eax),%eax
  802cc6:	85 c0                	test   %eax,%eax
  802cc8:	74 0d                	je     802cd7 <insert_sorted_with_merge_freeList+0x255>
  802cca:	a1 48 41 80 00       	mov    0x804148,%eax
  802ccf:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd2:	89 50 04             	mov    %edx,0x4(%eax)
  802cd5:	eb 08                	jmp    802cdf <insert_sorted_with_merge_freeList+0x25d>
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	a3 48 41 80 00       	mov    %eax,0x804148
  802ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf1:	a1 54 41 80 00       	mov    0x804154,%eax
  802cf6:	40                   	inc    %eax
  802cf7:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802cfc:	e9 da 04 00 00       	jmp    8031db <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802d01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d05:	75 17                	jne    802d1e <insert_sorted_with_merge_freeList+0x29c>
  802d07:	83 ec 04             	sub    $0x4,%esp
  802d0a:	68 b8 3e 80 00       	push   $0x803eb8
  802d0f:	68 37 01 00 00       	push   $0x137
  802d14:	68 33 3e 80 00       	push   $0x803e33
  802d19:	e8 b8 d7 ff ff       	call   8004d6 <_panic>
  802d1e:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802d24:	8b 45 08             	mov    0x8(%ebp),%eax
  802d27:	89 50 04             	mov    %edx,0x4(%eax)
  802d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2d:	8b 40 04             	mov    0x4(%eax),%eax
  802d30:	85 c0                	test   %eax,%eax
  802d32:	74 0c                	je     802d40 <insert_sorted_with_merge_freeList+0x2be>
  802d34:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d39:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3c:	89 10                	mov    %edx,(%eax)
  802d3e:	eb 08                	jmp    802d48 <insert_sorted_with_merge_freeList+0x2c6>
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	a3 38 41 80 00       	mov    %eax,0x804138
  802d48:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d59:	a1 44 41 80 00       	mov    0x804144,%eax
  802d5e:	40                   	inc    %eax
  802d5f:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802d64:	e9 72 04 00 00       	jmp    8031db <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802d69:	a1 38 41 80 00       	mov    0x804138,%eax
  802d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d71:	e9 35 04 00 00       	jmp    8031ab <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d79:	8b 00                	mov    (%eax),%eax
  802d7b:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	8b 50 08             	mov    0x8(%eax),%edx
  802d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d87:	8b 40 08             	mov    0x8(%eax),%eax
  802d8a:	39 c2                	cmp    %eax,%edx
  802d8c:	0f 86 11 04 00 00    	jbe    8031a3 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d95:	8b 50 08             	mov    0x8(%eax),%edx
  802d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9e:	01 c2                	add    %eax,%edx
  802da0:	8b 45 08             	mov    0x8(%ebp),%eax
  802da3:	8b 40 08             	mov    0x8(%eax),%eax
  802da6:	39 c2                	cmp    %eax,%edx
  802da8:	0f 83 8b 00 00 00    	jae    802e39 <insert_sorted_with_merge_freeList+0x3b7>
  802dae:	8b 45 08             	mov    0x8(%ebp),%eax
  802db1:	8b 50 08             	mov    0x8(%eax),%edx
  802db4:	8b 45 08             	mov    0x8(%ebp),%eax
  802db7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dba:	01 c2                	add    %eax,%edx
  802dbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dbf:	8b 40 08             	mov    0x8(%eax),%eax
  802dc2:	39 c2                	cmp    %eax,%edx
  802dc4:	73 73                	jae    802e39 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802dc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dca:	74 06                	je     802dd2 <insert_sorted_with_merge_freeList+0x350>
  802dcc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dd0:	75 17                	jne    802de9 <insert_sorted_with_merge_freeList+0x367>
  802dd2:	83 ec 04             	sub    $0x4,%esp
  802dd5:	68 84 3e 80 00       	push   $0x803e84
  802dda:	68 48 01 00 00       	push   $0x148
  802ddf:	68 33 3e 80 00       	push   $0x803e33
  802de4:	e8 ed d6 ff ff       	call   8004d6 <_panic>
  802de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dec:	8b 10                	mov    (%eax),%edx
  802dee:	8b 45 08             	mov    0x8(%ebp),%eax
  802df1:	89 10                	mov    %edx,(%eax)
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	8b 00                	mov    (%eax),%eax
  802df8:	85 c0                	test   %eax,%eax
  802dfa:	74 0b                	je     802e07 <insert_sorted_with_merge_freeList+0x385>
  802dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dff:	8b 00                	mov    (%eax),%eax
  802e01:	8b 55 08             	mov    0x8(%ebp),%edx
  802e04:	89 50 04             	mov    %edx,0x4(%eax)
  802e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0d:	89 10                	mov    %edx,(%eax)
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e15:	89 50 04             	mov    %edx,0x4(%eax)
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	8b 00                	mov    (%eax),%eax
  802e1d:	85 c0                	test   %eax,%eax
  802e1f:	75 08                	jne    802e29 <insert_sorted_with_merge_freeList+0x3a7>
  802e21:	8b 45 08             	mov    0x8(%ebp),%eax
  802e24:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e29:	a1 44 41 80 00       	mov    0x804144,%eax
  802e2e:	40                   	inc    %eax
  802e2f:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802e34:	e9 a2 03 00 00       	jmp    8031db <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802e39:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3c:	8b 50 08             	mov    0x8(%eax),%edx
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	8b 40 0c             	mov    0xc(%eax),%eax
  802e45:	01 c2                	add    %eax,%edx
  802e47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e4a:	8b 40 08             	mov    0x8(%eax),%eax
  802e4d:	39 c2                	cmp    %eax,%edx
  802e4f:	0f 83 ae 00 00 00    	jae    802f03 <insert_sorted_with_merge_freeList+0x481>
  802e55:	8b 45 08             	mov    0x8(%ebp),%eax
  802e58:	8b 50 08             	mov    0x8(%eax),%edx
  802e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5e:	8b 48 08             	mov    0x8(%eax),%ecx
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	8b 40 0c             	mov    0xc(%eax),%eax
  802e67:	01 c8                	add    %ecx,%eax
  802e69:	39 c2                	cmp    %eax,%edx
  802e6b:	0f 85 92 00 00 00    	jne    802f03 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	8b 50 0c             	mov    0xc(%eax),%edx
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7d:	01 c2                	add    %eax,%edx
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802e85:	8b 45 08             	mov    0x8(%ebp),%eax
  802e88:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	8b 50 08             	mov    0x8(%eax),%edx
  802e95:	8b 45 08             	mov    0x8(%ebp),%eax
  802e98:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802e9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e9f:	75 17                	jne    802eb8 <insert_sorted_with_merge_freeList+0x436>
  802ea1:	83 ec 04             	sub    $0x4,%esp
  802ea4:	68 10 3e 80 00       	push   $0x803e10
  802ea9:	68 51 01 00 00       	push   $0x151
  802eae:	68 33 3e 80 00       	push   $0x803e33
  802eb3:	e8 1e d6 ff ff       	call   8004d6 <_panic>
  802eb8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	89 10                	mov    %edx,(%eax)
  802ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec6:	8b 00                	mov    (%eax),%eax
  802ec8:	85 c0                	test   %eax,%eax
  802eca:	74 0d                	je     802ed9 <insert_sorted_with_merge_freeList+0x457>
  802ecc:	a1 48 41 80 00       	mov    0x804148,%eax
  802ed1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed4:	89 50 04             	mov    %edx,0x4(%eax)
  802ed7:	eb 08                	jmp    802ee1 <insert_sorted_with_merge_freeList+0x45f>
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	a3 48 41 80 00       	mov    %eax,0x804148
  802ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef3:	a1 54 41 80 00       	mov    0x804154,%eax
  802ef8:	40                   	inc    %eax
  802ef9:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802efe:	e9 d8 02 00 00       	jmp    8031db <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	8b 50 08             	mov    0x8(%eax),%edx
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0f:	01 c2                	add    %eax,%edx
  802f11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f14:	8b 40 08             	mov    0x8(%eax),%eax
  802f17:	39 c2                	cmp    %eax,%edx
  802f19:	0f 85 ba 00 00 00    	jne    802fd9 <insert_sorted_with_merge_freeList+0x557>
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	8b 50 08             	mov    0x8(%eax),%edx
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	8b 48 08             	mov    0x8(%eax),%ecx
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f31:	01 c8                	add    %ecx,%eax
  802f33:	39 c2                	cmp    %eax,%edx
  802f35:	0f 86 9e 00 00 00    	jbe    802fd9 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802f3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3e:	8b 50 0c             	mov    0xc(%eax),%edx
  802f41:	8b 45 08             	mov    0x8(%ebp),%eax
  802f44:	8b 40 0c             	mov    0xc(%eax),%eax
  802f47:	01 c2                	add    %eax,%edx
  802f49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4c:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f52:	8b 50 08             	mov    0x8(%eax),%edx
  802f55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f58:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f65:	8b 45 08             	mov    0x8(%ebp),%eax
  802f68:	8b 50 08             	mov    0x8(%eax),%edx
  802f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6e:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f75:	75 17                	jne    802f8e <insert_sorted_with_merge_freeList+0x50c>
  802f77:	83 ec 04             	sub    $0x4,%esp
  802f7a:	68 10 3e 80 00       	push   $0x803e10
  802f7f:	68 5b 01 00 00       	push   $0x15b
  802f84:	68 33 3e 80 00       	push   $0x803e33
  802f89:	e8 48 d5 ff ff       	call   8004d6 <_panic>
  802f8e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f94:	8b 45 08             	mov    0x8(%ebp),%eax
  802f97:	89 10                	mov    %edx,(%eax)
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	8b 00                	mov    (%eax),%eax
  802f9e:	85 c0                	test   %eax,%eax
  802fa0:	74 0d                	je     802faf <insert_sorted_with_merge_freeList+0x52d>
  802fa2:	a1 48 41 80 00       	mov    0x804148,%eax
  802fa7:	8b 55 08             	mov    0x8(%ebp),%edx
  802faa:	89 50 04             	mov    %edx,0x4(%eax)
  802fad:	eb 08                	jmp    802fb7 <insert_sorted_with_merge_freeList+0x535>
  802faf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	a3 48 41 80 00       	mov    %eax,0x804148
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc9:	a1 54 41 80 00       	mov    0x804154,%eax
  802fce:	40                   	inc    %eax
  802fcf:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802fd4:	e9 02 02 00 00       	jmp    8031db <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	8b 50 08             	mov    0x8(%eax),%edx
  802fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe5:	01 c2                	add    %eax,%edx
  802fe7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fea:	8b 40 08             	mov    0x8(%eax),%eax
  802fed:	39 c2                	cmp    %eax,%edx
  802fef:	0f 85 ae 01 00 00    	jne    8031a3 <insert_sorted_with_merge_freeList+0x721>
  802ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff8:	8b 50 08             	mov    0x8(%eax),%edx
  802ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffe:	8b 48 08             	mov    0x8(%eax),%ecx
  803001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803004:	8b 40 0c             	mov    0xc(%eax),%eax
  803007:	01 c8                	add    %ecx,%eax
  803009:	39 c2                	cmp    %eax,%edx
  80300b:	0f 85 92 01 00 00    	jne    8031a3 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  803011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803014:	8b 50 0c             	mov    0xc(%eax),%edx
  803017:	8b 45 08             	mov    0x8(%ebp),%eax
  80301a:	8b 40 0c             	mov    0xc(%eax),%eax
  80301d:	01 c2                	add    %eax,%edx
  80301f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803022:	8b 40 0c             	mov    0xc(%eax),%eax
  803025:	01 c2                	add    %eax,%edx
  803027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302a:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803037:	8b 45 08             	mov    0x8(%ebp),%eax
  80303a:	8b 50 08             	mov    0x8(%eax),%edx
  80303d:	8b 45 08             	mov    0x8(%ebp),%eax
  803040:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803043:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803046:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80304d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803050:	8b 50 08             	mov    0x8(%eax),%edx
  803053:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803056:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  803059:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80305d:	75 17                	jne    803076 <insert_sorted_with_merge_freeList+0x5f4>
  80305f:	83 ec 04             	sub    $0x4,%esp
  803062:	68 db 3e 80 00       	push   $0x803edb
  803067:	68 63 01 00 00       	push   $0x163
  80306c:	68 33 3e 80 00       	push   $0x803e33
  803071:	e8 60 d4 ff ff       	call   8004d6 <_panic>
  803076:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803079:	8b 00                	mov    (%eax),%eax
  80307b:	85 c0                	test   %eax,%eax
  80307d:	74 10                	je     80308f <insert_sorted_with_merge_freeList+0x60d>
  80307f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803082:	8b 00                	mov    (%eax),%eax
  803084:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803087:	8b 52 04             	mov    0x4(%edx),%edx
  80308a:	89 50 04             	mov    %edx,0x4(%eax)
  80308d:	eb 0b                	jmp    80309a <insert_sorted_with_merge_freeList+0x618>
  80308f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803092:	8b 40 04             	mov    0x4(%eax),%eax
  803095:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80309a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309d:	8b 40 04             	mov    0x4(%eax),%eax
  8030a0:	85 c0                	test   %eax,%eax
  8030a2:	74 0f                	je     8030b3 <insert_sorted_with_merge_freeList+0x631>
  8030a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a7:	8b 40 04             	mov    0x4(%eax),%eax
  8030aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ad:	8b 12                	mov    (%edx),%edx
  8030af:	89 10                	mov    %edx,(%eax)
  8030b1:	eb 0a                	jmp    8030bd <insert_sorted_with_merge_freeList+0x63b>
  8030b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b6:	8b 00                	mov    (%eax),%eax
  8030b8:	a3 38 41 80 00       	mov    %eax,0x804138
  8030bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d0:	a1 44 41 80 00       	mov    0x804144,%eax
  8030d5:	48                   	dec    %eax
  8030d6:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  8030db:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030df:	75 17                	jne    8030f8 <insert_sorted_with_merge_freeList+0x676>
  8030e1:	83 ec 04             	sub    $0x4,%esp
  8030e4:	68 10 3e 80 00       	push   $0x803e10
  8030e9:	68 64 01 00 00       	push   $0x164
  8030ee:	68 33 3e 80 00       	push   $0x803e33
  8030f3:	e8 de d3 ff ff       	call   8004d6 <_panic>
  8030f8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803101:	89 10                	mov    %edx,(%eax)
  803103:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803106:	8b 00                	mov    (%eax),%eax
  803108:	85 c0                	test   %eax,%eax
  80310a:	74 0d                	je     803119 <insert_sorted_with_merge_freeList+0x697>
  80310c:	a1 48 41 80 00       	mov    0x804148,%eax
  803111:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803114:	89 50 04             	mov    %edx,0x4(%eax)
  803117:	eb 08                	jmp    803121 <insert_sorted_with_merge_freeList+0x69f>
  803119:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803121:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803124:	a3 48 41 80 00       	mov    %eax,0x804148
  803129:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803133:	a1 54 41 80 00       	mov    0x804154,%eax
  803138:	40                   	inc    %eax
  803139:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80313e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803142:	75 17                	jne    80315b <insert_sorted_with_merge_freeList+0x6d9>
  803144:	83 ec 04             	sub    $0x4,%esp
  803147:	68 10 3e 80 00       	push   $0x803e10
  80314c:	68 65 01 00 00       	push   $0x165
  803151:	68 33 3e 80 00       	push   $0x803e33
  803156:	e8 7b d3 ff ff       	call   8004d6 <_panic>
  80315b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803161:	8b 45 08             	mov    0x8(%ebp),%eax
  803164:	89 10                	mov    %edx,(%eax)
  803166:	8b 45 08             	mov    0x8(%ebp),%eax
  803169:	8b 00                	mov    (%eax),%eax
  80316b:	85 c0                	test   %eax,%eax
  80316d:	74 0d                	je     80317c <insert_sorted_with_merge_freeList+0x6fa>
  80316f:	a1 48 41 80 00       	mov    0x804148,%eax
  803174:	8b 55 08             	mov    0x8(%ebp),%edx
  803177:	89 50 04             	mov    %edx,0x4(%eax)
  80317a:	eb 08                	jmp    803184 <insert_sorted_with_merge_freeList+0x702>
  80317c:	8b 45 08             	mov    0x8(%ebp),%eax
  80317f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803184:	8b 45 08             	mov    0x8(%ebp),%eax
  803187:	a3 48 41 80 00       	mov    %eax,0x804148
  80318c:	8b 45 08             	mov    0x8(%ebp),%eax
  80318f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803196:	a1 54 41 80 00       	mov    0x804154,%eax
  80319b:	40                   	inc    %eax
  80319c:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  8031a1:	eb 38                	jmp    8031db <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8031a3:	a1 40 41 80 00       	mov    0x804140,%eax
  8031a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031af:	74 07                	je     8031b8 <insert_sorted_with_merge_freeList+0x736>
  8031b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b4:	8b 00                	mov    (%eax),%eax
  8031b6:	eb 05                	jmp    8031bd <insert_sorted_with_merge_freeList+0x73b>
  8031b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8031bd:	a3 40 41 80 00       	mov    %eax,0x804140
  8031c2:	a1 40 41 80 00       	mov    0x804140,%eax
  8031c7:	85 c0                	test   %eax,%eax
  8031c9:	0f 85 a7 fb ff ff    	jne    802d76 <insert_sorted_with_merge_freeList+0x2f4>
  8031cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031d3:	0f 85 9d fb ff ff    	jne    802d76 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8031d9:	eb 00                	jmp    8031db <insert_sorted_with_merge_freeList+0x759>
  8031db:	90                   	nop
  8031dc:	c9                   	leave  
  8031dd:	c3                   	ret    
  8031de:	66 90                	xchg   %ax,%ax

008031e0 <__udivdi3>:
  8031e0:	55                   	push   %ebp
  8031e1:	57                   	push   %edi
  8031e2:	56                   	push   %esi
  8031e3:	53                   	push   %ebx
  8031e4:	83 ec 1c             	sub    $0x1c,%esp
  8031e7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8031eb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031f7:	89 ca                	mov    %ecx,%edx
  8031f9:	89 f8                	mov    %edi,%eax
  8031fb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031ff:	85 f6                	test   %esi,%esi
  803201:	75 2d                	jne    803230 <__udivdi3+0x50>
  803203:	39 cf                	cmp    %ecx,%edi
  803205:	77 65                	ja     80326c <__udivdi3+0x8c>
  803207:	89 fd                	mov    %edi,%ebp
  803209:	85 ff                	test   %edi,%edi
  80320b:	75 0b                	jne    803218 <__udivdi3+0x38>
  80320d:	b8 01 00 00 00       	mov    $0x1,%eax
  803212:	31 d2                	xor    %edx,%edx
  803214:	f7 f7                	div    %edi
  803216:	89 c5                	mov    %eax,%ebp
  803218:	31 d2                	xor    %edx,%edx
  80321a:	89 c8                	mov    %ecx,%eax
  80321c:	f7 f5                	div    %ebp
  80321e:	89 c1                	mov    %eax,%ecx
  803220:	89 d8                	mov    %ebx,%eax
  803222:	f7 f5                	div    %ebp
  803224:	89 cf                	mov    %ecx,%edi
  803226:	89 fa                	mov    %edi,%edx
  803228:	83 c4 1c             	add    $0x1c,%esp
  80322b:	5b                   	pop    %ebx
  80322c:	5e                   	pop    %esi
  80322d:	5f                   	pop    %edi
  80322e:	5d                   	pop    %ebp
  80322f:	c3                   	ret    
  803230:	39 ce                	cmp    %ecx,%esi
  803232:	77 28                	ja     80325c <__udivdi3+0x7c>
  803234:	0f bd fe             	bsr    %esi,%edi
  803237:	83 f7 1f             	xor    $0x1f,%edi
  80323a:	75 40                	jne    80327c <__udivdi3+0x9c>
  80323c:	39 ce                	cmp    %ecx,%esi
  80323e:	72 0a                	jb     80324a <__udivdi3+0x6a>
  803240:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803244:	0f 87 9e 00 00 00    	ja     8032e8 <__udivdi3+0x108>
  80324a:	b8 01 00 00 00       	mov    $0x1,%eax
  80324f:	89 fa                	mov    %edi,%edx
  803251:	83 c4 1c             	add    $0x1c,%esp
  803254:	5b                   	pop    %ebx
  803255:	5e                   	pop    %esi
  803256:	5f                   	pop    %edi
  803257:	5d                   	pop    %ebp
  803258:	c3                   	ret    
  803259:	8d 76 00             	lea    0x0(%esi),%esi
  80325c:	31 ff                	xor    %edi,%edi
  80325e:	31 c0                	xor    %eax,%eax
  803260:	89 fa                	mov    %edi,%edx
  803262:	83 c4 1c             	add    $0x1c,%esp
  803265:	5b                   	pop    %ebx
  803266:	5e                   	pop    %esi
  803267:	5f                   	pop    %edi
  803268:	5d                   	pop    %ebp
  803269:	c3                   	ret    
  80326a:	66 90                	xchg   %ax,%ax
  80326c:	89 d8                	mov    %ebx,%eax
  80326e:	f7 f7                	div    %edi
  803270:	31 ff                	xor    %edi,%edi
  803272:	89 fa                	mov    %edi,%edx
  803274:	83 c4 1c             	add    $0x1c,%esp
  803277:	5b                   	pop    %ebx
  803278:	5e                   	pop    %esi
  803279:	5f                   	pop    %edi
  80327a:	5d                   	pop    %ebp
  80327b:	c3                   	ret    
  80327c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803281:	89 eb                	mov    %ebp,%ebx
  803283:	29 fb                	sub    %edi,%ebx
  803285:	89 f9                	mov    %edi,%ecx
  803287:	d3 e6                	shl    %cl,%esi
  803289:	89 c5                	mov    %eax,%ebp
  80328b:	88 d9                	mov    %bl,%cl
  80328d:	d3 ed                	shr    %cl,%ebp
  80328f:	89 e9                	mov    %ebp,%ecx
  803291:	09 f1                	or     %esi,%ecx
  803293:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803297:	89 f9                	mov    %edi,%ecx
  803299:	d3 e0                	shl    %cl,%eax
  80329b:	89 c5                	mov    %eax,%ebp
  80329d:	89 d6                	mov    %edx,%esi
  80329f:	88 d9                	mov    %bl,%cl
  8032a1:	d3 ee                	shr    %cl,%esi
  8032a3:	89 f9                	mov    %edi,%ecx
  8032a5:	d3 e2                	shl    %cl,%edx
  8032a7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032ab:	88 d9                	mov    %bl,%cl
  8032ad:	d3 e8                	shr    %cl,%eax
  8032af:	09 c2                	or     %eax,%edx
  8032b1:	89 d0                	mov    %edx,%eax
  8032b3:	89 f2                	mov    %esi,%edx
  8032b5:	f7 74 24 0c          	divl   0xc(%esp)
  8032b9:	89 d6                	mov    %edx,%esi
  8032bb:	89 c3                	mov    %eax,%ebx
  8032bd:	f7 e5                	mul    %ebp
  8032bf:	39 d6                	cmp    %edx,%esi
  8032c1:	72 19                	jb     8032dc <__udivdi3+0xfc>
  8032c3:	74 0b                	je     8032d0 <__udivdi3+0xf0>
  8032c5:	89 d8                	mov    %ebx,%eax
  8032c7:	31 ff                	xor    %edi,%edi
  8032c9:	e9 58 ff ff ff       	jmp    803226 <__udivdi3+0x46>
  8032ce:	66 90                	xchg   %ax,%ax
  8032d0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8032d4:	89 f9                	mov    %edi,%ecx
  8032d6:	d3 e2                	shl    %cl,%edx
  8032d8:	39 c2                	cmp    %eax,%edx
  8032da:	73 e9                	jae    8032c5 <__udivdi3+0xe5>
  8032dc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032df:	31 ff                	xor    %edi,%edi
  8032e1:	e9 40 ff ff ff       	jmp    803226 <__udivdi3+0x46>
  8032e6:	66 90                	xchg   %ax,%ax
  8032e8:	31 c0                	xor    %eax,%eax
  8032ea:	e9 37 ff ff ff       	jmp    803226 <__udivdi3+0x46>
  8032ef:	90                   	nop

008032f0 <__umoddi3>:
  8032f0:	55                   	push   %ebp
  8032f1:	57                   	push   %edi
  8032f2:	56                   	push   %esi
  8032f3:	53                   	push   %ebx
  8032f4:	83 ec 1c             	sub    $0x1c,%esp
  8032f7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032fb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803303:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803307:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80330b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80330f:	89 f3                	mov    %esi,%ebx
  803311:	89 fa                	mov    %edi,%edx
  803313:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803317:	89 34 24             	mov    %esi,(%esp)
  80331a:	85 c0                	test   %eax,%eax
  80331c:	75 1a                	jne    803338 <__umoddi3+0x48>
  80331e:	39 f7                	cmp    %esi,%edi
  803320:	0f 86 a2 00 00 00    	jbe    8033c8 <__umoddi3+0xd8>
  803326:	89 c8                	mov    %ecx,%eax
  803328:	89 f2                	mov    %esi,%edx
  80332a:	f7 f7                	div    %edi
  80332c:	89 d0                	mov    %edx,%eax
  80332e:	31 d2                	xor    %edx,%edx
  803330:	83 c4 1c             	add    $0x1c,%esp
  803333:	5b                   	pop    %ebx
  803334:	5e                   	pop    %esi
  803335:	5f                   	pop    %edi
  803336:	5d                   	pop    %ebp
  803337:	c3                   	ret    
  803338:	39 f0                	cmp    %esi,%eax
  80333a:	0f 87 ac 00 00 00    	ja     8033ec <__umoddi3+0xfc>
  803340:	0f bd e8             	bsr    %eax,%ebp
  803343:	83 f5 1f             	xor    $0x1f,%ebp
  803346:	0f 84 ac 00 00 00    	je     8033f8 <__umoddi3+0x108>
  80334c:	bf 20 00 00 00       	mov    $0x20,%edi
  803351:	29 ef                	sub    %ebp,%edi
  803353:	89 fe                	mov    %edi,%esi
  803355:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803359:	89 e9                	mov    %ebp,%ecx
  80335b:	d3 e0                	shl    %cl,%eax
  80335d:	89 d7                	mov    %edx,%edi
  80335f:	89 f1                	mov    %esi,%ecx
  803361:	d3 ef                	shr    %cl,%edi
  803363:	09 c7                	or     %eax,%edi
  803365:	89 e9                	mov    %ebp,%ecx
  803367:	d3 e2                	shl    %cl,%edx
  803369:	89 14 24             	mov    %edx,(%esp)
  80336c:	89 d8                	mov    %ebx,%eax
  80336e:	d3 e0                	shl    %cl,%eax
  803370:	89 c2                	mov    %eax,%edx
  803372:	8b 44 24 08          	mov    0x8(%esp),%eax
  803376:	d3 e0                	shl    %cl,%eax
  803378:	89 44 24 04          	mov    %eax,0x4(%esp)
  80337c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803380:	89 f1                	mov    %esi,%ecx
  803382:	d3 e8                	shr    %cl,%eax
  803384:	09 d0                	or     %edx,%eax
  803386:	d3 eb                	shr    %cl,%ebx
  803388:	89 da                	mov    %ebx,%edx
  80338a:	f7 f7                	div    %edi
  80338c:	89 d3                	mov    %edx,%ebx
  80338e:	f7 24 24             	mull   (%esp)
  803391:	89 c6                	mov    %eax,%esi
  803393:	89 d1                	mov    %edx,%ecx
  803395:	39 d3                	cmp    %edx,%ebx
  803397:	0f 82 87 00 00 00    	jb     803424 <__umoddi3+0x134>
  80339d:	0f 84 91 00 00 00    	je     803434 <__umoddi3+0x144>
  8033a3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8033a7:	29 f2                	sub    %esi,%edx
  8033a9:	19 cb                	sbb    %ecx,%ebx
  8033ab:	89 d8                	mov    %ebx,%eax
  8033ad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8033b1:	d3 e0                	shl    %cl,%eax
  8033b3:	89 e9                	mov    %ebp,%ecx
  8033b5:	d3 ea                	shr    %cl,%edx
  8033b7:	09 d0                	or     %edx,%eax
  8033b9:	89 e9                	mov    %ebp,%ecx
  8033bb:	d3 eb                	shr    %cl,%ebx
  8033bd:	89 da                	mov    %ebx,%edx
  8033bf:	83 c4 1c             	add    $0x1c,%esp
  8033c2:	5b                   	pop    %ebx
  8033c3:	5e                   	pop    %esi
  8033c4:	5f                   	pop    %edi
  8033c5:	5d                   	pop    %ebp
  8033c6:	c3                   	ret    
  8033c7:	90                   	nop
  8033c8:	89 fd                	mov    %edi,%ebp
  8033ca:	85 ff                	test   %edi,%edi
  8033cc:	75 0b                	jne    8033d9 <__umoddi3+0xe9>
  8033ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8033d3:	31 d2                	xor    %edx,%edx
  8033d5:	f7 f7                	div    %edi
  8033d7:	89 c5                	mov    %eax,%ebp
  8033d9:	89 f0                	mov    %esi,%eax
  8033db:	31 d2                	xor    %edx,%edx
  8033dd:	f7 f5                	div    %ebp
  8033df:	89 c8                	mov    %ecx,%eax
  8033e1:	f7 f5                	div    %ebp
  8033e3:	89 d0                	mov    %edx,%eax
  8033e5:	e9 44 ff ff ff       	jmp    80332e <__umoddi3+0x3e>
  8033ea:	66 90                	xchg   %ax,%ax
  8033ec:	89 c8                	mov    %ecx,%eax
  8033ee:	89 f2                	mov    %esi,%edx
  8033f0:	83 c4 1c             	add    $0x1c,%esp
  8033f3:	5b                   	pop    %ebx
  8033f4:	5e                   	pop    %esi
  8033f5:	5f                   	pop    %edi
  8033f6:	5d                   	pop    %ebp
  8033f7:	c3                   	ret    
  8033f8:	3b 04 24             	cmp    (%esp),%eax
  8033fb:	72 06                	jb     803403 <__umoddi3+0x113>
  8033fd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803401:	77 0f                	ja     803412 <__umoddi3+0x122>
  803403:	89 f2                	mov    %esi,%edx
  803405:	29 f9                	sub    %edi,%ecx
  803407:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80340b:	89 14 24             	mov    %edx,(%esp)
  80340e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803412:	8b 44 24 04          	mov    0x4(%esp),%eax
  803416:	8b 14 24             	mov    (%esp),%edx
  803419:	83 c4 1c             	add    $0x1c,%esp
  80341c:	5b                   	pop    %ebx
  80341d:	5e                   	pop    %esi
  80341e:	5f                   	pop    %edi
  80341f:	5d                   	pop    %ebp
  803420:	c3                   	ret    
  803421:	8d 76 00             	lea    0x0(%esi),%esi
  803424:	2b 04 24             	sub    (%esp),%eax
  803427:	19 fa                	sbb    %edi,%edx
  803429:	89 d1                	mov    %edx,%ecx
  80342b:	89 c6                	mov    %eax,%esi
  80342d:	e9 71 ff ff ff       	jmp    8033a3 <__umoddi3+0xb3>
  803432:	66 90                	xchg   %ax,%ax
  803434:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803438:	72 ea                	jb     803424 <__umoddi3+0x134>
  80343a:	89 d9                	mov    %ebx,%ecx
  80343c:	e9 62 ff ff ff       	jmp    8033a3 <__umoddi3+0xb3>
