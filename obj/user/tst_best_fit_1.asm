
obj/user/tst_best_fit_1:     file format elf32-i386


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
  800031:	e8 d2 0a 00 00       	call   800b08 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 1000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 1d 27 00 00       	call   802767 <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 29                	jmp    800083 <_main+0x4b>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 50 80 00       	mov    0x805020,%eax
  80005f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	89 d0                	mov    %edx,%eax
  80006a:	01 c0                	add    %eax,%eax
  80006c:	01 d0                	add    %edx,%eax
  80006e:	c1 e0 03             	shl    $0x3,%eax
  800071:	01 c8                	add    %ecx,%eax
  800073:	8a 40 04             	mov    0x4(%eax),%al
  800076:	84 c0                	test   %al,%al
  800078:	74 06                	je     800080 <_main+0x48>
			{
				fullWS = 0;
  80007a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007e:	eb 12                	jmp    800092 <_main+0x5a>
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800080:	ff 45 f0             	incl   -0x10(%ebp)
  800083:	a1 20 50 80 00       	mov    0x805020,%eax
  800088:	8b 50 74             	mov    0x74(%eax),%edx
  80008b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008e:	39 c2                	cmp    %eax,%edx
  800090:	77 c8                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800092:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800096:	74 14                	je     8000ac <_main+0x74>
  800098:	83 ec 04             	sub    $0x4,%esp
  80009b:	68 c0 3b 80 00       	push   $0x803bc0
  8000a0:	6a 15                	push   $0x15
  8000a2:	68 dc 3b 80 00       	push   $0x803bdc
  8000a7:	e8 98 0b 00 00       	call   800c44 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 6e 1d 00 00       	call   801e24 <malloc>
  8000b6:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000b9:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c0:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  8000c7:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000ca:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 75 21 00 00       	call   802252 <sys_calculate_free_frames>
  8000dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e0:	e8 0d 22 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(3*Mega-kilo);
  8000e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000eb:	89 c2                	mov    %eax,%edx
  8000ed:	01 d2                	add    %edx,%edx
  8000ef:	01 d0                	add    %edx,%eax
  8000f1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 27 1d 00 00       	call   801e24 <malloc>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800103:	8b 45 90             	mov    -0x70(%ebp),%eax
  800106:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80010b:	74 14                	je     800121 <_main+0xe9>
  80010d:	83 ec 04             	sub    $0x4,%esp
  800110:	68 f4 3b 80 00       	push   $0x803bf4
  800115:	6a 26                	push   $0x26
  800117:	68 dc 3b 80 00       	push   $0x803bdc
  80011c:	e8 23 0b 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  800121:	e8 cc 21 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  800126:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800129:	3d 00 03 00 00       	cmp    $0x300,%eax
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 24 3c 80 00       	push   $0x803c24
  800138:	6a 28                	push   $0x28
  80013a:	68 dc 3b 80 00       	push   $0x803bdc
  80013f:	e8 00 0b 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800144:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800147:	e8 06 21 00 00       	call   802252 <sys_calculate_free_frames>
  80014c:	29 c3                	sub    %eax,%ebx
  80014e:	89 d8                	mov    %ebx,%eax
  800150:	83 f8 01             	cmp    $0x1,%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 41 3c 80 00       	push   $0x803c41
  80015d:	6a 29                	push   $0x29
  80015f:	68 dc 3b 80 00       	push   $0x803bdc
  800164:	e8 db 0a 00 00       	call   800c44 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 e4 20 00 00       	call   802252 <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 7c 21 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  800176:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017c:	89 c2                	mov    %eax,%edx
  80017e:	01 d2                	add    %edx,%edx
  800180:	01 d0                	add    %edx,%eax
  800182:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	50                   	push   %eax
  800189:	e8 96 1c 00 00       	call   801e24 <malloc>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  800194:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800197:	89 c1                	mov    %eax,%ecx
  800199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019c:	89 c2                	mov    %eax,%edx
  80019e:	01 d2                	add    %edx,%edx
  8001a0:	01 d0                	add    %edx,%eax
  8001a2:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a7:	39 c1                	cmp    %eax,%ecx
  8001a9:	74 14                	je     8001bf <_main+0x187>
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	68 f4 3b 80 00       	push   $0x803bf4
  8001b3:	6a 2f                	push   $0x2f
  8001b5:	68 dc 3b 80 00       	push   $0x803bdc
  8001ba:	e8 85 0a 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  8001bf:	e8 2e 21 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  8001c4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c7:	3d 00 03 00 00       	cmp    $0x300,%eax
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 24 3c 80 00       	push   $0x803c24
  8001d6:	6a 31                	push   $0x31
  8001d8:	68 dc 3b 80 00       	push   $0x803bdc
  8001dd:	e8 62 0a 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  8001e2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001e5:	e8 68 20 00 00       	call   802252 <sys_calculate_free_frames>
  8001ea:	29 c3                	sub    %eax,%ebx
  8001ec:	89 d8                	mov    %ebx,%eax
  8001ee:	83 f8 01             	cmp    $0x1,%eax
  8001f1:	74 14                	je     800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 41 3c 80 00       	push   $0x803c41
  8001fb:	6a 32                	push   $0x32
  8001fd:	68 dc 3b 80 00       	push   $0x803bdc
  800202:	e8 3d 0a 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800207:	e8 46 20 00 00       	call   802252 <sys_calculate_free_frames>
  80020c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020f:	e8 de 20 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  800214:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*Mega-kilo);
  800217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80021a:	01 c0                	add    %eax,%eax
  80021c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	50                   	push   %eax
  800223:	e8 fc 1b 00 00       	call   801e24 <malloc>
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80022e:	8b 45 98             	mov    -0x68(%ebp),%eax
  800231:	89 c1                	mov    %eax,%ecx
  800233:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800236:	89 d0                	mov    %edx,%eax
  800238:	01 c0                	add    %eax,%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	01 c0                	add    %eax,%eax
  80023e:	05 00 00 00 80       	add    $0x80000000,%eax
  800243:	39 c1                	cmp    %eax,%ecx
  800245:	74 14                	je     80025b <_main+0x223>
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	68 f4 3b 80 00       	push   $0x803bf4
  80024f:	6a 38                	push   $0x38
  800251:	68 dc 3b 80 00       	push   $0x803bdc
  800256:	e8 e9 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  80025b:	e8 92 20 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  800260:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800263:	3d 00 02 00 00       	cmp    $0x200,%eax
  800268:	74 14                	je     80027e <_main+0x246>
  80026a:	83 ec 04             	sub    $0x4,%esp
  80026d:	68 24 3c 80 00       	push   $0x803c24
  800272:	6a 3a                	push   $0x3a
  800274:	68 dc 3b 80 00       	push   $0x803bdc
  800279:	e8 c6 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80027e:	e8 cf 1f 00 00       	call   802252 <sys_calculate_free_frames>
  800283:	89 c2                	mov    %eax,%edx
  800285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800288:	39 c2                	cmp    %eax,%edx
  80028a:	74 14                	je     8002a0 <_main+0x268>
  80028c:	83 ec 04             	sub    $0x4,%esp
  80028f:	68 41 3c 80 00       	push   $0x803c41
  800294:	6a 3b                	push   $0x3b
  800296:	68 dc 3b 80 00       	push   $0x803bdc
  80029b:	e8 a4 09 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002a0:	e8 ad 1f 00 00       	call   802252 <sys_calculate_free_frames>
  8002a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002a8:	e8 45 20 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  8002ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*Mega-kilo);
  8002b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b3:	01 c0                	add    %eax,%eax
  8002b5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	50                   	push   %eax
  8002bc:	e8 63 1b 00 00       	call   801e24 <malloc>
  8002c1:	83 c4 10             	add    $0x10,%esp
  8002c4:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8002c7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002ca:	89 c2                	mov    %eax,%edx
  8002cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cf:	c1 e0 03             	shl    $0x3,%eax
  8002d2:	05 00 00 00 80       	add    $0x80000000,%eax
  8002d7:	39 c2                	cmp    %eax,%edx
  8002d9:	74 14                	je     8002ef <_main+0x2b7>
  8002db:	83 ec 04             	sub    $0x4,%esp
  8002de:	68 f4 3b 80 00       	push   $0x803bf4
  8002e3:	6a 41                	push   $0x41
  8002e5:	68 dc 3b 80 00       	push   $0x803bdc
  8002ea:	e8 55 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  8002ef:	e8 fe 1f 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  8002f4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002f7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 24 3c 80 00       	push   $0x803c24
  800306:	6a 43                	push   $0x43
  800308:	68 dc 3b 80 00       	push   $0x803bdc
  80030d:	e8 32 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800312:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800315:	e8 38 1f 00 00       	call   802252 <sys_calculate_free_frames>
  80031a:	29 c3                	sub    %eax,%ebx
  80031c:	89 d8                	mov    %ebx,%eax
  80031e:	83 f8 01             	cmp    $0x1,%eax
  800321:	74 14                	je     800337 <_main+0x2ff>
  800323:	83 ec 04             	sub    $0x4,%esp
  800326:	68 41 3c 80 00       	push   $0x803c41
  80032b:	6a 44                	push   $0x44
  80032d:	68 dc 3b 80 00       	push   $0x803bdc
  800332:	e8 0d 09 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800337:	e8 16 1f 00 00       	call   802252 <sys_calculate_free_frames>
  80033c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80033f:	e8 ae 1f 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  800344:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(1*Mega-kilo);
  800347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80034a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80034d:	83 ec 0c             	sub    $0xc,%esp
  800350:	50                   	push   %eax
  800351:	e8 ce 1a 00 00       	call   801e24 <malloc>
  800356:	83 c4 10             	add    $0x10,%esp
  800359:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 10*Mega) ) panic("Wrong start address for the allocated space... ");
  80035c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80035f:	89 c1                	mov    %eax,%ecx
  800361:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800364:	89 d0                	mov    %edx,%eax
  800366:	c1 e0 02             	shl    $0x2,%eax
  800369:	01 d0                	add    %edx,%eax
  80036b:	01 c0                	add    %eax,%eax
  80036d:	05 00 00 00 80       	add    $0x80000000,%eax
  800372:	39 c1                	cmp    %eax,%ecx
  800374:	74 14                	je     80038a <_main+0x352>
  800376:	83 ec 04             	sub    $0x4,%esp
  800379:	68 f4 3b 80 00       	push   $0x803bf4
  80037e:	6a 4a                	push   $0x4a
  800380:	68 dc 3b 80 00       	push   $0x803bdc
  800385:	e8 ba 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80038a:	e8 63 1f 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  80038f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800392:	3d 00 01 00 00       	cmp    $0x100,%eax
  800397:	74 14                	je     8003ad <_main+0x375>
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	68 24 3c 80 00       	push   $0x803c24
  8003a1:	6a 4c                	push   $0x4c
  8003a3:	68 dc 3b 80 00       	push   $0x803bdc
  8003a8:	e8 97 08 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8003ad:	e8 a0 1e 00 00       	call   802252 <sys_calculate_free_frames>
  8003b2:	89 c2                	mov    %eax,%edx
  8003b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	74 14                	je     8003cf <_main+0x397>
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 41 3c 80 00       	push   $0x803c41
  8003c3:	6a 4d                	push   $0x4d
  8003c5:	68 dc 3b 80 00       	push   $0x803bdc
  8003ca:	e8 75 08 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cf:	e8 7e 1e 00 00       	call   802252 <sys_calculate_free_frames>
  8003d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d7:	e8 16 1f 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  8003dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(1*Mega-kilo);
  8003df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003e5:	83 ec 0c             	sub    $0xc,%esp
  8003e8:	50                   	push   %eax
  8003e9:	e8 36 1a 00 00       	call   801e24 <malloc>
  8003ee:	83 c4 10             	add    $0x10,%esp
  8003f1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 11*Mega) ) panic("Wrong start address for the allocated space... ");
  8003f4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003f7:	89 c1                	mov    %eax,%ecx
  8003f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003fc:	89 d0                	mov    %edx,%eax
  8003fe:	c1 e0 02             	shl    $0x2,%eax
  800401:	01 d0                	add    %edx,%eax
  800403:	01 c0                	add    %eax,%eax
  800405:	01 d0                	add    %edx,%eax
  800407:	05 00 00 00 80       	add    $0x80000000,%eax
  80040c:	39 c1                	cmp    %eax,%ecx
  80040e:	74 14                	je     800424 <_main+0x3ec>
  800410:	83 ec 04             	sub    $0x4,%esp
  800413:	68 f4 3b 80 00       	push   $0x803bf4
  800418:	6a 53                	push   $0x53
  80041a:	68 dc 3b 80 00       	push   $0x803bdc
  80041f:	e8 20 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800424:	e8 c9 1e 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  800429:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80042c:	3d 00 01 00 00       	cmp    $0x100,%eax
  800431:	74 14                	je     800447 <_main+0x40f>
  800433:	83 ec 04             	sub    $0x4,%esp
  800436:	68 24 3c 80 00       	push   $0x803c24
  80043b:	6a 55                	push   $0x55
  80043d:	68 dc 3b 80 00       	push   $0x803bdc
  800442:	e8 fd 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800447:	e8 06 1e 00 00       	call   802252 <sys_calculate_free_frames>
  80044c:	89 c2                	mov    %eax,%edx
  80044e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800451:	39 c2                	cmp    %eax,%edx
  800453:	74 14                	je     800469 <_main+0x431>
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	68 41 3c 80 00       	push   $0x803c41
  80045d:	6a 56                	push   $0x56
  80045f:	68 dc 3b 80 00       	push   $0x803bdc
  800464:	e8 db 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800469:	e8 e4 1d 00 00       	call   802252 <sys_calculate_free_frames>
  80046e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800471:	e8 7c 1e 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  800476:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(1*Mega-kilo);
  800479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80047f:	83 ec 0c             	sub    $0xc,%esp
  800482:	50                   	push   %eax
  800483:	e8 9c 19 00 00       	call   801e24 <malloc>
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 12*Mega) ) panic("Wrong start address for the allocated space... ");
  80048e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800491:	89 c1                	mov    %eax,%ecx
  800493:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800496:	89 d0                	mov    %edx,%eax
  800498:	01 c0                	add    %eax,%eax
  80049a:	01 d0                	add    %edx,%eax
  80049c:	c1 e0 02             	shl    $0x2,%eax
  80049f:	05 00 00 00 80       	add    $0x80000000,%eax
  8004a4:	39 c1                	cmp    %eax,%ecx
  8004a6:	74 14                	je     8004bc <_main+0x484>
  8004a8:	83 ec 04             	sub    $0x4,%esp
  8004ab:	68 f4 3b 80 00       	push   $0x803bf4
  8004b0:	6a 5c                	push   $0x5c
  8004b2:	68 dc 3b 80 00       	push   $0x803bdc
  8004b7:	e8 88 07 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8004bc:	e8 31 1e 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  8004c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004c4:	3d 00 01 00 00       	cmp    $0x100,%eax
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 24 3c 80 00       	push   $0x803c24
  8004d3:	6a 5e                	push   $0x5e
  8004d5:	68 dc 3b 80 00       	push   $0x803bdc
  8004da:	e8 65 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8004df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004e2:	e8 6b 1d 00 00       	call   802252 <sys_calculate_free_frames>
  8004e7:	29 c3                	sub    %eax,%ebx
  8004e9:	89 d8                	mov    %ebx,%eax
  8004eb:	83 f8 01             	cmp    $0x1,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 41 3c 80 00       	push   $0x803c41
  8004f8:	6a 5f                	push   $0x5f
  8004fa:	68 dc 3b 80 00       	push   $0x803bdc
  8004ff:	e8 40 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800504:	e8 49 1d 00 00       	call   802252 <sys_calculate_free_frames>
  800509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80050c:	e8 e1 1d 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  800511:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(1*Mega-kilo);
  800514:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800517:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	50                   	push   %eax
  80051e:	e8 01 19 00 00       	call   801e24 <malloc>
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 13*Mega)) panic("Wrong start address for the allocated space... ");
  800529:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80052c:	89 c1                	mov    %eax,%ecx
  80052e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800531:	89 d0                	mov    %edx,%eax
  800533:	01 c0                	add    %eax,%eax
  800535:	01 d0                	add    %edx,%eax
  800537:	c1 e0 02             	shl    $0x2,%eax
  80053a:	01 d0                	add    %edx,%eax
  80053c:	05 00 00 00 80       	add    $0x80000000,%eax
  800541:	39 c1                	cmp    %eax,%ecx
  800543:	74 14                	je     800559 <_main+0x521>
  800545:	83 ec 04             	sub    $0x4,%esp
  800548:	68 f4 3b 80 00       	push   $0x803bf4
  80054d:	6a 65                	push   $0x65
  80054f:	68 dc 3b 80 00       	push   $0x803bdc
  800554:	e8 eb 06 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800559:	e8 94 1d 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  80055e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800561:	3d 00 01 00 00       	cmp    $0x100,%eax
  800566:	74 14                	je     80057c <_main+0x544>
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	68 24 3c 80 00       	push   $0x803c24
  800570:	6a 67                	push   $0x67
  800572:	68 dc 3b 80 00       	push   $0x803bdc
  800577:	e8 c8 06 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80057c:	e8 d1 1c 00 00       	call   802252 <sys_calculate_free_frames>
  800581:	89 c2                	mov    %eax,%edx
  800583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800586:	39 c2                	cmp    %eax,%edx
  800588:	74 14                	je     80059e <_main+0x566>
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	68 41 3c 80 00       	push   $0x803c41
  800592:	6a 68                	push   $0x68
  800594:	68 dc 3b 80 00       	push   $0x803bdc
  800599:	e8 a6 06 00 00       	call   800c44 <_panic>
	}

	//[2] Free some to create holes
	{
		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80059e:	e8 af 1c 00 00       	call   802252 <sys_calculate_free_frames>
  8005a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005a6:	e8 47 1d 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  8005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005ae:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005b1:	83 ec 0c             	sub    $0xc,%esp
  8005b4:	50                   	push   %eax
  8005b5:	e8 e5 18 00 00       	call   801e9f <free>
  8005ba:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  3*256) panic("Wrong page file free: ");
  8005bd:	e8 30 1d 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  8005c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c5:	29 c2                	sub    %eax,%edx
  8005c7:	89 d0                	mov    %edx,%eax
  8005c9:	3d 00 03 00 00       	cmp    $0x300,%eax
  8005ce:	74 14                	je     8005e4 <_main+0x5ac>
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	68 54 3c 80 00       	push   $0x803c54
  8005d8:	6a 72                	push   $0x72
  8005da:	68 dc 3b 80 00       	push   $0x803bdc
  8005df:	e8 60 06 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005e4:	e8 69 1c 00 00       	call   802252 <sys_calculate_free_frames>
  8005e9:	89 c2                	mov    %eax,%edx
  8005eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005ee:	39 c2                	cmp    %eax,%edx
  8005f0:	74 14                	je     800606 <_main+0x5ce>
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 6b 3c 80 00       	push   $0x803c6b
  8005fa:	6a 73                	push   $0x73
  8005fc:	68 dc 3b 80 00       	push   $0x803bdc
  800601:	e8 3e 06 00 00       	call   800c44 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800606:	e8 47 1c 00 00       	call   802252 <sys_calculate_free_frames>
  80060b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80060e:	e8 df 1c 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  800613:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800616:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	50                   	push   %eax
  80061d:	e8 7d 18 00 00       	call   801e9f <free>
  800622:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  2*256) panic("Wrong page file free: ");
  800625:	e8 c8 1c 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  80062a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062d:	29 c2                	sub    %eax,%edx
  80062f:	89 d0                	mov    %edx,%eax
  800631:	3d 00 02 00 00       	cmp    $0x200,%eax
  800636:	74 14                	je     80064c <_main+0x614>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 54 3c 80 00       	push   $0x803c54
  800640:	6a 7a                	push   $0x7a
  800642:	68 dc 3b 80 00       	push   $0x803bdc
  800647:	e8 f8 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064c:	e8 01 1c 00 00       	call   802252 <sys_calculate_free_frames>
  800651:	89 c2                	mov    %eax,%edx
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	39 c2                	cmp    %eax,%edx
  800658:	74 14                	je     80066e <_main+0x636>
  80065a:	83 ec 04             	sub    $0x4,%esp
  80065d:	68 6b 3c 80 00       	push   $0x803c6b
  800662:	6a 7b                	push   $0x7b
  800664:	68 dc 3b 80 00       	push   $0x803bdc
  800669:	e8 d6 05 00 00       	call   800c44 <_panic>

		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80066e:	e8 df 1b 00 00       	call   802252 <sys_calculate_free_frames>
  800673:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800676:	e8 77 1c 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  80067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80067e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800681:	83 ec 0c             	sub    $0xc,%esp
  800684:	50                   	push   %eax
  800685:	e8 15 18 00 00       	call   801e9f <free>
  80068a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  80068d:	e8 60 1c 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  800692:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800695:	29 c2                	sub    %eax,%edx
  800697:	89 d0                	mov    %edx,%eax
  800699:	3d 00 01 00 00       	cmp    $0x100,%eax
  80069e:	74 17                	je     8006b7 <_main+0x67f>
  8006a0:	83 ec 04             	sub    $0x4,%esp
  8006a3:	68 54 3c 80 00       	push   $0x803c54
  8006a8:	68 82 00 00 00       	push   $0x82
  8006ad:	68 dc 3b 80 00       	push   $0x803bdc
  8006b2:	e8 8d 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8006b7:	e8 96 1b 00 00       	call   802252 <sys_calculate_free_frames>
  8006bc:	89 c2                	mov    %eax,%edx
  8006be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c1:	39 c2                	cmp    %eax,%edx
  8006c3:	74 17                	je     8006dc <_main+0x6a4>
  8006c5:	83 ec 04             	sub    $0x4,%esp
  8006c8:	68 6b 3c 80 00       	push   $0x803c6b
  8006cd:	68 83 00 00 00       	push   $0x83
  8006d2:	68 dc 3b 80 00       	push   $0x803bdc
  8006d7:	e8 68 05 00 00       	call   800c44 <_panic>
	}

	//[3] Allocate again [test best fit]
	{
		//Allocate 512 KB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  8006dc:	e8 71 1b 00 00       	call   802252 <sys_calculate_free_frames>
  8006e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006e4:	e8 09 1c 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  8006e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo);
  8006ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006ef:	c1 e0 09             	shl    $0x9,%eax
  8006f2:	83 ec 0c             	sub    $0xc,%esp
  8006f5:	50                   	push   %eax
  8006f6:	e8 29 17 00 00       	call   801e24 <malloc>
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  800701:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800704:	89 c1                	mov    %eax,%ecx
  800706:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800709:	89 d0                	mov    %edx,%eax
  80070b:	c1 e0 02             	shl    $0x2,%eax
  80070e:	01 d0                	add    %edx,%eax
  800710:	01 c0                	add    %eax,%eax
  800712:	01 d0                	add    %edx,%eax
  800714:	05 00 00 00 80       	add    $0x80000000,%eax
  800719:	39 c1                	cmp    %eax,%ecx
  80071b:	74 17                	je     800734 <_main+0x6fc>
  80071d:	83 ec 04             	sub    $0x4,%esp
  800720:	68 f4 3b 80 00       	push   $0x803bf4
  800725:	68 8c 00 00 00       	push   $0x8c
  80072a:	68 dc 3b 80 00       	push   $0x803bdc
  80072f:	e8 10 05 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  800734:	e8 b9 1b 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  800739:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80073c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800741:	74 17                	je     80075a <_main+0x722>
  800743:	83 ec 04             	sub    $0x4,%esp
  800746:	68 24 3c 80 00       	push   $0x803c24
  80074b:	68 8e 00 00 00       	push   $0x8e
  800750:	68 dc 3b 80 00       	push   $0x803bdc
  800755:	e8 ea 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80075a:	e8 f3 1a 00 00       	call   802252 <sys_calculate_free_frames>
  80075f:	89 c2                	mov    %eax,%edx
  800761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800764:	39 c2                	cmp    %eax,%edx
  800766:	74 17                	je     80077f <_main+0x747>
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 41 3c 80 00       	push   $0x803c41
  800770:	68 8f 00 00 00       	push   $0x8f
  800775:	68 dc 3b 80 00       	push   $0x803bdc
  80077a:	e8 c5 04 00 00       	call   800c44 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80077f:	e8 ce 1a 00 00       	call   802252 <sys_calculate_free_frames>
  800784:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800787:	e8 66 1b 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  80078c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80078f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800792:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	50                   	push   %eax
  800799:	e8 86 16 00 00       	call   801e24 <malloc>
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8007a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8007a7:	89 c2                	mov    %eax,%edx
  8007a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ac:	c1 e0 03             	shl    $0x3,%eax
  8007af:	05 00 00 00 80       	add    $0x80000000,%eax
  8007b4:	39 c2                	cmp    %eax,%edx
  8007b6:	74 17                	je     8007cf <_main+0x797>
  8007b8:	83 ec 04             	sub    $0x4,%esp
  8007bb:	68 f4 3b 80 00       	push   $0x803bf4
  8007c0:	68 95 00 00 00       	push   $0x95
  8007c5:	68 dc 3b 80 00       	push   $0x803bdc
  8007ca:	e8 75 04 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8007cf:	e8 1e 1b 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  8007d4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007d7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007dc:	74 17                	je     8007f5 <_main+0x7bd>
  8007de:	83 ec 04             	sub    $0x4,%esp
  8007e1:	68 24 3c 80 00       	push   $0x803c24
  8007e6:	68 97 00 00 00       	push   $0x97
  8007eb:	68 dc 3b 80 00       	push   $0x803bdc
  8007f0:	e8 4f 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007f5:	e8 58 1a 00 00       	call   802252 <sys_calculate_free_frames>
  8007fa:	89 c2                	mov    %eax,%edx
  8007fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007ff:	39 c2                	cmp    %eax,%edx
  800801:	74 17                	je     80081a <_main+0x7e2>
  800803:	83 ec 04             	sub    $0x4,%esp
  800806:	68 41 3c 80 00       	push   $0x803c41
  80080b:	68 98 00 00 00       	push   $0x98
  800810:	68 dc 3b 80 00       	push   $0x803bdc
  800815:	e8 2a 04 00 00       	call   800c44 <_panic>

		//Allocate 256 KB - should be placed in remaining of 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  80081a:	e8 33 1a 00 00       	call   802252 <sys_calculate_free_frames>
  80081f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800822:	e8 cb 1a 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  800827:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  80082a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082d:	89 d0                	mov    %edx,%eax
  80082f:	c1 e0 08             	shl    $0x8,%eax
  800832:	29 d0                	sub    %edx,%eax
  800834:	83 ec 0c             	sub    $0xc,%esp
  800837:	50                   	push   %eax
  800838:	e8 e7 15 00 00       	call   801e24 <malloc>
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 11*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  800843:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800846:	89 c1                	mov    %eax,%ecx
  800848:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80084b:	89 d0                	mov    %edx,%eax
  80084d:	c1 e0 02             	shl    $0x2,%eax
  800850:	01 d0                	add    %edx,%eax
  800852:	01 c0                	add    %eax,%eax
  800854:	01 d0                	add    %edx,%eax
  800856:	89 c2                	mov    %eax,%edx
  800858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80085b:	c1 e0 09             	shl    $0x9,%eax
  80085e:	01 d0                	add    %edx,%eax
  800860:	05 00 00 00 80       	add    $0x80000000,%eax
  800865:	39 c1                	cmp    %eax,%ecx
  800867:	74 17                	je     800880 <_main+0x848>
  800869:	83 ec 04             	sub    $0x4,%esp
  80086c:	68 f4 3b 80 00       	push   $0x803bf4
  800871:	68 9e 00 00 00       	push   $0x9e
  800876:	68 dc 3b 80 00       	push   $0x803bdc
  80087b:	e8 c4 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  800880:	e8 6d 1a 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  800885:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800888:	83 f8 40             	cmp    $0x40,%eax
  80088b:	74 17                	je     8008a4 <_main+0x86c>
  80088d:	83 ec 04             	sub    $0x4,%esp
  800890:	68 24 3c 80 00       	push   $0x803c24
  800895:	68 a0 00 00 00       	push   $0xa0
  80089a:	68 dc 3b 80 00       	push   $0x803bdc
  80089f:	e8 a0 03 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008a4:	e8 a9 19 00 00       	call   802252 <sys_calculate_free_frames>
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008ae:	39 c2                	cmp    %eax,%edx
  8008b0:	74 17                	je     8008c9 <_main+0x891>
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 41 3c 80 00       	push   $0x803c41
  8008ba:	68 a1 00 00 00       	push   $0xa1
  8008bf:	68 dc 3b 80 00       	push   $0x803bdc
  8008c4:	e8 7b 03 00 00       	call   800c44 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 84 19 00 00       	call   802252 <sys_calculate_free_frames>
  8008ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008d1:	e8 1c 1a 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  8008d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega - kilo);
  8008d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008dc:	c1 e0 02             	shl    $0x2,%eax
  8008df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8008e2:	83 ec 0c             	sub    $0xc,%esp
  8008e5:	50                   	push   %eax
  8008e6:	e8 39 15 00 00       	call   801e24 <malloc>
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  8008f1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8008f4:	89 c1                	mov    %eax,%ecx
  8008f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8008f9:	89 d0                	mov    %edx,%eax
  8008fb:	01 c0                	add    %eax,%eax
  8008fd:	01 d0                	add    %edx,%eax
  8008ff:	01 c0                	add    %eax,%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	01 c0                	add    %eax,%eax
  800905:	05 00 00 00 80       	add    $0x80000000,%eax
  80090a:	39 c1                	cmp    %eax,%ecx
  80090c:	74 17                	je     800925 <_main+0x8ed>
  80090e:	83 ec 04             	sub    $0x4,%esp
  800911:	68 f4 3b 80 00       	push   $0x803bf4
  800916:	68 a7 00 00 00       	push   $0xa7
  80091b:	68 dc 3b 80 00       	push   $0x803bdc
  800920:	e8 1f 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  800925:	e8 c8 19 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  80092a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80092d:	3d 00 04 00 00       	cmp    $0x400,%eax
  800932:	74 17                	je     80094b <_main+0x913>
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	68 24 3c 80 00       	push   $0x803c24
  80093c:	68 a9 00 00 00       	push   $0xa9
  800941:	68 dc 3b 80 00       	push   $0x803bdc
  800946:	e8 f9 02 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  80094b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80094e:	e8 ff 18 00 00       	call   802252 <sys_calculate_free_frames>
  800953:	29 c3                	sub    %eax,%ebx
  800955:	89 d8                	mov    %ebx,%eax
  800957:	83 f8 01             	cmp    $0x1,%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 41 3c 80 00       	push   $0x803c41
  800964:	68 aa 00 00 00       	push   $0xaa
  800969:	68 dc 3b 80 00       	push   $0x803bdc
  80096e:	e8 d1 02 00 00       	call   800c44 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1M Hole appended to already existing 1M hole in the middle
		freeFrames = sys_calculate_free_frames() ;
  800973:	e8 da 18 00 00       	call   802252 <sys_calculate_free_frames>
  800978:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80097b:	e8 72 19 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  800980:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  800983:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800986:	83 ec 0c             	sub    $0xc,%esp
  800989:	50                   	push   %eax
  80098a:	e8 10 15 00 00       	call   801e9f <free>
  80098f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800992:	e8 5b 19 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  800997:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80099a:	29 c2                	sub    %eax,%edx
  80099c:	89 d0                	mov    %edx,%eax
  80099e:	3d 00 01 00 00       	cmp    $0x100,%eax
  8009a3:	74 17                	je     8009bc <_main+0x984>
  8009a5:	83 ec 04             	sub    $0x4,%esp
  8009a8:	68 54 3c 80 00       	push   $0x803c54
  8009ad:	68 b4 00 00 00       	push   $0xb4
  8009b2:	68 dc 3b 80 00       	push   $0x803bdc
  8009b7:	e8 88 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009bc:	e8 91 18 00 00       	call   802252 <sys_calculate_free_frames>
  8009c1:	89 c2                	mov    %eax,%edx
  8009c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c6:	39 c2                	cmp    %eax,%edx
  8009c8:	74 17                	je     8009e1 <_main+0x9a9>
  8009ca:	83 ec 04             	sub    $0x4,%esp
  8009cd:	68 6b 3c 80 00       	push   $0x803c6b
  8009d2:	68 b5 00 00 00       	push   $0xb5
  8009d7:	68 dc 3b 80 00       	push   $0x803bdc
  8009dc:	e8 63 02 00 00       	call   800c44 <_panic>

		//another 512 KB Hole appended to the hole
		freeFrames = sys_calculate_free_frames() ;
  8009e1:	e8 6c 18 00 00       	call   802252 <sys_calculate_free_frames>
  8009e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e9:	e8 04 19 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  8009ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[8]);
  8009f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8009f4:	83 ec 0c             	sub    $0xc,%esp
  8009f7:	50                   	push   %eax
  8009f8:	e8 a2 14 00 00       	call   801e9f <free>
  8009fd:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  128) panic("Wrong page file free: ");
  800a00:	e8 ed 18 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  800a05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a08:	29 c2                	sub    %eax,%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800a11:	74 17                	je     800a2a <_main+0x9f2>
  800a13:	83 ec 04             	sub    $0x4,%esp
  800a16:	68 54 3c 80 00       	push   $0x803c54
  800a1b:	68 bc 00 00 00       	push   $0xbc
  800a20:	68 dc 3b 80 00       	push   $0x803bdc
  800a25:	e8 1a 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a2a:	e8 23 18 00 00       	call   802252 <sys_calculate_free_frames>
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a34:	39 c2                	cmp    %eax,%edx
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 6b 3c 80 00       	push   $0x803c6b
  800a40:	68 bd 00 00 00       	push   $0xbd
  800a45:	68 dc 3b 80 00       	push   $0x803bdc
  800a4a:	e8 f5 01 00 00       	call   800c44 <_panic>
	}

	//[5] Allocate again [test best fit]
	{
		//Allocate 2 MB - should be placed in the contiguous hole (2 MB + 512 KB)
		freeFrames = sys_calculate_free_frames();
  800a4f:	e8 fe 17 00 00       	call   802252 <sys_calculate_free_frames>
  800a54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a57:	e8 96 18 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  800a5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(2*Mega - kilo);
  800a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a62:	01 c0                	add    %eax,%eax
  800a64:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800a67:	83 ec 0c             	sub    $0xc,%esp
  800a6a:	50                   	push   %eax
  800a6b:	e8 b4 13 00 00       	call   801e24 <malloc>
  800a70:	83 c4 10             	add    $0x10,%esp
  800a73:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 9*Mega)) panic("Wrong start address for the allocated space... ");
  800a76:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a79:	89 c1                	mov    %eax,%ecx
  800a7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a7e:	89 d0                	mov    %edx,%eax
  800a80:	c1 e0 03             	shl    $0x3,%eax
  800a83:	01 d0                	add    %edx,%eax
  800a85:	05 00 00 00 80       	add    $0x80000000,%eax
  800a8a:	39 c1                	cmp    %eax,%ecx
  800a8c:	74 17                	je     800aa5 <_main+0xa6d>
  800a8e:	83 ec 04             	sub    $0x4,%esp
  800a91:	68 f4 3b 80 00       	push   $0x803bf4
  800a96:	68 c6 00 00 00       	push   $0xc6
  800a9b:	68 dc 3b 80 00       	push   $0x803bdc
  800aa0:	e8 9f 01 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  800aa5:	e8 48 18 00 00       	call   8022f2 <sys_pf_calculate_allocated_pages>
  800aaa:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800aad:	3d 00 02 00 00       	cmp    $0x200,%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 24 3c 80 00       	push   $0x803c24
  800abc:	68 c8 00 00 00       	push   $0xc8
  800ac1:	68 dc 3b 80 00       	push   $0x803bdc
  800ac6:	e8 79 01 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800acb:	e8 82 17 00 00       	call   802252 <sys_calculate_free_frames>
  800ad0:	89 c2                	mov    %eax,%edx
  800ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ad5:	39 c2                	cmp    %eax,%edx
  800ad7:	74 17                	je     800af0 <_main+0xab8>
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	68 41 3c 80 00       	push   $0x803c41
  800ae1:	68 c9 00 00 00       	push   $0xc9
  800ae6:	68 dc 3b 80 00       	push   $0x803bdc
  800aeb:	e8 54 01 00 00       	call   800c44 <_panic>
	}
	cprintf("Congratulations!! test BEST FIT allocation (1) completed successfully.\n");
  800af0:	83 ec 0c             	sub    $0xc,%esp
  800af3:	68 78 3c 80 00       	push   $0x803c78
  800af8:	e8 fb 03 00 00       	call   800ef8 <cprintf>
  800afd:	83 c4 10             	add    $0x10,%esp

	return;
  800b00:	90                   	nop
}
  800b01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b04:	5b                   	pop    %ebx
  800b05:	5f                   	pop    %edi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b0e:	e8 1f 1a 00 00       	call   802532 <sys_getenvindex>
  800b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b19:	89 d0                	mov    %edx,%eax
  800b1b:	c1 e0 03             	shl    $0x3,%eax
  800b1e:	01 d0                	add    %edx,%eax
  800b20:	01 c0                	add    %eax,%eax
  800b22:	01 d0                	add    %edx,%eax
  800b24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b2b:	01 d0                	add    %edx,%eax
  800b2d:	c1 e0 04             	shl    $0x4,%eax
  800b30:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b35:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b3a:	a1 20 50 80 00       	mov    0x805020,%eax
  800b3f:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800b45:	84 c0                	test   %al,%al
  800b47:	74 0f                	je     800b58 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800b49:	a1 20 50 80 00       	mov    0x805020,%eax
  800b4e:	05 5c 05 00 00       	add    $0x55c,%eax
  800b53:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5c:	7e 0a                	jle    800b68 <libmain+0x60>
		binaryname = argv[0];
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	ff 75 08             	pushl  0x8(%ebp)
  800b71:	e8 c2 f4 ff ff       	call   800038 <_main>
  800b76:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800b79:	e8 c1 17 00 00       	call   80233f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800b7e:	83 ec 0c             	sub    $0xc,%esp
  800b81:	68 d8 3c 80 00       	push   $0x803cd8
  800b86:	e8 6d 03 00 00       	call   800ef8 <cprintf>
  800b8b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800b8e:	a1 20 50 80 00       	mov    0x805020,%eax
  800b93:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800b99:	a1 20 50 80 00       	mov    0x805020,%eax
  800b9e:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800ba4:	83 ec 04             	sub    $0x4,%esp
  800ba7:	52                   	push   %edx
  800ba8:	50                   	push   %eax
  800ba9:	68 00 3d 80 00       	push   $0x803d00
  800bae:	e8 45 03 00 00       	call   800ef8 <cprintf>
  800bb3:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800bb6:	a1 20 50 80 00       	mov    0x805020,%eax
  800bbb:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800bc1:	a1 20 50 80 00       	mov    0x805020,%eax
  800bc6:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800bcc:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd1:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800bd7:	51                   	push   %ecx
  800bd8:	52                   	push   %edx
  800bd9:	50                   	push   %eax
  800bda:	68 28 3d 80 00       	push   $0x803d28
  800bdf:	e8 14 03 00 00       	call   800ef8 <cprintf>
  800be4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800be7:	a1 20 50 80 00       	mov    0x805020,%eax
  800bec:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	50                   	push   %eax
  800bf6:	68 80 3d 80 00       	push   $0x803d80
  800bfb:	e8 f8 02 00 00       	call   800ef8 <cprintf>
  800c00:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c03:	83 ec 0c             	sub    $0xc,%esp
  800c06:	68 d8 3c 80 00       	push   $0x803cd8
  800c0b:	e8 e8 02 00 00       	call   800ef8 <cprintf>
  800c10:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c13:	e8 41 17 00 00       	call   802359 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c18:	e8 19 00 00 00       	call   800c36 <exit>
}
  800c1d:	90                   	nop
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c26:	83 ec 0c             	sub    $0xc,%esp
  800c29:	6a 00                	push   $0x0
  800c2b:	e8 ce 18 00 00       	call   8024fe <sys_destroy_env>
  800c30:	83 c4 10             	add    $0x10,%esp
}
  800c33:	90                   	nop
  800c34:	c9                   	leave  
  800c35:	c3                   	ret    

00800c36 <exit>:

void
exit(void)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c3c:	e8 23 19 00 00       	call   802564 <sys_exit_env>
}
  800c41:	90                   	nop
  800c42:	c9                   	leave  
  800c43:	c3                   	ret    

00800c44 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c4a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c4d:	83 c0 04             	add    $0x4,%eax
  800c50:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c53:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c58:	85 c0                	test   %eax,%eax
  800c5a:	74 16                	je     800c72 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c5c:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c61:	83 ec 08             	sub    $0x8,%esp
  800c64:	50                   	push   %eax
  800c65:	68 94 3d 80 00       	push   $0x803d94
  800c6a:	e8 89 02 00 00       	call   800ef8 <cprintf>
  800c6f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c72:	a1 00 50 80 00       	mov    0x805000,%eax
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	ff 75 08             	pushl  0x8(%ebp)
  800c7d:	50                   	push   %eax
  800c7e:	68 99 3d 80 00       	push   $0x803d99
  800c83:	e8 70 02 00 00       	call   800ef8 <cprintf>
  800c88:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800c8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 f4             	pushl  -0xc(%ebp)
  800c94:	50                   	push   %eax
  800c95:	e8 f3 01 00 00       	call   800e8d <vcprintf>
  800c9a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800c9d:	83 ec 08             	sub    $0x8,%esp
  800ca0:	6a 00                	push   $0x0
  800ca2:	68 b5 3d 80 00       	push   $0x803db5
  800ca7:	e8 e1 01 00 00       	call   800e8d <vcprintf>
  800cac:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800caf:	e8 82 ff ff ff       	call   800c36 <exit>

	// should not return here
	while (1) ;
  800cb4:	eb fe                	jmp    800cb4 <_panic+0x70>

00800cb6 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800cbc:	a1 20 50 80 00       	mov    0x805020,%eax
  800cc1:	8b 50 74             	mov    0x74(%eax),%edx
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	39 c2                	cmp    %eax,%edx
  800cc9:	74 14                	je     800cdf <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800ccb:	83 ec 04             	sub    $0x4,%esp
  800cce:	68 b8 3d 80 00       	push   $0x803db8
  800cd3:	6a 26                	push   $0x26
  800cd5:	68 04 3e 80 00       	push   $0x803e04
  800cda:	e8 65 ff ff ff       	call   800c44 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800cdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ce6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ced:	e9 c2 00 00 00       	jmp    800db4 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cf5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	01 d0                	add    %edx,%eax
  800d01:	8b 00                	mov    (%eax),%eax
  800d03:	85 c0                	test   %eax,%eax
  800d05:	75 08                	jne    800d0f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d07:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d0a:	e9 a2 00 00 00       	jmp    800db1 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d0f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d16:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d1d:	eb 69                	jmp    800d88 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d1f:	a1 20 50 80 00       	mov    0x805020,%eax
  800d24:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d2d:	89 d0                	mov    %edx,%eax
  800d2f:	01 c0                	add    %eax,%eax
  800d31:	01 d0                	add    %edx,%eax
  800d33:	c1 e0 03             	shl    $0x3,%eax
  800d36:	01 c8                	add    %ecx,%eax
  800d38:	8a 40 04             	mov    0x4(%eax),%al
  800d3b:	84 c0                	test   %al,%al
  800d3d:	75 46                	jne    800d85 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d3f:	a1 20 50 80 00       	mov    0x805020,%eax
  800d44:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d4d:	89 d0                	mov    %edx,%eax
  800d4f:	01 c0                	add    %eax,%eax
  800d51:	01 d0                	add    %edx,%eax
  800d53:	c1 e0 03             	shl    $0x3,%eax
  800d56:	01 c8                	add    %ecx,%eax
  800d58:	8b 00                	mov    (%eax),%eax
  800d5a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d60:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d65:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d6a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	01 c8                	add    %ecx,%eax
  800d76:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d78:	39 c2                	cmp    %eax,%edx
  800d7a:	75 09                	jne    800d85 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800d7c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800d83:	eb 12                	jmp    800d97 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d85:	ff 45 e8             	incl   -0x18(%ebp)
  800d88:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8d:	8b 50 74             	mov    0x74(%eax),%edx
  800d90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d93:	39 c2                	cmp    %eax,%edx
  800d95:	77 88                	ja     800d1f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800d97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800d9b:	75 14                	jne    800db1 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800d9d:	83 ec 04             	sub    $0x4,%esp
  800da0:	68 10 3e 80 00       	push   $0x803e10
  800da5:	6a 3a                	push   $0x3a
  800da7:	68 04 3e 80 00       	push   $0x803e04
  800dac:	e8 93 fe ff ff       	call   800c44 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800db1:	ff 45 f0             	incl   -0x10(%ebp)
  800db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dba:	0f 8c 32 ff ff ff    	jl     800cf2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800dc0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dc7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800dce:	eb 26                	jmp    800df6 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800dd0:	a1 20 50 80 00       	mov    0x805020,%eax
  800dd5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ddb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dde:	89 d0                	mov    %edx,%eax
  800de0:	01 c0                	add    %eax,%eax
  800de2:	01 d0                	add    %edx,%eax
  800de4:	c1 e0 03             	shl    $0x3,%eax
  800de7:	01 c8                	add    %ecx,%eax
  800de9:	8a 40 04             	mov    0x4(%eax),%al
  800dec:	3c 01                	cmp    $0x1,%al
  800dee:	75 03                	jne    800df3 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800df0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800df3:	ff 45 e0             	incl   -0x20(%ebp)
  800df6:	a1 20 50 80 00       	mov    0x805020,%eax
  800dfb:	8b 50 74             	mov    0x74(%eax),%edx
  800dfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e01:	39 c2                	cmp    %eax,%edx
  800e03:	77 cb                	ja     800dd0 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e08:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e0b:	74 14                	je     800e21 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e0d:	83 ec 04             	sub    $0x4,%esp
  800e10:	68 64 3e 80 00       	push   $0x803e64
  800e15:	6a 44                	push   $0x44
  800e17:	68 04 3e 80 00       	push   $0x803e04
  800e1c:	e8 23 fe ff ff       	call   800c44 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e21:	90                   	nop
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8b 00                	mov    (%eax),%eax
  800e2f:	8d 48 01             	lea    0x1(%eax),%ecx
  800e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e35:	89 0a                	mov    %ecx,(%edx)
  800e37:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3a:	88 d1                	mov    %dl,%cl
  800e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	8b 00                	mov    (%eax),%eax
  800e48:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e4d:	75 2c                	jne    800e7b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e4f:	a0 24 50 80 00       	mov    0x805024,%al
  800e54:	0f b6 c0             	movzbl %al,%eax
  800e57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5a:	8b 12                	mov    (%edx),%edx
  800e5c:	89 d1                	mov    %edx,%ecx
  800e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e61:	83 c2 08             	add    $0x8,%edx
  800e64:	83 ec 04             	sub    $0x4,%esp
  800e67:	50                   	push   %eax
  800e68:	51                   	push   %ecx
  800e69:	52                   	push   %edx
  800e6a:	e8 22 13 00 00       	call   802191 <sys_cputs>
  800e6f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7e:	8b 40 04             	mov    0x4(%eax),%eax
  800e81:	8d 50 01             	lea    0x1(%eax),%edx
  800e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e87:	89 50 04             	mov    %edx,0x4(%eax)
}
  800e8a:	90                   	nop
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800e96:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800e9d:	00 00 00 
	b.cnt = 0;
  800ea0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ea7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800eaa:	ff 75 0c             	pushl  0xc(%ebp)
  800ead:	ff 75 08             	pushl  0x8(%ebp)
  800eb0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800eb6:	50                   	push   %eax
  800eb7:	68 24 0e 80 00       	push   $0x800e24
  800ebc:	e8 11 02 00 00       	call   8010d2 <vprintfmt>
  800ec1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ec4:	a0 24 50 80 00       	mov    0x805024,%al
  800ec9:	0f b6 c0             	movzbl %al,%eax
  800ecc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ed2:	83 ec 04             	sub    $0x4,%esp
  800ed5:	50                   	push   %eax
  800ed6:	52                   	push   %edx
  800ed7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800edd:	83 c0 08             	add    $0x8,%eax
  800ee0:	50                   	push   %eax
  800ee1:	e8 ab 12 00 00       	call   802191 <sys_cputs>
  800ee6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ee9:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800ef0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ef6:	c9                   	leave  
  800ef7:	c3                   	ret    

00800ef8 <cprintf>:

int cprintf(const char *fmt, ...) {
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800efe:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f05:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	ff 75 f4             	pushl  -0xc(%ebp)
  800f14:	50                   	push   %eax
  800f15:	e8 73 ff ff ff       	call   800e8d <vcprintf>
  800f1a:	83 c4 10             	add    $0x10,%esp
  800f1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f2b:	e8 0f 14 00 00       	call   80233f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f30:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	83 ec 08             	sub    $0x8,%esp
  800f3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3f:	50                   	push   %eax
  800f40:	e8 48 ff ff ff       	call   800e8d <vcprintf>
  800f45:	83 c4 10             	add    $0x10,%esp
  800f48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f4b:	e8 09 14 00 00       	call   802359 <sys_enable_interrupt>
	return cnt;
  800f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f53:	c9                   	leave  
  800f54:	c3                   	ret    

00800f55 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	53                   	push   %ebx
  800f59:	83 ec 14             	sub    $0x14,%esp
  800f5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f62:	8b 45 14             	mov    0x14(%ebp),%eax
  800f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800f68:	8b 45 18             	mov    0x18(%ebp),%eax
  800f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f70:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f73:	77 55                	ja     800fca <printnum+0x75>
  800f75:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f78:	72 05                	jb     800f7f <printnum+0x2a>
  800f7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f7d:	77 4b                	ja     800fca <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800f7f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800f82:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800f85:	8b 45 18             	mov    0x18(%ebp),%eax
  800f88:	ba 00 00 00 00       	mov    $0x0,%edx
  800f8d:	52                   	push   %edx
  800f8e:	50                   	push   %eax
  800f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f92:	ff 75 f0             	pushl  -0x10(%ebp)
  800f95:	e8 b2 29 00 00       	call   80394c <__udivdi3>
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	83 ec 04             	sub    $0x4,%esp
  800fa0:	ff 75 20             	pushl  0x20(%ebp)
  800fa3:	53                   	push   %ebx
  800fa4:	ff 75 18             	pushl  0x18(%ebp)
  800fa7:	52                   	push   %edx
  800fa8:	50                   	push   %eax
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	ff 75 08             	pushl  0x8(%ebp)
  800faf:	e8 a1 ff ff ff       	call   800f55 <printnum>
  800fb4:	83 c4 20             	add    $0x20,%esp
  800fb7:	eb 1a                	jmp    800fd3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	ff 75 20             	pushl  0x20(%ebp)
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	ff d0                	call   *%eax
  800fc7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800fca:	ff 4d 1c             	decl   0x1c(%ebp)
  800fcd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800fd1:	7f e6                	jg     800fb9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800fd3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe1:	53                   	push   %ebx
  800fe2:	51                   	push   %ecx
  800fe3:	52                   	push   %edx
  800fe4:	50                   	push   %eax
  800fe5:	e8 72 2a 00 00       	call   803a5c <__umoddi3>
  800fea:	83 c4 10             	add    $0x10,%esp
  800fed:	05 d4 40 80 00       	add    $0x8040d4,%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f be c0             	movsbl %al,%eax
  800ff7:	83 ec 08             	sub    $0x8,%esp
  800ffa:	ff 75 0c             	pushl  0xc(%ebp)
  800ffd:	50                   	push   %eax
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
}
  801006:	90                   	nop
  801007:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80100f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801013:	7e 1c                	jle    801031 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8b 00                	mov    (%eax),%eax
  80101a:	8d 50 08             	lea    0x8(%eax),%edx
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	89 10                	mov    %edx,(%eax)
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8b 00                	mov    (%eax),%eax
  801027:	83 e8 08             	sub    $0x8,%eax
  80102a:	8b 50 04             	mov    0x4(%eax),%edx
  80102d:	8b 00                	mov    (%eax),%eax
  80102f:	eb 40                	jmp    801071 <getuint+0x65>
	else if (lflag)
  801031:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801035:	74 1e                	je     801055 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8b 00                	mov    (%eax),%eax
  80103c:	8d 50 04             	lea    0x4(%eax),%edx
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	89 10                	mov    %edx,(%eax)
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8b 00                	mov    (%eax),%eax
  801049:	83 e8 04             	sub    $0x4,%eax
  80104c:	8b 00                	mov    (%eax),%eax
  80104e:	ba 00 00 00 00       	mov    $0x0,%edx
  801053:	eb 1c                	jmp    801071 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8b 00                	mov    (%eax),%eax
  80105a:	8d 50 04             	lea    0x4(%eax),%edx
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	89 10                	mov    %edx,(%eax)
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8b 00                	mov    (%eax),%eax
  801067:	83 e8 04             	sub    $0x4,%eax
  80106a:	8b 00                	mov    (%eax),%eax
  80106c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801076:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80107a:	7e 1c                	jle    801098 <getint+0x25>
		return va_arg(*ap, long long);
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8b 00                	mov    (%eax),%eax
  801081:	8d 50 08             	lea    0x8(%eax),%edx
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	89 10                	mov    %edx,(%eax)
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8b 00                	mov    (%eax),%eax
  80108e:	83 e8 08             	sub    $0x8,%eax
  801091:	8b 50 04             	mov    0x4(%eax),%edx
  801094:	8b 00                	mov    (%eax),%eax
  801096:	eb 38                	jmp    8010d0 <getint+0x5d>
	else if (lflag)
  801098:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109c:	74 1a                	je     8010b8 <getint+0x45>
		return va_arg(*ap, long);
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	8d 50 04             	lea    0x4(%eax),%edx
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	89 10                	mov    %edx,(%eax)
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8b 00                	mov    (%eax),%eax
  8010b0:	83 e8 04             	sub    $0x4,%eax
  8010b3:	8b 00                	mov    (%eax),%eax
  8010b5:	99                   	cltd   
  8010b6:	eb 18                	jmp    8010d0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8b 00                	mov    (%eax),%eax
  8010bd:	8d 50 04             	lea    0x4(%eax),%edx
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	89 10                	mov    %edx,(%eax)
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	8b 00                	mov    (%eax),%eax
  8010ca:	83 e8 04             	sub    $0x4,%eax
  8010cd:	8b 00                	mov    (%eax),%eax
  8010cf:	99                   	cltd   
}
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    

008010d2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	56                   	push   %esi
  8010d6:	53                   	push   %ebx
  8010d7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010da:	eb 17                	jmp    8010f3 <vprintfmt+0x21>
			if (ch == '\0')
  8010dc:	85 db                	test   %ebx,%ebx
  8010de:	0f 84 af 03 00 00    	je     801493 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8010e4:	83 ec 08             	sub    $0x8,%esp
  8010e7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ea:	53                   	push   %ebx
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	ff d0                	call   *%eax
  8010f0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	8d 50 01             	lea    0x1(%eax),%edx
  8010f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	0f b6 d8             	movzbl %al,%ebx
  801101:	83 fb 25             	cmp    $0x25,%ebx
  801104:	75 d6                	jne    8010dc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801106:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80110a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801111:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801118:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80111f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801126:	8b 45 10             	mov    0x10(%ebp),%eax
  801129:	8d 50 01             	lea    0x1(%eax),%edx
  80112c:	89 55 10             	mov    %edx,0x10(%ebp)
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f b6 d8             	movzbl %al,%ebx
  801134:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801137:	83 f8 55             	cmp    $0x55,%eax
  80113a:	0f 87 2b 03 00 00    	ja     80146b <vprintfmt+0x399>
  801140:	8b 04 85 f8 40 80 00 	mov    0x8040f8(,%eax,4),%eax
  801147:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801149:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80114d:	eb d7                	jmp    801126 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80114f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801153:	eb d1                	jmp    801126 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801155:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80115c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80115f:	89 d0                	mov    %edx,%eax
  801161:	c1 e0 02             	shl    $0x2,%eax
  801164:	01 d0                	add    %edx,%eax
  801166:	01 c0                	add    %eax,%eax
  801168:	01 d8                	add    %ebx,%eax
  80116a:	83 e8 30             	sub    $0x30,%eax
  80116d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801170:	8b 45 10             	mov    0x10(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801178:	83 fb 2f             	cmp    $0x2f,%ebx
  80117b:	7e 3e                	jle    8011bb <vprintfmt+0xe9>
  80117d:	83 fb 39             	cmp    $0x39,%ebx
  801180:	7f 39                	jg     8011bb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801182:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801185:	eb d5                	jmp    80115c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801187:	8b 45 14             	mov    0x14(%ebp),%eax
  80118a:	83 c0 04             	add    $0x4,%eax
  80118d:	89 45 14             	mov    %eax,0x14(%ebp)
  801190:	8b 45 14             	mov    0x14(%ebp),%eax
  801193:	83 e8 04             	sub    $0x4,%eax
  801196:	8b 00                	mov    (%eax),%eax
  801198:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80119b:	eb 1f                	jmp    8011bc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80119d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011a1:	79 83                	jns    801126 <vprintfmt+0x54>
				width = 0;
  8011a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011aa:	e9 77 ff ff ff       	jmp    801126 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011af:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011b6:	e9 6b ff ff ff       	jmp    801126 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011bb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011c0:	0f 89 60 ff ff ff    	jns    801126 <vprintfmt+0x54>
				width = precision, precision = -1;
  8011c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011cc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8011d3:	e9 4e ff ff ff       	jmp    801126 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8011d8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8011db:	e9 46 ff ff ff       	jmp    801126 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8011e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e3:	83 c0 04             	add    $0x4,%eax
  8011e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8011e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ec:	83 e8 04             	sub    $0x4,%eax
  8011ef:	8b 00                	mov    (%eax),%eax
  8011f1:	83 ec 08             	sub    $0x8,%esp
  8011f4:	ff 75 0c             	pushl  0xc(%ebp)
  8011f7:	50                   	push   %eax
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	ff d0                	call   *%eax
  8011fd:	83 c4 10             	add    $0x10,%esp
			break;
  801200:	e9 89 02 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801205:	8b 45 14             	mov    0x14(%ebp),%eax
  801208:	83 c0 04             	add    $0x4,%eax
  80120b:	89 45 14             	mov    %eax,0x14(%ebp)
  80120e:	8b 45 14             	mov    0x14(%ebp),%eax
  801211:	83 e8 04             	sub    $0x4,%eax
  801214:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801216:	85 db                	test   %ebx,%ebx
  801218:	79 02                	jns    80121c <vprintfmt+0x14a>
				err = -err;
  80121a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80121c:	83 fb 64             	cmp    $0x64,%ebx
  80121f:	7f 0b                	jg     80122c <vprintfmt+0x15a>
  801221:	8b 34 9d 40 3f 80 00 	mov    0x803f40(,%ebx,4),%esi
  801228:	85 f6                	test   %esi,%esi
  80122a:	75 19                	jne    801245 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80122c:	53                   	push   %ebx
  80122d:	68 e5 40 80 00       	push   $0x8040e5
  801232:	ff 75 0c             	pushl  0xc(%ebp)
  801235:	ff 75 08             	pushl  0x8(%ebp)
  801238:	e8 5e 02 00 00       	call   80149b <printfmt>
  80123d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801240:	e9 49 02 00 00       	jmp    80148e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801245:	56                   	push   %esi
  801246:	68 ee 40 80 00       	push   $0x8040ee
  80124b:	ff 75 0c             	pushl  0xc(%ebp)
  80124e:	ff 75 08             	pushl  0x8(%ebp)
  801251:	e8 45 02 00 00       	call   80149b <printfmt>
  801256:	83 c4 10             	add    $0x10,%esp
			break;
  801259:	e9 30 02 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80125e:	8b 45 14             	mov    0x14(%ebp),%eax
  801261:	83 c0 04             	add    $0x4,%eax
  801264:	89 45 14             	mov    %eax,0x14(%ebp)
  801267:	8b 45 14             	mov    0x14(%ebp),%eax
  80126a:	83 e8 04             	sub    $0x4,%eax
  80126d:	8b 30                	mov    (%eax),%esi
  80126f:	85 f6                	test   %esi,%esi
  801271:	75 05                	jne    801278 <vprintfmt+0x1a6>
				p = "(null)";
  801273:	be f1 40 80 00       	mov    $0x8040f1,%esi
			if (width > 0 && padc != '-')
  801278:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80127c:	7e 6d                	jle    8012eb <vprintfmt+0x219>
  80127e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801282:	74 67                	je     8012eb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801284:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801287:	83 ec 08             	sub    $0x8,%esp
  80128a:	50                   	push   %eax
  80128b:	56                   	push   %esi
  80128c:	e8 0c 03 00 00       	call   80159d <strnlen>
  801291:	83 c4 10             	add    $0x10,%esp
  801294:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801297:	eb 16                	jmp    8012af <vprintfmt+0x1dd>
					putch(padc, putdat);
  801299:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80129d:	83 ec 08             	sub    $0x8,%esp
  8012a0:	ff 75 0c             	pushl  0xc(%ebp)
  8012a3:	50                   	push   %eax
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	ff d0                	call   *%eax
  8012a9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8012af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012b3:	7f e4                	jg     801299 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012b5:	eb 34                	jmp    8012eb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012bb:	74 1c                	je     8012d9 <vprintfmt+0x207>
  8012bd:	83 fb 1f             	cmp    $0x1f,%ebx
  8012c0:	7e 05                	jle    8012c7 <vprintfmt+0x1f5>
  8012c2:	83 fb 7e             	cmp    $0x7e,%ebx
  8012c5:	7e 12                	jle    8012d9 <vprintfmt+0x207>
					putch('?', putdat);
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	ff 75 0c             	pushl  0xc(%ebp)
  8012cd:	6a 3f                	push   $0x3f
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	ff d0                	call   *%eax
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	eb 0f                	jmp    8012e8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8012d9:	83 ec 08             	sub    $0x8,%esp
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	53                   	push   %ebx
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	ff d0                	call   *%eax
  8012e5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012e8:	ff 4d e4             	decl   -0x1c(%ebp)
  8012eb:	89 f0                	mov    %esi,%eax
  8012ed:	8d 70 01             	lea    0x1(%eax),%esi
  8012f0:	8a 00                	mov    (%eax),%al
  8012f2:	0f be d8             	movsbl %al,%ebx
  8012f5:	85 db                	test   %ebx,%ebx
  8012f7:	74 24                	je     80131d <vprintfmt+0x24b>
  8012f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012fd:	78 b8                	js     8012b7 <vprintfmt+0x1e5>
  8012ff:	ff 4d e0             	decl   -0x20(%ebp)
  801302:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801306:	79 af                	jns    8012b7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801308:	eb 13                	jmp    80131d <vprintfmt+0x24b>
				putch(' ', putdat);
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	ff 75 0c             	pushl  0xc(%ebp)
  801310:	6a 20                	push   $0x20
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	ff d0                	call   *%eax
  801317:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80131a:	ff 4d e4             	decl   -0x1c(%ebp)
  80131d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801321:	7f e7                	jg     80130a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801323:	e9 66 01 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801328:	83 ec 08             	sub    $0x8,%esp
  80132b:	ff 75 e8             	pushl  -0x18(%ebp)
  80132e:	8d 45 14             	lea    0x14(%ebp),%eax
  801331:	50                   	push   %eax
  801332:	e8 3c fd ff ff       	call   801073 <getint>
  801337:	83 c4 10             	add    $0x10,%esp
  80133a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80133d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801343:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801346:	85 d2                	test   %edx,%edx
  801348:	79 23                	jns    80136d <vprintfmt+0x29b>
				putch('-', putdat);
  80134a:	83 ec 08             	sub    $0x8,%esp
  80134d:	ff 75 0c             	pushl  0xc(%ebp)
  801350:	6a 2d                	push   $0x2d
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	ff d0                	call   *%eax
  801357:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80135a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801360:	f7 d8                	neg    %eax
  801362:	83 d2 00             	adc    $0x0,%edx
  801365:	f7 da                	neg    %edx
  801367:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80136a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80136d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801374:	e9 bc 00 00 00       	jmp    801435 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801379:	83 ec 08             	sub    $0x8,%esp
  80137c:	ff 75 e8             	pushl  -0x18(%ebp)
  80137f:	8d 45 14             	lea    0x14(%ebp),%eax
  801382:	50                   	push   %eax
  801383:	e8 84 fc ff ff       	call   80100c <getuint>
  801388:	83 c4 10             	add    $0x10,%esp
  80138b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80138e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801391:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801398:	e9 98 00 00 00       	jmp    801435 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80139d:	83 ec 08             	sub    $0x8,%esp
  8013a0:	ff 75 0c             	pushl  0xc(%ebp)
  8013a3:	6a 58                	push   $0x58
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	ff d0                	call   *%eax
  8013aa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013ad:	83 ec 08             	sub    $0x8,%esp
  8013b0:	ff 75 0c             	pushl  0xc(%ebp)
  8013b3:	6a 58                	push   $0x58
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b8:	ff d0                	call   *%eax
  8013ba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	6a 58                	push   $0x58
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	ff d0                	call   *%eax
  8013ca:	83 c4 10             	add    $0x10,%esp
			break;
  8013cd:	e9 bc 00 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8013d2:	83 ec 08             	sub    $0x8,%esp
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	6a 30                	push   $0x30
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	ff d0                	call   *%eax
  8013df:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	ff 75 0c             	pushl  0xc(%ebp)
  8013e8:	6a 78                	push   $0x78
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	ff d0                	call   *%eax
  8013ef:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8013f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f5:	83 c0 04             	add    $0x4,%eax
  8013f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8013fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fe:	83 e8 04             	sub    $0x4,%eax
  801401:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801403:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80140d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801414:	eb 1f                	jmp    801435 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	ff 75 e8             	pushl  -0x18(%ebp)
  80141c:	8d 45 14             	lea    0x14(%ebp),%eax
  80141f:	50                   	push   %eax
  801420:	e8 e7 fb ff ff       	call   80100c <getuint>
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80142b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80142e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801435:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801439:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80143c:	83 ec 04             	sub    $0x4,%esp
  80143f:	52                   	push   %edx
  801440:	ff 75 e4             	pushl  -0x1c(%ebp)
  801443:	50                   	push   %eax
  801444:	ff 75 f4             	pushl  -0xc(%ebp)
  801447:	ff 75 f0             	pushl  -0x10(%ebp)
  80144a:	ff 75 0c             	pushl  0xc(%ebp)
  80144d:	ff 75 08             	pushl  0x8(%ebp)
  801450:	e8 00 fb ff ff       	call   800f55 <printnum>
  801455:	83 c4 20             	add    $0x20,%esp
			break;
  801458:	eb 34                	jmp    80148e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80145a:	83 ec 08             	sub    $0x8,%esp
  80145d:	ff 75 0c             	pushl  0xc(%ebp)
  801460:	53                   	push   %ebx
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	ff d0                	call   *%eax
  801466:	83 c4 10             	add    $0x10,%esp
			break;
  801469:	eb 23                	jmp    80148e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80146b:	83 ec 08             	sub    $0x8,%esp
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	6a 25                	push   $0x25
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	ff d0                	call   *%eax
  801478:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80147b:	ff 4d 10             	decl   0x10(%ebp)
  80147e:	eb 03                	jmp    801483 <vprintfmt+0x3b1>
  801480:	ff 4d 10             	decl   0x10(%ebp)
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	48                   	dec    %eax
  801487:	8a 00                	mov    (%eax),%al
  801489:	3c 25                	cmp    $0x25,%al
  80148b:	75 f3                	jne    801480 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80148d:	90                   	nop
		}
	}
  80148e:	e9 47 fc ff ff       	jmp    8010da <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801493:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801494:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801497:	5b                   	pop    %ebx
  801498:	5e                   	pop    %esi
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    

0080149b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8014a4:	83 c0 04             	add    $0x4,%eax
  8014a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8014b0:	50                   	push   %eax
  8014b1:	ff 75 0c             	pushl  0xc(%ebp)
  8014b4:	ff 75 08             	pushl  0x8(%ebp)
  8014b7:	e8 16 fc ff ff       	call   8010d2 <vprintfmt>
  8014bc:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8014bf:	90                   	nop
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c8:	8b 40 08             	mov    0x8(%eax),%eax
  8014cb:	8d 50 01             	lea    0x1(%eax),%edx
  8014ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8014d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d7:	8b 10                	mov    (%eax),%edx
  8014d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dc:	8b 40 04             	mov    0x4(%eax),%eax
  8014df:	39 c2                	cmp    %eax,%edx
  8014e1:	73 12                	jae    8014f5 <sprintputch+0x33>
		*b->buf++ = ch;
  8014e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e6:	8b 00                	mov    (%eax),%eax
  8014e8:	8d 48 01             	lea    0x1(%eax),%ecx
  8014eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ee:	89 0a                	mov    %ecx,(%edx)
  8014f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f3:	88 10                	mov    %dl,(%eax)
}
  8014f5:	90                   	nop
  8014f6:	5d                   	pop    %ebp
  8014f7:	c3                   	ret    

008014f8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	01 d0                	add    %edx,%eax
  80150f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801512:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801519:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80151d:	74 06                	je     801525 <vsnprintf+0x2d>
  80151f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801523:	7f 07                	jg     80152c <vsnprintf+0x34>
		return -E_INVAL;
  801525:	b8 03 00 00 00       	mov    $0x3,%eax
  80152a:	eb 20                	jmp    80154c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80152c:	ff 75 14             	pushl  0x14(%ebp)
  80152f:	ff 75 10             	pushl  0x10(%ebp)
  801532:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801535:	50                   	push   %eax
  801536:	68 c2 14 80 00       	push   $0x8014c2
  80153b:	e8 92 fb ff ff       	call   8010d2 <vprintfmt>
  801540:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801546:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801549:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801554:	8d 45 10             	lea    0x10(%ebp),%eax
  801557:	83 c0 04             	add    $0x4,%eax
  80155a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80155d:	8b 45 10             	mov    0x10(%ebp),%eax
  801560:	ff 75 f4             	pushl  -0xc(%ebp)
  801563:	50                   	push   %eax
  801564:	ff 75 0c             	pushl  0xc(%ebp)
  801567:	ff 75 08             	pushl  0x8(%ebp)
  80156a:	e8 89 ff ff ff       	call   8014f8 <vsnprintf>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801575:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801580:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801587:	eb 06                	jmp    80158f <strlen+0x15>
		n++;
  801589:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80158c:	ff 45 08             	incl   0x8(%ebp)
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	84 c0                	test   %al,%al
  801596:	75 f1                	jne    801589 <strlen+0xf>
		n++;
	return n;
  801598:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015aa:	eb 09                	jmp    8015b5 <strnlen+0x18>
		n++;
  8015ac:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015af:	ff 45 08             	incl   0x8(%ebp)
  8015b2:	ff 4d 0c             	decl   0xc(%ebp)
  8015b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b9:	74 09                	je     8015c4 <strnlen+0x27>
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	84 c0                	test   %al,%al
  8015c2:	75 e8                	jne    8015ac <strnlen+0xf>
		n++;
	return n;
  8015c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015d5:	90                   	nop
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	8d 50 01             	lea    0x1(%eax),%edx
  8015dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8015df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015e5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015e8:	8a 12                	mov    (%edx),%dl
  8015ea:	88 10                	mov    %dl,(%eax)
  8015ec:	8a 00                	mov    (%eax),%al
  8015ee:	84 c0                	test   %al,%al
  8015f0:	75 e4                	jne    8015d6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801603:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80160a:	eb 1f                	jmp    80162b <strncpy+0x34>
		*dst++ = *src;
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8d 50 01             	lea    0x1(%eax),%edx
  801612:	89 55 08             	mov    %edx,0x8(%ebp)
  801615:	8b 55 0c             	mov    0xc(%ebp),%edx
  801618:	8a 12                	mov    (%edx),%dl
  80161a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80161c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161f:	8a 00                	mov    (%eax),%al
  801621:	84 c0                	test   %al,%al
  801623:	74 03                	je     801628 <strncpy+0x31>
			src++;
  801625:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801628:	ff 45 fc             	incl   -0x4(%ebp)
  80162b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801631:	72 d9                	jb     80160c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801633:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801644:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801648:	74 30                	je     80167a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80164a:	eb 16                	jmp    801662 <strlcpy+0x2a>
			*dst++ = *src++;
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	8d 50 01             	lea    0x1(%eax),%edx
  801652:	89 55 08             	mov    %edx,0x8(%ebp)
  801655:	8b 55 0c             	mov    0xc(%ebp),%edx
  801658:	8d 4a 01             	lea    0x1(%edx),%ecx
  80165b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80165e:	8a 12                	mov    (%edx),%dl
  801660:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801662:	ff 4d 10             	decl   0x10(%ebp)
  801665:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801669:	74 09                	je     801674 <strlcpy+0x3c>
  80166b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	84 c0                	test   %al,%al
  801672:	75 d8                	jne    80164c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80167a:	8b 55 08             	mov    0x8(%ebp),%edx
  80167d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801680:	29 c2                	sub    %eax,%edx
  801682:	89 d0                	mov    %edx,%eax
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801689:	eb 06                	jmp    801691 <strcmp+0xb>
		p++, q++;
  80168b:	ff 45 08             	incl   0x8(%ebp)
  80168e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	8a 00                	mov    (%eax),%al
  801696:	84 c0                	test   %al,%al
  801698:	74 0e                	je     8016a8 <strcmp+0x22>
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 10                	mov    (%eax),%dl
  80169f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	38 c2                	cmp    %al,%dl
  8016a6:	74 e3                	je     80168b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	0f b6 d0             	movzbl %al,%edx
  8016b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b3:	8a 00                	mov    (%eax),%al
  8016b5:	0f b6 c0             	movzbl %al,%eax
  8016b8:	29 c2                	sub    %eax,%edx
  8016ba:	89 d0                	mov    %edx,%eax
}
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016c1:	eb 09                	jmp    8016cc <strncmp+0xe>
		n--, p++, q++;
  8016c3:	ff 4d 10             	decl   0x10(%ebp)
  8016c6:	ff 45 08             	incl   0x8(%ebp)
  8016c9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016d0:	74 17                	je     8016e9 <strncmp+0x2b>
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	8a 00                	mov    (%eax),%al
  8016d7:	84 c0                	test   %al,%al
  8016d9:	74 0e                	je     8016e9 <strncmp+0x2b>
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	8a 10                	mov    (%eax),%dl
  8016e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e3:	8a 00                	mov    (%eax),%al
  8016e5:	38 c2                	cmp    %al,%dl
  8016e7:	74 da                	je     8016c3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ed:	75 07                	jne    8016f6 <strncmp+0x38>
		return 0;
  8016ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f4:	eb 14                	jmp    80170a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	0f b6 d0             	movzbl %al,%edx
  8016fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801701:	8a 00                	mov    (%eax),%al
  801703:	0f b6 c0             	movzbl %al,%eax
  801706:	29 c2                	sub    %eax,%edx
  801708:	89 d0                	mov    %edx,%eax
}
  80170a:	5d                   	pop    %ebp
  80170b:	c3                   	ret    

0080170c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	8b 45 0c             	mov    0xc(%ebp),%eax
  801715:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801718:	eb 12                	jmp    80172c <strchr+0x20>
		if (*s == c)
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801722:	75 05                	jne    801729 <strchr+0x1d>
			return (char *) s;
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	eb 11                	jmp    80173a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801729:	ff 45 08             	incl   0x8(%ebp)
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	84 c0                	test   %al,%al
  801733:	75 e5                	jne    80171a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	8b 45 0c             	mov    0xc(%ebp),%eax
  801745:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801748:	eb 0d                	jmp    801757 <strfind+0x1b>
		if (*s == c)
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	8a 00                	mov    (%eax),%al
  80174f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801752:	74 0e                	je     801762 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801754:	ff 45 08             	incl   0x8(%ebp)
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	75 ea                	jne    80174a <strfind+0xe>
  801760:	eb 01                	jmp    801763 <strfind+0x27>
		if (*s == c)
			break;
  801762:	90                   	nop
	return (char *) s;
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801774:	8b 45 10             	mov    0x10(%ebp),%eax
  801777:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80177a:	eb 0e                	jmp    80178a <memset+0x22>
		*p++ = c;
  80177c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80177f:	8d 50 01             	lea    0x1(%eax),%edx
  801782:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801785:	8b 55 0c             	mov    0xc(%ebp),%edx
  801788:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80178a:	ff 4d f8             	decl   -0x8(%ebp)
  80178d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801791:	79 e9                	jns    80177c <memset+0x14>
		*p++ = c;

	return v;
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80179e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017aa:	eb 16                	jmp    8017c2 <memcpy+0x2a>
		*d++ = *s++;
  8017ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017af:	8d 50 01             	lea    0x1(%eax),%edx
  8017b2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017bb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8017be:	8a 12                	mov    (%edx),%dl
  8017c0:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8017c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	75 dd                	jne    8017ac <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017ec:	73 50                	jae    80183e <memmove+0x6a>
  8017ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f4:	01 d0                	add    %edx,%eax
  8017f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017f9:	76 43                	jbe    80183e <memmove+0x6a>
		s += n;
  8017fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fe:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801801:	8b 45 10             	mov    0x10(%ebp),%eax
  801804:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801807:	eb 10                	jmp    801819 <memmove+0x45>
			*--d = *--s;
  801809:	ff 4d f8             	decl   -0x8(%ebp)
  80180c:	ff 4d fc             	decl   -0x4(%ebp)
  80180f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801812:	8a 10                	mov    (%eax),%dl
  801814:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801817:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801819:	8b 45 10             	mov    0x10(%ebp),%eax
  80181c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80181f:	89 55 10             	mov    %edx,0x10(%ebp)
  801822:	85 c0                	test   %eax,%eax
  801824:	75 e3                	jne    801809 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801826:	eb 23                	jmp    80184b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801828:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80182b:	8d 50 01             	lea    0x1(%eax),%edx
  80182e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801831:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801834:	8d 4a 01             	lea    0x1(%edx),%ecx
  801837:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80183a:	8a 12                	mov    (%edx),%dl
  80183c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80183e:	8b 45 10             	mov    0x10(%ebp),%eax
  801841:	8d 50 ff             	lea    -0x1(%eax),%edx
  801844:	89 55 10             	mov    %edx,0x10(%ebp)
  801847:	85 c0                	test   %eax,%eax
  801849:	75 dd                	jne    801828 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801862:	eb 2a                	jmp    80188e <memcmp+0x3e>
		if (*s1 != *s2)
  801864:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801867:	8a 10                	mov    (%eax),%dl
  801869:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	38 c2                	cmp    %al,%dl
  801870:	74 16                	je     801888 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801872:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801875:	8a 00                	mov    (%eax),%al
  801877:	0f b6 d0             	movzbl %al,%edx
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187d:	8a 00                	mov    (%eax),%al
  80187f:	0f b6 c0             	movzbl %al,%eax
  801882:	29 c2                	sub    %eax,%edx
  801884:	89 d0                	mov    %edx,%eax
  801886:	eb 18                	jmp    8018a0 <memcmp+0x50>
		s1++, s2++;
  801888:	ff 45 fc             	incl   -0x4(%ebp)
  80188b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
  801891:	8d 50 ff             	lea    -0x1(%eax),%edx
  801894:	89 55 10             	mov    %edx,0x10(%ebp)
  801897:	85 c0                	test   %eax,%eax
  801899:	75 c9                	jne    801864 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ae:	01 d0                	add    %edx,%eax
  8018b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018b3:	eb 15                	jmp    8018ca <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	0f b6 d0             	movzbl %al,%edx
  8018bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c0:	0f b6 c0             	movzbl %al,%eax
  8018c3:	39 c2                	cmp    %eax,%edx
  8018c5:	74 0d                	je     8018d4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018c7:	ff 45 08             	incl   0x8(%ebp)
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018d0:	72 e3                	jb     8018b5 <memfind+0x13>
  8018d2:	eb 01                	jmp    8018d5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018d4:	90                   	nop
	return (void *) s;
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018ee:	eb 03                	jmp    8018f3 <strtol+0x19>
		s++;
  8018f0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	8a 00                	mov    (%eax),%al
  8018f8:	3c 20                	cmp    $0x20,%al
  8018fa:	74 f4                	je     8018f0 <strtol+0x16>
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	8a 00                	mov    (%eax),%al
  801901:	3c 09                	cmp    $0x9,%al
  801903:	74 eb                	je     8018f0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	8a 00                	mov    (%eax),%al
  80190a:	3c 2b                	cmp    $0x2b,%al
  80190c:	75 05                	jne    801913 <strtol+0x39>
		s++;
  80190e:	ff 45 08             	incl   0x8(%ebp)
  801911:	eb 13                	jmp    801926 <strtol+0x4c>
	else if (*s == '-')
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	8a 00                	mov    (%eax),%al
  801918:	3c 2d                	cmp    $0x2d,%al
  80191a:	75 0a                	jne    801926 <strtol+0x4c>
		s++, neg = 1;
  80191c:	ff 45 08             	incl   0x8(%ebp)
  80191f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801926:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80192a:	74 06                	je     801932 <strtol+0x58>
  80192c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801930:	75 20                	jne    801952 <strtol+0x78>
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	3c 30                	cmp    $0x30,%al
  801939:	75 17                	jne    801952 <strtol+0x78>
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	40                   	inc    %eax
  80193f:	8a 00                	mov    (%eax),%al
  801941:	3c 78                	cmp    $0x78,%al
  801943:	75 0d                	jne    801952 <strtol+0x78>
		s += 2, base = 16;
  801945:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801949:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801950:	eb 28                	jmp    80197a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801952:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801956:	75 15                	jne    80196d <strtol+0x93>
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	8a 00                	mov    (%eax),%al
  80195d:	3c 30                	cmp    $0x30,%al
  80195f:	75 0c                	jne    80196d <strtol+0x93>
		s++, base = 8;
  801961:	ff 45 08             	incl   0x8(%ebp)
  801964:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80196b:	eb 0d                	jmp    80197a <strtol+0xa0>
	else if (base == 0)
  80196d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801971:	75 07                	jne    80197a <strtol+0xa0>
		base = 10;
  801973:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	8a 00                	mov    (%eax),%al
  80197f:	3c 2f                	cmp    $0x2f,%al
  801981:	7e 19                	jle    80199c <strtol+0xc2>
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	8a 00                	mov    (%eax),%al
  801988:	3c 39                	cmp    $0x39,%al
  80198a:	7f 10                	jg     80199c <strtol+0xc2>
			dig = *s - '0';
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	8a 00                	mov    (%eax),%al
  801991:	0f be c0             	movsbl %al,%eax
  801994:	83 e8 30             	sub    $0x30,%eax
  801997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80199a:	eb 42                	jmp    8019de <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	8a 00                	mov    (%eax),%al
  8019a1:	3c 60                	cmp    $0x60,%al
  8019a3:	7e 19                	jle    8019be <strtol+0xe4>
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	8a 00                	mov    (%eax),%al
  8019aa:	3c 7a                	cmp    $0x7a,%al
  8019ac:	7f 10                	jg     8019be <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	8a 00                	mov    (%eax),%al
  8019b3:	0f be c0             	movsbl %al,%eax
  8019b6:	83 e8 57             	sub    $0x57,%eax
  8019b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019bc:	eb 20                	jmp    8019de <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	3c 40                	cmp    $0x40,%al
  8019c5:	7e 39                	jle    801a00 <strtol+0x126>
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	8a 00                	mov    (%eax),%al
  8019cc:	3c 5a                	cmp    $0x5a,%al
  8019ce:	7f 30                	jg     801a00 <strtol+0x126>
			dig = *s - 'A' + 10;
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	8a 00                	mov    (%eax),%al
  8019d5:	0f be c0             	movsbl %al,%eax
  8019d8:	83 e8 37             	sub    $0x37,%eax
  8019db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019e4:	7d 19                	jge    8019ff <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019e6:	ff 45 08             	incl   0x8(%ebp)
  8019e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ec:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019f0:	89 c2                	mov    %eax,%edx
  8019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f5:	01 d0                	add    %edx,%eax
  8019f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019fa:	e9 7b ff ff ff       	jmp    80197a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019ff:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a04:	74 08                	je     801a0e <strtol+0x134>
		*endptr = (char *) s;
  801a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a09:	8b 55 08             	mov    0x8(%ebp),%edx
  801a0c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a12:	74 07                	je     801a1b <strtol+0x141>
  801a14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a17:	f7 d8                	neg    %eax
  801a19:	eb 03                	jmp    801a1e <strtol+0x144>
  801a1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <ltostr>:

void
ltostr(long value, char *str)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a2d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a38:	79 13                	jns    801a4d <ltostr+0x2d>
	{
		neg = 1;
  801a3a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a44:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a47:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a4a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a55:	99                   	cltd   
  801a56:	f7 f9                	idiv   %ecx
  801a58:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5e:	8d 50 01             	lea    0x1(%eax),%edx
  801a61:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a64:	89 c2                	mov    %eax,%edx
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a6e:	83 c2 30             	add    $0x30,%edx
  801a71:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a76:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a7b:	f7 e9                	imul   %ecx
  801a7d:	c1 fa 02             	sar    $0x2,%edx
  801a80:	89 c8                	mov    %ecx,%eax
  801a82:	c1 f8 1f             	sar    $0x1f,%eax
  801a85:	29 c2                	sub    %eax,%edx
  801a87:	89 d0                	mov    %edx,%eax
  801a89:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801a8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a8f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a94:	f7 e9                	imul   %ecx
  801a96:	c1 fa 02             	sar    $0x2,%edx
  801a99:	89 c8                	mov    %ecx,%eax
  801a9b:	c1 f8 1f             	sar    $0x1f,%eax
  801a9e:	29 c2                	sub    %eax,%edx
  801aa0:	89 d0                	mov    %edx,%eax
  801aa2:	c1 e0 02             	shl    $0x2,%eax
  801aa5:	01 d0                	add    %edx,%eax
  801aa7:	01 c0                	add    %eax,%eax
  801aa9:	29 c1                	sub    %eax,%ecx
  801aab:	89 ca                	mov    %ecx,%edx
  801aad:	85 d2                	test   %edx,%edx
  801aaf:	75 9c                	jne    801a4d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801ab1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801ab8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abb:	48                   	dec    %eax
  801abc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801abf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ac3:	74 3d                	je     801b02 <ltostr+0xe2>
		start = 1 ;
  801ac5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801acc:	eb 34                	jmp    801b02 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad4:	01 d0                	add    %edx,%eax
  801ad6:	8a 00                	mov    (%eax),%al
  801ad8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae1:	01 c2                	add    %eax,%edx
  801ae3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae9:	01 c8                	add    %ecx,%eax
  801aeb:	8a 00                	mov    (%eax),%al
  801aed:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801aef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af5:	01 c2                	add    %eax,%edx
  801af7:	8a 45 eb             	mov    -0x15(%ebp),%al
  801afa:	88 02                	mov    %al,(%edx)
		start++ ;
  801afc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801aff:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b05:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b08:	7c c4                	jl     801ace <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b0a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b10:	01 d0                	add    %edx,%eax
  801b12:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b15:	90                   	nop
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b1e:	ff 75 08             	pushl  0x8(%ebp)
  801b21:	e8 54 fa ff ff       	call   80157a <strlen>
  801b26:	83 c4 04             	add    $0x4,%esp
  801b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	e8 46 fa ff ff       	call   80157a <strlen>
  801b34:	83 c4 04             	add    $0x4,%esp
  801b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b48:	eb 17                	jmp    801b61 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b50:	01 c2                	add    %eax,%edx
  801b52:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	01 c8                	add    %ecx,%eax
  801b5a:	8a 00                	mov    (%eax),%al
  801b5c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b5e:	ff 45 fc             	incl   -0x4(%ebp)
  801b61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b64:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b67:	7c e1                	jl     801b4a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b69:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b70:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b77:	eb 1f                	jmp    801b98 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b7c:	8d 50 01             	lea    0x1(%eax),%edx
  801b7f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b82:	89 c2                	mov    %eax,%edx
  801b84:	8b 45 10             	mov    0x10(%ebp),%eax
  801b87:	01 c2                	add    %eax,%edx
  801b89:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8f:	01 c8                	add    %ecx,%eax
  801b91:	8a 00                	mov    (%eax),%al
  801b93:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b95:	ff 45 f8             	incl   -0x8(%ebp)
  801b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b9e:	7c d9                	jl     801b79 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ba0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba6:	01 d0                	add    %edx,%eax
  801ba8:	c6 00 00             	movb   $0x0,(%eax)
}
  801bab:	90                   	nop
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bb1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bba:	8b 45 14             	mov    0x14(%ebp),%eax
  801bbd:	8b 00                	mov    (%eax),%eax
  801bbf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bc6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc9:	01 d0                	add    %edx,%eax
  801bcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bd1:	eb 0c                	jmp    801bdf <strsplit+0x31>
			*string++ = 0;
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	8d 50 01             	lea    0x1(%eax),%edx
  801bd9:	89 55 08             	mov    %edx,0x8(%ebp)
  801bdc:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	8a 00                	mov    (%eax),%al
  801be4:	84 c0                	test   %al,%al
  801be6:	74 18                	je     801c00 <strsplit+0x52>
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	8a 00                	mov    (%eax),%al
  801bed:	0f be c0             	movsbl %al,%eax
  801bf0:	50                   	push   %eax
  801bf1:	ff 75 0c             	pushl  0xc(%ebp)
  801bf4:	e8 13 fb ff ff       	call   80170c <strchr>
  801bf9:	83 c4 08             	add    $0x8,%esp
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	75 d3                	jne    801bd3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	8a 00                	mov    (%eax),%al
  801c05:	84 c0                	test   %al,%al
  801c07:	74 5a                	je     801c63 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c09:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0c:	8b 00                	mov    (%eax),%eax
  801c0e:	83 f8 0f             	cmp    $0xf,%eax
  801c11:	75 07                	jne    801c1a <strsplit+0x6c>
		{
			return 0;
  801c13:	b8 00 00 00 00       	mov    $0x0,%eax
  801c18:	eb 66                	jmp    801c80 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1d:	8b 00                	mov    (%eax),%eax
  801c1f:	8d 48 01             	lea    0x1(%eax),%ecx
  801c22:	8b 55 14             	mov    0x14(%ebp),%edx
  801c25:	89 0a                	mov    %ecx,(%edx)
  801c27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c31:	01 c2                	add    %eax,%edx
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c38:	eb 03                	jmp    801c3d <strsplit+0x8f>
			string++;
  801c3a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	8a 00                	mov    (%eax),%al
  801c42:	84 c0                	test   %al,%al
  801c44:	74 8b                	je     801bd1 <strsplit+0x23>
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	8a 00                	mov    (%eax),%al
  801c4b:	0f be c0             	movsbl %al,%eax
  801c4e:	50                   	push   %eax
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	e8 b5 fa ff ff       	call   80170c <strchr>
  801c57:	83 c4 08             	add    $0x8,%esp
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	74 dc                	je     801c3a <strsplit+0x8c>
			string++;
	}
  801c5e:	e9 6e ff ff ff       	jmp    801bd1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c63:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c64:	8b 45 14             	mov    0x14(%ebp),%eax
  801c67:	8b 00                	mov    (%eax),%eax
  801c69:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c70:	8b 45 10             	mov    0x10(%ebp),%eax
  801c73:	01 d0                	add    %edx,%eax
  801c75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c7b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801c88:	a1 04 50 80 00       	mov    0x805004,%eax
  801c8d:	85 c0                	test   %eax,%eax
  801c8f:	74 1f                	je     801cb0 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801c91:	e8 1d 00 00 00       	call   801cb3 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801c96:	83 ec 0c             	sub    $0xc,%esp
  801c99:	68 50 42 80 00       	push   $0x804250
  801c9e:	e8 55 f2 ff ff       	call   800ef8 <cprintf>
  801ca3:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801ca6:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801cad:	00 00 00 
	}
}
  801cb0:	90                   	nop
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801cb9:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801cc0:	00 00 00 
  801cc3:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801cca:	00 00 00 
  801ccd:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801cd4:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801cd7:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801cde:	00 00 00 
  801ce1:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801ce8:	00 00 00 
  801ceb:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801cf2:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801cf5:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801cfc:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801cff:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d0e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d13:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801d18:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d1f:	a1 20 51 80 00       	mov    0x805120,%eax
  801d24:	c1 e0 04             	shl    $0x4,%eax
  801d27:	89 c2                	mov    %eax,%edx
  801d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d2c:	01 d0                	add    %edx,%eax
  801d2e:	48                   	dec    %eax
  801d2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d35:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3a:	f7 75 f0             	divl   -0x10(%ebp)
  801d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d40:	29 d0                	sub    %edx,%eax
  801d42:	89 c2                	mov    %eax,%edx
  801d44:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801d4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d53:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d58:	83 ec 04             	sub    $0x4,%esp
  801d5b:	6a 06                	push   $0x6
  801d5d:	52                   	push   %edx
  801d5e:	50                   	push   %eax
  801d5f:	e8 71 05 00 00       	call   8022d5 <sys_allocate_chunk>
  801d64:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801d67:	a1 20 51 80 00       	mov    0x805120,%eax
  801d6c:	83 ec 0c             	sub    $0xc,%esp
  801d6f:	50                   	push   %eax
  801d70:	e8 e6 0b 00 00       	call   80295b <initialize_MemBlocksList>
  801d75:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801d78:	a1 48 51 80 00       	mov    0x805148,%eax
  801d7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801d80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d84:	75 14                	jne    801d9a <initialize_dyn_block_system+0xe7>
  801d86:	83 ec 04             	sub    $0x4,%esp
  801d89:	68 75 42 80 00       	push   $0x804275
  801d8e:	6a 2b                	push   $0x2b
  801d90:	68 93 42 80 00       	push   $0x804293
  801d95:	e8 aa ee ff ff       	call   800c44 <_panic>
  801d9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d9d:	8b 00                	mov    (%eax),%eax
  801d9f:	85 c0                	test   %eax,%eax
  801da1:	74 10                	je     801db3 <initialize_dyn_block_system+0x100>
  801da3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801da6:	8b 00                	mov    (%eax),%eax
  801da8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801dab:	8b 52 04             	mov    0x4(%edx),%edx
  801dae:	89 50 04             	mov    %edx,0x4(%eax)
  801db1:	eb 0b                	jmp    801dbe <initialize_dyn_block_system+0x10b>
  801db3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801db6:	8b 40 04             	mov    0x4(%eax),%eax
  801db9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801dbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dc1:	8b 40 04             	mov    0x4(%eax),%eax
  801dc4:	85 c0                	test   %eax,%eax
  801dc6:	74 0f                	je     801dd7 <initialize_dyn_block_system+0x124>
  801dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dcb:	8b 40 04             	mov    0x4(%eax),%eax
  801dce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801dd1:	8b 12                	mov    (%edx),%edx
  801dd3:	89 10                	mov    %edx,(%eax)
  801dd5:	eb 0a                	jmp    801de1 <initialize_dyn_block_system+0x12e>
  801dd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dda:	8b 00                	mov    (%eax),%eax
  801ddc:	a3 48 51 80 00       	mov    %eax,0x805148
  801de1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801de4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801dea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ded:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801df4:	a1 54 51 80 00       	mov    0x805154,%eax
  801df9:	48                   	dec    %eax
  801dfa:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e02:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801e09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e0c:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801e13:	83 ec 0c             	sub    $0xc,%esp
  801e16:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e19:	e8 d2 13 00 00       	call   8031f0 <insert_sorted_with_merge_freeList>
  801e1e:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801e21:	90                   	nop
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e2a:	e8 53 fe ff ff       	call   801c82 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e33:	75 07                	jne    801e3c <malloc+0x18>
  801e35:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3a:	eb 61                	jmp    801e9d <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801e3c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e43:	8b 55 08             	mov    0x8(%ebp),%edx
  801e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e49:	01 d0                	add    %edx,%eax
  801e4b:	48                   	dec    %eax
  801e4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e52:	ba 00 00 00 00       	mov    $0x0,%edx
  801e57:	f7 75 f4             	divl   -0xc(%ebp)
  801e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e5d:	29 d0                	sub    %edx,%eax
  801e5f:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801e62:	e8 3c 08 00 00       	call   8026a3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e67:	85 c0                	test   %eax,%eax
  801e69:	74 2d                	je     801e98 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801e6b:	83 ec 0c             	sub    $0xc,%esp
  801e6e:	ff 75 08             	pushl  0x8(%ebp)
  801e71:	e8 3e 0f 00 00       	call   802db4 <alloc_block_FF>
  801e76:	83 c4 10             	add    $0x10,%esp
  801e79:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801e7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e80:	74 16                	je     801e98 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801e82:	83 ec 0c             	sub    $0xc,%esp
  801e85:	ff 75 ec             	pushl  -0x14(%ebp)
  801e88:	e8 48 0c 00 00       	call   802ad5 <insert_sorted_allocList>
  801e8d:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801e90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e93:	8b 40 08             	mov    0x8(%eax),%eax
  801e96:	eb 05                	jmp    801e9d <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801e98:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801eb3:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb9:	83 ec 08             	sub    $0x8,%esp
  801ebc:	50                   	push   %eax
  801ebd:	68 40 50 80 00       	push   $0x805040
  801ec2:	e8 71 0b 00 00       	call   802a38 <find_block>
  801ec7:	83 c4 10             	add    $0x10,%esp
  801eca:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed0:	8b 50 0c             	mov    0xc(%eax),%edx
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	83 ec 08             	sub    $0x8,%esp
  801ed9:	52                   	push   %edx
  801eda:	50                   	push   %eax
  801edb:	e8 bd 03 00 00       	call   80229d <sys_free_user_mem>
  801ee0:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801ee3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ee7:	75 14                	jne    801efd <free+0x5e>
  801ee9:	83 ec 04             	sub    $0x4,%esp
  801eec:	68 75 42 80 00       	push   $0x804275
  801ef1:	6a 71                	push   $0x71
  801ef3:	68 93 42 80 00       	push   $0x804293
  801ef8:	e8 47 ed ff ff       	call   800c44 <_panic>
  801efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f00:	8b 00                	mov    (%eax),%eax
  801f02:	85 c0                	test   %eax,%eax
  801f04:	74 10                	je     801f16 <free+0x77>
  801f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f09:	8b 00                	mov    (%eax),%eax
  801f0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f0e:	8b 52 04             	mov    0x4(%edx),%edx
  801f11:	89 50 04             	mov    %edx,0x4(%eax)
  801f14:	eb 0b                	jmp    801f21 <free+0x82>
  801f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f19:	8b 40 04             	mov    0x4(%eax),%eax
  801f1c:	a3 44 50 80 00       	mov    %eax,0x805044
  801f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f24:	8b 40 04             	mov    0x4(%eax),%eax
  801f27:	85 c0                	test   %eax,%eax
  801f29:	74 0f                	je     801f3a <free+0x9b>
  801f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2e:	8b 40 04             	mov    0x4(%eax),%eax
  801f31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f34:	8b 12                	mov    (%edx),%edx
  801f36:	89 10                	mov    %edx,(%eax)
  801f38:	eb 0a                	jmp    801f44 <free+0xa5>
  801f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3d:	8b 00                	mov    (%eax),%eax
  801f3f:	a3 40 50 80 00       	mov    %eax,0x805040
  801f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f57:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801f5c:	48                   	dec    %eax
  801f5d:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801f62:	83 ec 0c             	sub    $0xc,%esp
  801f65:	ff 75 f0             	pushl  -0x10(%ebp)
  801f68:	e8 83 12 00 00       	call   8031f0 <insert_sorted_with_merge_freeList>
  801f6d:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801f70:	90                   	nop
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 28             	sub    $0x28,%esp
  801f79:	8b 45 10             	mov    0x10(%ebp),%eax
  801f7c:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f7f:	e8 fe fc ff ff       	call   801c82 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f88:	75 0a                	jne    801f94 <smalloc+0x21>
  801f8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8f:	e9 86 00 00 00       	jmp    80201a <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801f94:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801f9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa1:	01 d0                	add    %edx,%eax
  801fa3:	48                   	dec    %eax
  801fa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801faa:	ba 00 00 00 00       	mov    $0x0,%edx
  801faf:	f7 75 f4             	divl   -0xc(%ebp)
  801fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb5:	29 d0                	sub    %edx,%eax
  801fb7:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801fba:	e8 e4 06 00 00       	call   8026a3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801fbf:	85 c0                	test   %eax,%eax
  801fc1:	74 52                	je     802015 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801fc3:	83 ec 0c             	sub    $0xc,%esp
  801fc6:	ff 75 0c             	pushl  0xc(%ebp)
  801fc9:	e8 e6 0d 00 00       	call   802db4 <alloc_block_FF>
  801fce:	83 c4 10             	add    $0x10,%esp
  801fd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801fd4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fd8:	75 07                	jne    801fe1 <smalloc+0x6e>
			return NULL ;
  801fda:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdf:	eb 39                	jmp    80201a <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801fe1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe4:	8b 40 08             	mov    0x8(%eax),%eax
  801fe7:	89 c2                	mov    %eax,%edx
  801fe9:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801fed:	52                   	push   %edx
  801fee:	50                   	push   %eax
  801fef:	ff 75 0c             	pushl  0xc(%ebp)
  801ff2:	ff 75 08             	pushl  0x8(%ebp)
  801ff5:	e8 2e 04 00 00       	call   802428 <sys_createSharedObject>
  801ffa:	83 c4 10             	add    $0x10,%esp
  801ffd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  802000:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802004:	79 07                	jns    80200d <smalloc+0x9a>
			return (void*)NULL ;
  802006:	b8 00 00 00 00       	mov    $0x0,%eax
  80200b:	eb 0d                	jmp    80201a <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  80200d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802010:	8b 40 08             	mov    0x8(%eax),%eax
  802013:	eb 05                	jmp    80201a <smalloc+0xa7>
		}
		return (void*)NULL ;
  802015:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802022:	e8 5b fc ff ff       	call   801c82 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802027:	83 ec 08             	sub    $0x8,%esp
  80202a:	ff 75 0c             	pushl  0xc(%ebp)
  80202d:	ff 75 08             	pushl  0x8(%ebp)
  802030:	e8 1d 04 00 00       	call   802452 <sys_getSizeOfSharedObject>
  802035:	83 c4 10             	add    $0x10,%esp
  802038:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  80203b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203f:	75 0a                	jne    80204b <sget+0x2f>
			return NULL ;
  802041:	b8 00 00 00 00       	mov    $0x0,%eax
  802046:	e9 83 00 00 00       	jmp    8020ce <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  80204b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802052:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802055:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802058:	01 d0                	add    %edx,%eax
  80205a:	48                   	dec    %eax
  80205b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80205e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802061:	ba 00 00 00 00       	mov    $0x0,%edx
  802066:	f7 75 f0             	divl   -0x10(%ebp)
  802069:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80206c:	29 d0                	sub    %edx,%eax
  80206e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802071:	e8 2d 06 00 00       	call   8026a3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802076:	85 c0                	test   %eax,%eax
  802078:	74 4f                	je     8020c9 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  80207a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207d:	83 ec 0c             	sub    $0xc,%esp
  802080:	50                   	push   %eax
  802081:	e8 2e 0d 00 00       	call   802db4 <alloc_block_FF>
  802086:	83 c4 10             	add    $0x10,%esp
  802089:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  80208c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802090:	75 07                	jne    802099 <sget+0x7d>
					return (void*)NULL ;
  802092:	b8 00 00 00 00       	mov    $0x0,%eax
  802097:	eb 35                	jmp    8020ce <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  802099:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80209c:	8b 40 08             	mov    0x8(%eax),%eax
  80209f:	83 ec 04             	sub    $0x4,%esp
  8020a2:	50                   	push   %eax
  8020a3:	ff 75 0c             	pushl  0xc(%ebp)
  8020a6:	ff 75 08             	pushl  0x8(%ebp)
  8020a9:	e8 c1 03 00 00       	call   80246f <sys_getSharedObject>
  8020ae:	83 c4 10             	add    $0x10,%esp
  8020b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  8020b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8020b8:	79 07                	jns    8020c1 <sget+0xa5>
				return (void*)NULL ;
  8020ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bf:	eb 0d                	jmp    8020ce <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  8020c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020c4:	8b 40 08             	mov    0x8(%eax),%eax
  8020c7:	eb 05                	jmp    8020ce <sget+0xb2>


		}
	return (void*)NULL ;
  8020c9:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020d6:	e8 a7 fb ff ff       	call   801c82 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8020db:	83 ec 04             	sub    $0x4,%esp
  8020de:	68 a0 42 80 00       	push   $0x8042a0
  8020e3:	68 f9 00 00 00       	push   $0xf9
  8020e8:	68 93 42 80 00       	push   $0x804293
  8020ed:	e8 52 eb ff ff       	call   800c44 <_panic>

008020f2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8020f8:	83 ec 04             	sub    $0x4,%esp
  8020fb:	68 c8 42 80 00       	push   $0x8042c8
  802100:	68 0d 01 00 00       	push   $0x10d
  802105:	68 93 42 80 00       	push   $0x804293
  80210a:	e8 35 eb ff ff       	call   800c44 <_panic>

0080210f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802115:	83 ec 04             	sub    $0x4,%esp
  802118:	68 ec 42 80 00       	push   $0x8042ec
  80211d:	68 18 01 00 00       	push   $0x118
  802122:	68 93 42 80 00       	push   $0x804293
  802127:	e8 18 eb ff ff       	call   800c44 <_panic>

0080212c <shrink>:

}
void shrink(uint32 newSize)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
  80212f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802132:	83 ec 04             	sub    $0x4,%esp
  802135:	68 ec 42 80 00       	push   $0x8042ec
  80213a:	68 1d 01 00 00       	push   $0x11d
  80213f:	68 93 42 80 00       	push   $0x804293
  802144:	e8 fb ea ff ff       	call   800c44 <_panic>

00802149 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80214f:	83 ec 04             	sub    $0x4,%esp
  802152:	68 ec 42 80 00       	push   $0x8042ec
  802157:	68 22 01 00 00       	push   $0x122
  80215c:	68 93 42 80 00       	push   $0x804293
  802161:	e8 de ea ff ff       	call   800c44 <_panic>

00802166 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	57                   	push   %edi
  80216a:	56                   	push   %esi
  80216b:	53                   	push   %ebx
  80216c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
  802172:	8b 55 0c             	mov    0xc(%ebp),%edx
  802175:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802178:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80217b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80217e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802181:	cd 30                	int    $0x30
  802183:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802186:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802189:	83 c4 10             	add    $0x10,%esp
  80218c:	5b                   	pop    %ebx
  80218d:	5e                   	pop    %esi
  80218e:	5f                   	pop    %edi
  80218f:	5d                   	pop    %ebp
  802190:	c3                   	ret    

00802191 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
  802194:	83 ec 04             	sub    $0x4,%esp
  802197:	8b 45 10             	mov    0x10(%ebp),%eax
  80219a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80219d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	52                   	push   %edx
  8021a9:	ff 75 0c             	pushl  0xc(%ebp)
  8021ac:	50                   	push   %eax
  8021ad:	6a 00                	push   $0x0
  8021af:	e8 b2 ff ff ff       	call   802166 <syscall>
  8021b4:	83 c4 18             	add    $0x18,%esp
}
  8021b7:	90                   	nop
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <sys_cgetc>:

int
sys_cgetc(void)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 01                	push   $0x1
  8021c9:	e8 98 ff ff ff       	call   802166 <syscall>
  8021ce:	83 c4 18             	add    $0x18,%esp
}
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8021d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	52                   	push   %edx
  8021e3:	50                   	push   %eax
  8021e4:	6a 05                	push   $0x5
  8021e6:	e8 7b ff ff ff       	call   802166 <syscall>
  8021eb:	83 c4 18             	add    $0x18,%esp
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	56                   	push   %esi
  8021f4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021f5:	8b 75 18             	mov    0x18(%ebp),%esi
  8021f8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	56                   	push   %esi
  802205:	53                   	push   %ebx
  802206:	51                   	push   %ecx
  802207:	52                   	push   %edx
  802208:	50                   	push   %eax
  802209:	6a 06                	push   $0x6
  80220b:	e8 56 ff ff ff       	call   802166 <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
}
  802213:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802216:	5b                   	pop    %ebx
  802217:	5e                   	pop    %esi
  802218:	5d                   	pop    %ebp
  802219:	c3                   	ret    

0080221a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80221d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	52                   	push   %edx
  80222a:	50                   	push   %eax
  80222b:	6a 07                	push   $0x7
  80222d:	e8 34 ff ff ff       	call   802166 <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
}
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	ff 75 0c             	pushl  0xc(%ebp)
  802243:	ff 75 08             	pushl  0x8(%ebp)
  802246:	6a 08                	push   $0x8
  802248:	e8 19 ff ff ff       	call   802166 <syscall>
  80224d:	83 c4 18             	add    $0x18,%esp
}
  802250:	c9                   	leave  
  802251:	c3                   	ret    

00802252 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 09                	push   $0x9
  802261:	e8 00 ff ff ff       	call   802166 <syscall>
  802266:	83 c4 18             	add    $0x18,%esp
}
  802269:	c9                   	leave  
  80226a:	c3                   	ret    

0080226b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80226b:	55                   	push   %ebp
  80226c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 0a                	push   $0xa
  80227a:	e8 e7 fe ff ff       	call   802166 <syscall>
  80227f:	83 c4 18             	add    $0x18,%esp
}
  802282:	c9                   	leave  
  802283:	c3                   	ret    

00802284 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 0b                	push   $0xb
  802293:	e8 ce fe ff ff       	call   802166 <syscall>
  802298:	83 c4 18             	add    $0x18,%esp
}
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	ff 75 0c             	pushl  0xc(%ebp)
  8022a9:	ff 75 08             	pushl  0x8(%ebp)
  8022ac:	6a 0f                	push   $0xf
  8022ae:	e8 b3 fe ff ff       	call   802166 <syscall>
  8022b3:	83 c4 18             	add    $0x18,%esp
	return;
  8022b6:	90                   	nop
}
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	ff 75 0c             	pushl  0xc(%ebp)
  8022c5:	ff 75 08             	pushl  0x8(%ebp)
  8022c8:	6a 10                	push   $0x10
  8022ca:	e8 97 fe ff ff       	call   802166 <syscall>
  8022cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d2:	90                   	nop
}
  8022d3:	c9                   	leave  
  8022d4:	c3                   	ret    

008022d5 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	ff 75 10             	pushl  0x10(%ebp)
  8022df:	ff 75 0c             	pushl  0xc(%ebp)
  8022e2:	ff 75 08             	pushl  0x8(%ebp)
  8022e5:	6a 11                	push   $0x11
  8022e7:	e8 7a fe ff ff       	call   802166 <syscall>
  8022ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ef:	90                   	nop
}
  8022f0:	c9                   	leave  
  8022f1:	c3                   	ret    

008022f2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 0c                	push   $0xc
  802301:	e8 60 fe ff ff       	call   802166 <syscall>
  802306:	83 c4 18             	add    $0x18,%esp
}
  802309:	c9                   	leave  
  80230a:	c3                   	ret    

0080230b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80230b:	55                   	push   %ebp
  80230c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	ff 75 08             	pushl  0x8(%ebp)
  802319:	6a 0d                	push   $0xd
  80231b:	e8 46 fe ff ff       	call   802166 <syscall>
  802320:	83 c4 18             	add    $0x18,%esp
}
  802323:	c9                   	leave  
  802324:	c3                   	ret    

00802325 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	6a 0e                	push   $0xe
  802334:	e8 2d fe ff ff       	call   802166 <syscall>
  802339:	83 c4 18             	add    $0x18,%esp
}
  80233c:	90                   	nop
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 13                	push   $0x13
  80234e:	e8 13 fe ff ff       	call   802166 <syscall>
  802353:	83 c4 18             	add    $0x18,%esp
}
  802356:	90                   	nop
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 14                	push   $0x14
  802368:	e8 f9 fd ff ff       	call   802166 <syscall>
  80236d:	83 c4 18             	add    $0x18,%esp
}
  802370:	90                   	nop
  802371:	c9                   	leave  
  802372:	c3                   	ret    

00802373 <sys_cputc>:


void
sys_cputc(const char c)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	83 ec 04             	sub    $0x4,%esp
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80237f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	50                   	push   %eax
  80238c:	6a 15                	push   $0x15
  80238e:	e8 d3 fd ff ff       	call   802166 <syscall>
  802393:	83 c4 18             	add    $0x18,%esp
}
  802396:	90                   	nop
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 16                	push   $0x16
  8023a8:	e8 b9 fd ff ff       	call   802166 <syscall>
  8023ad:	83 c4 18             	add    $0x18,%esp
}
  8023b0:	90                   	nop
  8023b1:	c9                   	leave  
  8023b2:	c3                   	ret    

008023b3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	ff 75 0c             	pushl  0xc(%ebp)
  8023c2:	50                   	push   %eax
  8023c3:	6a 17                	push   $0x17
  8023c5:	e8 9c fd ff ff       	call   802166 <syscall>
  8023ca:	83 c4 18             	add    $0x18,%esp
}
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	52                   	push   %edx
  8023df:	50                   	push   %eax
  8023e0:	6a 1a                	push   $0x1a
  8023e2:	e8 7f fd ff ff       	call   802166 <syscall>
  8023e7:	83 c4 18             	add    $0x18,%esp
}
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	52                   	push   %edx
  8023fc:	50                   	push   %eax
  8023fd:	6a 18                	push   $0x18
  8023ff:	e8 62 fd ff ff       	call   802166 <syscall>
  802404:	83 c4 18             	add    $0x18,%esp
}
  802407:	90                   	nop
  802408:	c9                   	leave  
  802409:	c3                   	ret    

0080240a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80240a:	55                   	push   %ebp
  80240b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80240d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802410:	8b 45 08             	mov    0x8(%ebp),%eax
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	52                   	push   %edx
  80241a:	50                   	push   %eax
  80241b:	6a 19                	push   $0x19
  80241d:	e8 44 fd ff ff       	call   802166 <syscall>
  802422:	83 c4 18             	add    $0x18,%esp
}
  802425:	90                   	nop
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	83 ec 04             	sub    $0x4,%esp
  80242e:	8b 45 10             	mov    0x10(%ebp),%eax
  802431:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802434:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802437:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	6a 00                	push   $0x0
  802440:	51                   	push   %ecx
  802441:	52                   	push   %edx
  802442:	ff 75 0c             	pushl  0xc(%ebp)
  802445:	50                   	push   %eax
  802446:	6a 1b                	push   $0x1b
  802448:	e8 19 fd ff ff       	call   802166 <syscall>
  80244d:	83 c4 18             	add    $0x18,%esp
}
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802455:	8b 55 0c             	mov    0xc(%ebp),%edx
  802458:	8b 45 08             	mov    0x8(%ebp),%eax
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	52                   	push   %edx
  802462:	50                   	push   %eax
  802463:	6a 1c                	push   $0x1c
  802465:	e8 fc fc ff ff       	call   802166 <syscall>
  80246a:	83 c4 18             	add    $0x18,%esp
}
  80246d:	c9                   	leave  
  80246e:	c3                   	ret    

0080246f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80246f:	55                   	push   %ebp
  802470:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802472:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802475:	8b 55 0c             	mov    0xc(%ebp),%edx
  802478:	8b 45 08             	mov    0x8(%ebp),%eax
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	51                   	push   %ecx
  802480:	52                   	push   %edx
  802481:	50                   	push   %eax
  802482:	6a 1d                	push   $0x1d
  802484:	e8 dd fc ff ff       	call   802166 <syscall>
  802489:	83 c4 18             	add    $0x18,%esp
}
  80248c:	c9                   	leave  
  80248d:	c3                   	ret    

0080248e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802491:	8b 55 0c             	mov    0xc(%ebp),%edx
  802494:	8b 45 08             	mov    0x8(%ebp),%eax
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	52                   	push   %edx
  80249e:	50                   	push   %eax
  80249f:	6a 1e                	push   $0x1e
  8024a1:	e8 c0 fc ff ff       	call   802166 <syscall>
  8024a6:	83 c4 18             	add    $0x18,%esp
}
  8024a9:	c9                   	leave  
  8024aa:	c3                   	ret    

008024ab <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 1f                	push   $0x1f
  8024ba:	e8 a7 fc ff ff       	call   802166 <syscall>
  8024bf:	83 c4 18             	add    $0x18,%esp
}
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8024c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ca:	6a 00                	push   $0x0
  8024cc:	ff 75 14             	pushl  0x14(%ebp)
  8024cf:	ff 75 10             	pushl  0x10(%ebp)
  8024d2:	ff 75 0c             	pushl  0xc(%ebp)
  8024d5:	50                   	push   %eax
  8024d6:	6a 20                	push   $0x20
  8024d8:	e8 89 fc ff ff       	call   802166 <syscall>
  8024dd:	83 c4 18             	add    $0x18,%esp
}
  8024e0:	c9                   	leave  
  8024e1:	c3                   	ret    

008024e2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8024e2:	55                   	push   %ebp
  8024e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8024e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	50                   	push   %eax
  8024f1:	6a 21                	push   $0x21
  8024f3:	e8 6e fc ff ff       	call   802166 <syscall>
  8024f8:	83 c4 18             	add    $0x18,%esp
}
  8024fb:	90                   	nop
  8024fc:	c9                   	leave  
  8024fd:	c3                   	ret    

008024fe <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802501:	8b 45 08             	mov    0x8(%ebp),%eax
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	50                   	push   %eax
  80250d:	6a 22                	push   $0x22
  80250f:	e8 52 fc ff ff       	call   802166 <syscall>
  802514:	83 c4 18             	add    $0x18,%esp
}
  802517:	c9                   	leave  
  802518:	c3                   	ret    

00802519 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802519:	55                   	push   %ebp
  80251a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	6a 02                	push   $0x2
  802528:	e8 39 fc ff ff       	call   802166 <syscall>
  80252d:	83 c4 18             	add    $0x18,%esp
}
  802530:	c9                   	leave  
  802531:	c3                   	ret    

00802532 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 03                	push   $0x3
  802541:	e8 20 fc ff ff       	call   802166 <syscall>
  802546:	83 c4 18             	add    $0x18,%esp
}
  802549:	c9                   	leave  
  80254a:	c3                   	ret    

0080254b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80254b:	55                   	push   %ebp
  80254c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	6a 04                	push   $0x4
  80255a:	e8 07 fc ff ff       	call   802166 <syscall>
  80255f:	83 c4 18             	add    $0x18,%esp
}
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <sys_exit_env>:


void sys_exit_env(void)
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	6a 00                	push   $0x0
  80256f:	6a 00                	push   $0x0
  802571:	6a 23                	push   $0x23
  802573:	e8 ee fb ff ff       	call   802166 <syscall>
  802578:	83 c4 18             	add    $0x18,%esp
}
  80257b:	90                   	nop
  80257c:	c9                   	leave  
  80257d:	c3                   	ret    

0080257e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80257e:	55                   	push   %ebp
  80257f:	89 e5                	mov    %esp,%ebp
  802581:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802584:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802587:	8d 50 04             	lea    0x4(%eax),%edx
  80258a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80258d:	6a 00                	push   $0x0
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	52                   	push   %edx
  802594:	50                   	push   %eax
  802595:	6a 24                	push   $0x24
  802597:	e8 ca fb ff ff       	call   802166 <syscall>
  80259c:	83 c4 18             	add    $0x18,%esp
	return result;
  80259f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025a8:	89 01                	mov    %eax,(%ecx)
  8025aa:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8025ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b0:	c9                   	leave  
  8025b1:	c2 04 00             	ret    $0x4

008025b4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8025b4:	55                   	push   %ebp
  8025b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	ff 75 10             	pushl  0x10(%ebp)
  8025be:	ff 75 0c             	pushl  0xc(%ebp)
  8025c1:	ff 75 08             	pushl  0x8(%ebp)
  8025c4:	6a 12                	push   $0x12
  8025c6:	e8 9b fb ff ff       	call   802166 <syscall>
  8025cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ce:	90                   	nop
}
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    

008025d1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 25                	push   $0x25
  8025e0:	e8 81 fb ff ff       	call   802166 <syscall>
  8025e5:	83 c4 18             	add    $0x18,%esp
}
  8025e8:	c9                   	leave  
  8025e9:	c3                   	ret    

008025ea <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
  8025ed:	83 ec 04             	sub    $0x4,%esp
  8025f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025f6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	50                   	push   %eax
  802603:	6a 26                	push   $0x26
  802605:	e8 5c fb ff ff       	call   802166 <syscall>
  80260a:	83 c4 18             	add    $0x18,%esp
	return ;
  80260d:	90                   	nop
}
  80260e:	c9                   	leave  
  80260f:	c3                   	ret    

00802610 <rsttst>:
void rsttst()
{
  802610:	55                   	push   %ebp
  802611:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802613:	6a 00                	push   $0x0
  802615:	6a 00                	push   $0x0
  802617:	6a 00                	push   $0x0
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 28                	push   $0x28
  80261f:	e8 42 fb ff ff       	call   802166 <syscall>
  802624:	83 c4 18             	add    $0x18,%esp
	return ;
  802627:	90                   	nop
}
  802628:	c9                   	leave  
  802629:	c3                   	ret    

0080262a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80262a:	55                   	push   %ebp
  80262b:	89 e5                	mov    %esp,%ebp
  80262d:	83 ec 04             	sub    $0x4,%esp
  802630:	8b 45 14             	mov    0x14(%ebp),%eax
  802633:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802636:	8b 55 18             	mov    0x18(%ebp),%edx
  802639:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80263d:	52                   	push   %edx
  80263e:	50                   	push   %eax
  80263f:	ff 75 10             	pushl  0x10(%ebp)
  802642:	ff 75 0c             	pushl  0xc(%ebp)
  802645:	ff 75 08             	pushl  0x8(%ebp)
  802648:	6a 27                	push   $0x27
  80264a:	e8 17 fb ff ff       	call   802166 <syscall>
  80264f:	83 c4 18             	add    $0x18,%esp
	return ;
  802652:	90                   	nop
}
  802653:	c9                   	leave  
  802654:	c3                   	ret    

00802655 <chktst>:
void chktst(uint32 n)
{
  802655:	55                   	push   %ebp
  802656:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	ff 75 08             	pushl  0x8(%ebp)
  802663:	6a 29                	push   $0x29
  802665:	e8 fc fa ff ff       	call   802166 <syscall>
  80266a:	83 c4 18             	add    $0x18,%esp
	return ;
  80266d:	90                   	nop
}
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <inctst>:

void inctst()
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 2a                	push   $0x2a
  80267f:	e8 e2 fa ff ff       	call   802166 <syscall>
  802684:	83 c4 18             	add    $0x18,%esp
	return ;
  802687:	90                   	nop
}
  802688:	c9                   	leave  
  802689:	c3                   	ret    

0080268a <gettst>:
uint32 gettst()
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	6a 00                	push   $0x0
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	6a 2b                	push   $0x2b
  802699:	e8 c8 fa ff ff       	call   802166 <syscall>
  80269e:	83 c4 18             	add    $0x18,%esp
}
  8026a1:	c9                   	leave  
  8026a2:	c3                   	ret    

008026a3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8026a3:	55                   	push   %ebp
  8026a4:	89 e5                	mov    %esp,%ebp
  8026a6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 00                	push   $0x0
  8026b3:	6a 2c                	push   $0x2c
  8026b5:	e8 ac fa ff ff       	call   802166 <syscall>
  8026ba:	83 c4 18             	add    $0x18,%esp
  8026bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8026c0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8026c4:	75 07                	jne    8026cd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8026c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026cb:	eb 05                	jmp    8026d2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8026cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d2:	c9                   	leave  
  8026d3:	c3                   	ret    

008026d4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
  8026d7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 00                	push   $0x0
  8026e2:	6a 00                	push   $0x0
  8026e4:	6a 2c                	push   $0x2c
  8026e6:	e8 7b fa ff ff       	call   802166 <syscall>
  8026eb:	83 c4 18             	add    $0x18,%esp
  8026ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8026f1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8026f5:	75 07                	jne    8026fe <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8026f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8026fc:	eb 05                	jmp    802703 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802703:	c9                   	leave  
  802704:	c3                   	ret    

00802705 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802705:	55                   	push   %ebp
  802706:	89 e5                	mov    %esp,%ebp
  802708:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80270b:	6a 00                	push   $0x0
  80270d:	6a 00                	push   $0x0
  80270f:	6a 00                	push   $0x0
  802711:	6a 00                	push   $0x0
  802713:	6a 00                	push   $0x0
  802715:	6a 2c                	push   $0x2c
  802717:	e8 4a fa ff ff       	call   802166 <syscall>
  80271c:	83 c4 18             	add    $0x18,%esp
  80271f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802722:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802726:	75 07                	jne    80272f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802728:	b8 01 00 00 00       	mov    $0x1,%eax
  80272d:	eb 05                	jmp    802734 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80272f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802734:	c9                   	leave  
  802735:	c3                   	ret    

00802736 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
  802739:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80273c:	6a 00                	push   $0x0
  80273e:	6a 00                	push   $0x0
  802740:	6a 00                	push   $0x0
  802742:	6a 00                	push   $0x0
  802744:	6a 00                	push   $0x0
  802746:	6a 2c                	push   $0x2c
  802748:	e8 19 fa ff ff       	call   802166 <syscall>
  80274d:	83 c4 18             	add    $0x18,%esp
  802750:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802753:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802757:	75 07                	jne    802760 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802759:	b8 01 00 00 00       	mov    $0x1,%eax
  80275e:	eb 05                	jmp    802765 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802760:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802765:	c9                   	leave  
  802766:	c3                   	ret    

00802767 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802767:	55                   	push   %ebp
  802768:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80276a:	6a 00                	push   $0x0
  80276c:	6a 00                	push   $0x0
  80276e:	6a 00                	push   $0x0
  802770:	6a 00                	push   $0x0
  802772:	ff 75 08             	pushl  0x8(%ebp)
  802775:	6a 2d                	push   $0x2d
  802777:	e8 ea f9 ff ff       	call   802166 <syscall>
  80277c:	83 c4 18             	add    $0x18,%esp
	return ;
  80277f:	90                   	nop
}
  802780:	c9                   	leave  
  802781:	c3                   	ret    

00802782 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802782:	55                   	push   %ebp
  802783:	89 e5                	mov    %esp,%ebp
  802785:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802786:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802789:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80278c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80278f:	8b 45 08             	mov    0x8(%ebp),%eax
  802792:	6a 00                	push   $0x0
  802794:	53                   	push   %ebx
  802795:	51                   	push   %ecx
  802796:	52                   	push   %edx
  802797:	50                   	push   %eax
  802798:	6a 2e                	push   $0x2e
  80279a:	e8 c7 f9 ff ff       	call   802166 <syscall>
  80279f:	83 c4 18             	add    $0x18,%esp
}
  8027a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027a5:	c9                   	leave  
  8027a6:	c3                   	ret    

008027a7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8027a7:	55                   	push   %ebp
  8027a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8027aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b0:	6a 00                	push   $0x0
  8027b2:	6a 00                	push   $0x0
  8027b4:	6a 00                	push   $0x0
  8027b6:	52                   	push   %edx
  8027b7:	50                   	push   %eax
  8027b8:	6a 2f                	push   $0x2f
  8027ba:	e8 a7 f9 ff ff       	call   802166 <syscall>
  8027bf:	83 c4 18             	add    $0x18,%esp
}
  8027c2:	c9                   	leave  
  8027c3:	c3                   	ret    

008027c4 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
  8027c7:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8027ca:	83 ec 0c             	sub    $0xc,%esp
  8027cd:	68 fc 42 80 00       	push   $0x8042fc
  8027d2:	e8 21 e7 ff ff       	call   800ef8 <cprintf>
  8027d7:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8027da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8027e1:	83 ec 0c             	sub    $0xc,%esp
  8027e4:	68 28 43 80 00       	push   $0x804328
  8027e9:	e8 0a e7 ff ff       	call   800ef8 <cprintf>
  8027ee:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8027f1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027f5:	a1 38 51 80 00       	mov    0x805138,%eax
  8027fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027fd:	eb 56                	jmp    802855 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802803:	74 1c                	je     802821 <print_mem_block_lists+0x5d>
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	8b 50 08             	mov    0x8(%eax),%edx
  80280b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280e:	8b 48 08             	mov    0x8(%eax),%ecx
  802811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802814:	8b 40 0c             	mov    0xc(%eax),%eax
  802817:	01 c8                	add    %ecx,%eax
  802819:	39 c2                	cmp    %eax,%edx
  80281b:	73 04                	jae    802821 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80281d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	8b 50 08             	mov    0x8(%eax),%edx
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	8b 40 0c             	mov    0xc(%eax),%eax
  80282d:	01 c2                	add    %eax,%edx
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	8b 40 08             	mov    0x8(%eax),%eax
  802835:	83 ec 04             	sub    $0x4,%esp
  802838:	52                   	push   %edx
  802839:	50                   	push   %eax
  80283a:	68 3d 43 80 00       	push   $0x80433d
  80283f:	e8 b4 e6 ff ff       	call   800ef8 <cprintf>
  802844:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80284d:	a1 40 51 80 00       	mov    0x805140,%eax
  802852:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802855:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802859:	74 07                	je     802862 <print_mem_block_lists+0x9e>
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	eb 05                	jmp    802867 <print_mem_block_lists+0xa3>
  802862:	b8 00 00 00 00       	mov    $0x0,%eax
  802867:	a3 40 51 80 00       	mov    %eax,0x805140
  80286c:	a1 40 51 80 00       	mov    0x805140,%eax
  802871:	85 c0                	test   %eax,%eax
  802873:	75 8a                	jne    8027ff <print_mem_block_lists+0x3b>
  802875:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802879:	75 84                	jne    8027ff <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80287b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80287f:	75 10                	jne    802891 <print_mem_block_lists+0xcd>
  802881:	83 ec 0c             	sub    $0xc,%esp
  802884:	68 4c 43 80 00       	push   $0x80434c
  802889:	e8 6a e6 ff ff       	call   800ef8 <cprintf>
  80288e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802891:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802898:	83 ec 0c             	sub    $0xc,%esp
  80289b:	68 70 43 80 00       	push   $0x804370
  8028a0:	e8 53 e6 ff ff       	call   800ef8 <cprintf>
  8028a5:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8028a8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8028ac:	a1 40 50 80 00       	mov    0x805040,%eax
  8028b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b4:	eb 56                	jmp    80290c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8028b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ba:	74 1c                	je     8028d8 <print_mem_block_lists+0x114>
  8028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bf:	8b 50 08             	mov    0x8(%eax),%edx
  8028c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c5:	8b 48 08             	mov    0x8(%eax),%ecx
  8028c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ce:	01 c8                	add    %ecx,%eax
  8028d0:	39 c2                	cmp    %eax,%edx
  8028d2:	73 04                	jae    8028d8 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8028d4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 50 08             	mov    0x8(%eax),%edx
  8028de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e4:	01 c2                	add    %eax,%edx
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	8b 40 08             	mov    0x8(%eax),%eax
  8028ec:	83 ec 04             	sub    $0x4,%esp
  8028ef:	52                   	push   %edx
  8028f0:	50                   	push   %eax
  8028f1:	68 3d 43 80 00       	push   $0x80433d
  8028f6:	e8 fd e5 ff ff       	call   800ef8 <cprintf>
  8028fb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802904:	a1 48 50 80 00       	mov    0x805048,%eax
  802909:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80290c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802910:	74 07                	je     802919 <print_mem_block_lists+0x155>
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 00                	mov    (%eax),%eax
  802917:	eb 05                	jmp    80291e <print_mem_block_lists+0x15a>
  802919:	b8 00 00 00 00       	mov    $0x0,%eax
  80291e:	a3 48 50 80 00       	mov    %eax,0x805048
  802923:	a1 48 50 80 00       	mov    0x805048,%eax
  802928:	85 c0                	test   %eax,%eax
  80292a:	75 8a                	jne    8028b6 <print_mem_block_lists+0xf2>
  80292c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802930:	75 84                	jne    8028b6 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802932:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802936:	75 10                	jne    802948 <print_mem_block_lists+0x184>
  802938:	83 ec 0c             	sub    $0xc,%esp
  80293b:	68 88 43 80 00       	push   $0x804388
  802940:	e8 b3 e5 ff ff       	call   800ef8 <cprintf>
  802945:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802948:	83 ec 0c             	sub    $0xc,%esp
  80294b:	68 fc 42 80 00       	push   $0x8042fc
  802950:	e8 a3 e5 ff ff       	call   800ef8 <cprintf>
  802955:	83 c4 10             	add    $0x10,%esp

}
  802958:	90                   	nop
  802959:	c9                   	leave  
  80295a:	c3                   	ret    

0080295b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80295b:	55                   	push   %ebp
  80295c:	89 e5                	mov    %esp,%ebp
  80295e:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802961:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802968:	00 00 00 
  80296b:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802972:	00 00 00 
  802975:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80297c:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80297f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802986:	e9 9e 00 00 00       	jmp    802a29 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  80298b:	a1 50 50 80 00       	mov    0x805050,%eax
  802990:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802993:	c1 e2 04             	shl    $0x4,%edx
  802996:	01 d0                	add    %edx,%eax
  802998:	85 c0                	test   %eax,%eax
  80299a:	75 14                	jne    8029b0 <initialize_MemBlocksList+0x55>
  80299c:	83 ec 04             	sub    $0x4,%esp
  80299f:	68 b0 43 80 00       	push   $0x8043b0
  8029a4:	6a 43                	push   $0x43
  8029a6:	68 d3 43 80 00       	push   $0x8043d3
  8029ab:	e8 94 e2 ff ff       	call   800c44 <_panic>
  8029b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8029b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b8:	c1 e2 04             	shl    $0x4,%edx
  8029bb:	01 d0                	add    %edx,%eax
  8029bd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8029c3:	89 10                	mov    %edx,(%eax)
  8029c5:	8b 00                	mov    (%eax),%eax
  8029c7:	85 c0                	test   %eax,%eax
  8029c9:	74 18                	je     8029e3 <initialize_MemBlocksList+0x88>
  8029cb:	a1 48 51 80 00       	mov    0x805148,%eax
  8029d0:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8029d6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8029d9:	c1 e1 04             	shl    $0x4,%ecx
  8029dc:	01 ca                	add    %ecx,%edx
  8029de:	89 50 04             	mov    %edx,0x4(%eax)
  8029e1:	eb 12                	jmp    8029f5 <initialize_MemBlocksList+0x9a>
  8029e3:	a1 50 50 80 00       	mov    0x805050,%eax
  8029e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029eb:	c1 e2 04             	shl    $0x4,%edx
  8029ee:	01 d0                	add    %edx,%eax
  8029f0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029f5:	a1 50 50 80 00       	mov    0x805050,%eax
  8029fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029fd:	c1 e2 04             	shl    $0x4,%edx
  802a00:	01 d0                	add    %edx,%eax
  802a02:	a3 48 51 80 00       	mov    %eax,0x805148
  802a07:	a1 50 50 80 00       	mov    0x805050,%eax
  802a0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0f:	c1 e2 04             	shl    $0x4,%edx
  802a12:	01 d0                	add    %edx,%eax
  802a14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1b:	a1 54 51 80 00       	mov    0x805154,%eax
  802a20:	40                   	inc    %eax
  802a21:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802a26:	ff 45 f4             	incl   -0xc(%ebp)
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a2f:	0f 82 56 ff ff ff    	jb     80298b <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802a35:	90                   	nop
  802a36:	c9                   	leave  
  802a37:	c3                   	ret    

00802a38 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802a38:	55                   	push   %ebp
  802a39:	89 e5                	mov    %esp,%ebp
  802a3b:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802a3e:	a1 38 51 80 00       	mov    0x805138,%eax
  802a43:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a46:	eb 18                	jmp    802a60 <find_block+0x28>
	{
		if (ele->sva==va)
  802a48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a4b:	8b 40 08             	mov    0x8(%eax),%eax
  802a4e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a51:	75 05                	jne    802a58 <find_block+0x20>
			return ele;
  802a53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a56:	eb 7b                	jmp    802ad3 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802a58:	a1 40 51 80 00       	mov    0x805140,%eax
  802a5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a60:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a64:	74 07                	je     802a6d <find_block+0x35>
  802a66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a69:	8b 00                	mov    (%eax),%eax
  802a6b:	eb 05                	jmp    802a72 <find_block+0x3a>
  802a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a72:	a3 40 51 80 00       	mov    %eax,0x805140
  802a77:	a1 40 51 80 00       	mov    0x805140,%eax
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	75 c8                	jne    802a48 <find_block+0x10>
  802a80:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a84:	75 c2                	jne    802a48 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802a86:	a1 40 50 80 00       	mov    0x805040,%eax
  802a8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a8e:	eb 18                	jmp    802aa8 <find_block+0x70>
	{
		if (ele->sva==va)
  802a90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a93:	8b 40 08             	mov    0x8(%eax),%eax
  802a96:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a99:	75 05                	jne    802aa0 <find_block+0x68>
					return ele;
  802a9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a9e:	eb 33                	jmp    802ad3 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802aa0:	a1 48 50 80 00       	mov    0x805048,%eax
  802aa5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802aa8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802aac:	74 07                	je     802ab5 <find_block+0x7d>
  802aae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ab1:	8b 00                	mov    (%eax),%eax
  802ab3:	eb 05                	jmp    802aba <find_block+0x82>
  802ab5:	b8 00 00 00 00       	mov    $0x0,%eax
  802aba:	a3 48 50 80 00       	mov    %eax,0x805048
  802abf:	a1 48 50 80 00       	mov    0x805048,%eax
  802ac4:	85 c0                	test   %eax,%eax
  802ac6:	75 c8                	jne    802a90 <find_block+0x58>
  802ac8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802acc:	75 c2                	jne    802a90 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802ace:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802ad3:	c9                   	leave  
  802ad4:	c3                   	ret    

00802ad5 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802ad5:	55                   	push   %ebp
  802ad6:	89 e5                	mov    %esp,%ebp
  802ad8:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802adb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802ae3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ae7:	75 62                	jne    802b4b <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802ae9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aed:	75 14                	jne    802b03 <insert_sorted_allocList+0x2e>
  802aef:	83 ec 04             	sub    $0x4,%esp
  802af2:	68 b0 43 80 00       	push   $0x8043b0
  802af7:	6a 69                	push   $0x69
  802af9:	68 d3 43 80 00       	push   $0x8043d3
  802afe:	e8 41 e1 ff ff       	call   800c44 <_panic>
  802b03:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	89 10                	mov    %edx,(%eax)
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	8b 00                	mov    (%eax),%eax
  802b13:	85 c0                	test   %eax,%eax
  802b15:	74 0d                	je     802b24 <insert_sorted_allocList+0x4f>
  802b17:	a1 40 50 80 00       	mov    0x805040,%eax
  802b1c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1f:	89 50 04             	mov    %edx,0x4(%eax)
  802b22:	eb 08                	jmp    802b2c <insert_sorted_allocList+0x57>
  802b24:	8b 45 08             	mov    0x8(%ebp),%eax
  802b27:	a3 44 50 80 00       	mov    %eax,0x805044
  802b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2f:	a3 40 50 80 00       	mov    %eax,0x805040
  802b34:	8b 45 08             	mov    0x8(%ebp),%eax
  802b37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b43:	40                   	inc    %eax
  802b44:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802b49:	eb 72                	jmp    802bbd <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802b4b:	a1 40 50 80 00       	mov    0x805040,%eax
  802b50:	8b 50 08             	mov    0x8(%eax),%edx
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	8b 40 08             	mov    0x8(%eax),%eax
  802b59:	39 c2                	cmp    %eax,%edx
  802b5b:	76 60                	jbe    802bbd <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802b5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b61:	75 14                	jne    802b77 <insert_sorted_allocList+0xa2>
  802b63:	83 ec 04             	sub    $0x4,%esp
  802b66:	68 b0 43 80 00       	push   $0x8043b0
  802b6b:	6a 6d                	push   $0x6d
  802b6d:	68 d3 43 80 00       	push   $0x8043d3
  802b72:	e8 cd e0 ff ff       	call   800c44 <_panic>
  802b77:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	89 10                	mov    %edx,(%eax)
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	85 c0                	test   %eax,%eax
  802b89:	74 0d                	je     802b98 <insert_sorted_allocList+0xc3>
  802b8b:	a1 40 50 80 00       	mov    0x805040,%eax
  802b90:	8b 55 08             	mov    0x8(%ebp),%edx
  802b93:	89 50 04             	mov    %edx,0x4(%eax)
  802b96:	eb 08                	jmp    802ba0 <insert_sorted_allocList+0xcb>
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	a3 44 50 80 00       	mov    %eax,0x805044
  802ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba3:	a3 40 50 80 00       	mov    %eax,0x805040
  802ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bb7:	40                   	inc    %eax
  802bb8:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802bbd:	a1 40 50 80 00       	mov    0x805040,%eax
  802bc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc5:	e9 b9 01 00 00       	jmp    802d83 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802bca:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcd:	8b 50 08             	mov    0x8(%eax),%edx
  802bd0:	a1 40 50 80 00       	mov    0x805040,%eax
  802bd5:	8b 40 08             	mov    0x8(%eax),%eax
  802bd8:	39 c2                	cmp    %eax,%edx
  802bda:	76 7c                	jbe    802c58 <insert_sorted_allocList+0x183>
  802bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdf:	8b 50 08             	mov    0x8(%eax),%edx
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	8b 40 08             	mov    0x8(%eax),%eax
  802be8:	39 c2                	cmp    %eax,%edx
  802bea:	73 6c                	jae    802c58 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802bec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf0:	74 06                	je     802bf8 <insert_sorted_allocList+0x123>
  802bf2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf6:	75 14                	jne    802c0c <insert_sorted_allocList+0x137>
  802bf8:	83 ec 04             	sub    $0x4,%esp
  802bfb:	68 ec 43 80 00       	push   $0x8043ec
  802c00:	6a 75                	push   $0x75
  802c02:	68 d3 43 80 00       	push   $0x8043d3
  802c07:	e8 38 e0 ff ff       	call   800c44 <_panic>
  802c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0f:	8b 50 04             	mov    0x4(%eax),%edx
  802c12:	8b 45 08             	mov    0x8(%ebp),%eax
  802c15:	89 50 04             	mov    %edx,0x4(%eax)
  802c18:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c1e:	89 10                	mov    %edx,(%eax)
  802c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c23:	8b 40 04             	mov    0x4(%eax),%eax
  802c26:	85 c0                	test   %eax,%eax
  802c28:	74 0d                	je     802c37 <insert_sorted_allocList+0x162>
  802c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2d:	8b 40 04             	mov    0x4(%eax),%eax
  802c30:	8b 55 08             	mov    0x8(%ebp),%edx
  802c33:	89 10                	mov    %edx,(%eax)
  802c35:	eb 08                	jmp    802c3f <insert_sorted_allocList+0x16a>
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	a3 40 50 80 00       	mov    %eax,0x805040
  802c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c42:	8b 55 08             	mov    0x8(%ebp),%edx
  802c45:	89 50 04             	mov    %edx,0x4(%eax)
  802c48:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c4d:	40                   	inc    %eax
  802c4e:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  802c53:	e9 59 01 00 00       	jmp    802db1 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802c58:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5b:	8b 50 08             	mov    0x8(%eax),%edx
  802c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c61:	8b 40 08             	mov    0x8(%eax),%eax
  802c64:	39 c2                	cmp    %eax,%edx
  802c66:	0f 86 98 00 00 00    	jbe    802d04 <insert_sorted_allocList+0x22f>
  802c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6f:	8b 50 08             	mov    0x8(%eax),%edx
  802c72:	a1 44 50 80 00       	mov    0x805044,%eax
  802c77:	8b 40 08             	mov    0x8(%eax),%eax
  802c7a:	39 c2                	cmp    %eax,%edx
  802c7c:	0f 83 82 00 00 00    	jae    802d04 <insert_sorted_allocList+0x22f>
  802c82:	8b 45 08             	mov    0x8(%ebp),%eax
  802c85:	8b 50 08             	mov    0x8(%eax),%edx
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	8b 00                	mov    (%eax),%eax
  802c8d:	8b 40 08             	mov    0x8(%eax),%eax
  802c90:	39 c2                	cmp    %eax,%edx
  802c92:	73 70                	jae    802d04 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802c94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c98:	74 06                	je     802ca0 <insert_sorted_allocList+0x1cb>
  802c9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c9e:	75 14                	jne    802cb4 <insert_sorted_allocList+0x1df>
  802ca0:	83 ec 04             	sub    $0x4,%esp
  802ca3:	68 24 44 80 00       	push   $0x804424
  802ca8:	6a 7c                	push   $0x7c
  802caa:	68 d3 43 80 00       	push   $0x8043d3
  802caf:	e8 90 df ff ff       	call   800c44 <_panic>
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	8b 10                	mov    (%eax),%edx
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	89 10                	mov    %edx,(%eax)
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	8b 00                	mov    (%eax),%eax
  802cc3:	85 c0                	test   %eax,%eax
  802cc5:	74 0b                	je     802cd2 <insert_sorted_allocList+0x1fd>
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	8b 00                	mov    (%eax),%eax
  802ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  802ccf:	89 50 04             	mov    %edx,0x4(%eax)
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd8:	89 10                	mov    %edx,(%eax)
  802cda:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce0:	89 50 04             	mov    %edx,0x4(%eax)
  802ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce6:	8b 00                	mov    (%eax),%eax
  802ce8:	85 c0                	test   %eax,%eax
  802cea:	75 08                	jne    802cf4 <insert_sorted_allocList+0x21f>
  802cec:	8b 45 08             	mov    0x8(%ebp),%eax
  802cef:	a3 44 50 80 00       	mov    %eax,0x805044
  802cf4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cf9:	40                   	inc    %eax
  802cfa:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802cff:	e9 ad 00 00 00       	jmp    802db1 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802d04:	8b 45 08             	mov    0x8(%ebp),%eax
  802d07:	8b 50 08             	mov    0x8(%eax),%edx
  802d0a:	a1 44 50 80 00       	mov    0x805044,%eax
  802d0f:	8b 40 08             	mov    0x8(%eax),%eax
  802d12:	39 c2                	cmp    %eax,%edx
  802d14:	76 65                	jbe    802d7b <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802d16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d1a:	75 17                	jne    802d33 <insert_sorted_allocList+0x25e>
  802d1c:	83 ec 04             	sub    $0x4,%esp
  802d1f:	68 58 44 80 00       	push   $0x804458
  802d24:	68 80 00 00 00       	push   $0x80
  802d29:	68 d3 43 80 00       	push   $0x8043d3
  802d2e:	e8 11 df ff ff       	call   800c44 <_panic>
  802d33:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	89 50 04             	mov    %edx,0x4(%eax)
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	8b 40 04             	mov    0x4(%eax),%eax
  802d45:	85 c0                	test   %eax,%eax
  802d47:	74 0c                	je     802d55 <insert_sorted_allocList+0x280>
  802d49:	a1 44 50 80 00       	mov    0x805044,%eax
  802d4e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d51:	89 10                	mov    %edx,(%eax)
  802d53:	eb 08                	jmp    802d5d <insert_sorted_allocList+0x288>
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	a3 40 50 80 00       	mov    %eax,0x805040
  802d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d60:	a3 44 50 80 00       	mov    %eax,0x805044
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d6e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d73:	40                   	inc    %eax
  802d74:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802d79:	eb 36                	jmp    802db1 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802d7b:	a1 48 50 80 00       	mov    0x805048,%eax
  802d80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d87:	74 07                	je     802d90 <insert_sorted_allocList+0x2bb>
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	8b 00                	mov    (%eax),%eax
  802d8e:	eb 05                	jmp    802d95 <insert_sorted_allocList+0x2c0>
  802d90:	b8 00 00 00 00       	mov    $0x0,%eax
  802d95:	a3 48 50 80 00       	mov    %eax,0x805048
  802d9a:	a1 48 50 80 00       	mov    0x805048,%eax
  802d9f:	85 c0                	test   %eax,%eax
  802da1:	0f 85 23 fe ff ff    	jne    802bca <insert_sorted_allocList+0xf5>
  802da7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dab:	0f 85 19 fe ff ff    	jne    802bca <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802db1:	90                   	nop
  802db2:	c9                   	leave  
  802db3:	c3                   	ret    

00802db4 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802db4:	55                   	push   %ebp
  802db5:	89 e5                	mov    %esp,%ebp
  802db7:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802dba:	a1 38 51 80 00       	mov    0x805138,%eax
  802dbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dc2:	e9 7c 01 00 00       	jmp    802f43 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dd0:	0f 85 90 00 00 00    	jne    802e66 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802ddc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de0:	75 17                	jne    802df9 <alloc_block_FF+0x45>
  802de2:	83 ec 04             	sub    $0x4,%esp
  802de5:	68 7b 44 80 00       	push   $0x80447b
  802dea:	68 ba 00 00 00       	push   $0xba
  802def:	68 d3 43 80 00       	push   $0x8043d3
  802df4:	e8 4b de ff ff       	call   800c44 <_panic>
  802df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfc:	8b 00                	mov    (%eax),%eax
  802dfe:	85 c0                	test   %eax,%eax
  802e00:	74 10                	je     802e12 <alloc_block_FF+0x5e>
  802e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e05:	8b 00                	mov    (%eax),%eax
  802e07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e0a:	8b 52 04             	mov    0x4(%edx),%edx
  802e0d:	89 50 04             	mov    %edx,0x4(%eax)
  802e10:	eb 0b                	jmp    802e1d <alloc_block_FF+0x69>
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	8b 40 04             	mov    0x4(%eax),%eax
  802e18:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e20:	8b 40 04             	mov    0x4(%eax),%eax
  802e23:	85 c0                	test   %eax,%eax
  802e25:	74 0f                	je     802e36 <alloc_block_FF+0x82>
  802e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2a:	8b 40 04             	mov    0x4(%eax),%eax
  802e2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e30:	8b 12                	mov    (%edx),%edx
  802e32:	89 10                	mov    %edx,(%eax)
  802e34:	eb 0a                	jmp    802e40 <alloc_block_FF+0x8c>
  802e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e39:	8b 00                	mov    (%eax),%eax
  802e3b:	a3 38 51 80 00       	mov    %eax,0x805138
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e53:	a1 44 51 80 00       	mov    0x805144,%eax
  802e58:	48                   	dec    %eax
  802e59:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e61:	e9 10 01 00 00       	jmp    802f76 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e6f:	0f 86 c6 00 00 00    	jbe    802f3b <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802e75:	a1 48 51 80 00       	mov    0x805148,%eax
  802e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802e7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e81:	75 17                	jne    802e9a <alloc_block_FF+0xe6>
  802e83:	83 ec 04             	sub    $0x4,%esp
  802e86:	68 7b 44 80 00       	push   $0x80447b
  802e8b:	68 c2 00 00 00       	push   $0xc2
  802e90:	68 d3 43 80 00       	push   $0x8043d3
  802e95:	e8 aa dd ff ff       	call   800c44 <_panic>
  802e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9d:	8b 00                	mov    (%eax),%eax
  802e9f:	85 c0                	test   %eax,%eax
  802ea1:	74 10                	je     802eb3 <alloc_block_FF+0xff>
  802ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea6:	8b 00                	mov    (%eax),%eax
  802ea8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eab:	8b 52 04             	mov    0x4(%edx),%edx
  802eae:	89 50 04             	mov    %edx,0x4(%eax)
  802eb1:	eb 0b                	jmp    802ebe <alloc_block_FF+0x10a>
  802eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb6:	8b 40 04             	mov    0x4(%eax),%eax
  802eb9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec1:	8b 40 04             	mov    0x4(%eax),%eax
  802ec4:	85 c0                	test   %eax,%eax
  802ec6:	74 0f                	je     802ed7 <alloc_block_FF+0x123>
  802ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecb:	8b 40 04             	mov    0x4(%eax),%eax
  802ece:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ed1:	8b 12                	mov    (%edx),%edx
  802ed3:	89 10                	mov    %edx,(%eax)
  802ed5:	eb 0a                	jmp    802ee1 <alloc_block_FF+0x12d>
  802ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eda:	8b 00                	mov    (%eax),%eax
  802edc:	a3 48 51 80 00       	mov    %eax,0x805148
  802ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef4:	a1 54 51 80 00       	mov    0x805154,%eax
  802ef9:	48                   	dec    %eax
  802efa:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f02:	8b 50 08             	mov    0x8(%eax),%edx
  802f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f08:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f11:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1a:	2b 45 08             	sub    0x8(%ebp),%eax
  802f1d:	89 c2                	mov    %eax,%edx
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	8b 50 08             	mov    0x8(%eax),%edx
  802f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2e:	01 c2                	add    %eax,%edx
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f39:	eb 3b                	jmp    802f76 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802f3b:	a1 40 51 80 00       	mov    0x805140,%eax
  802f40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f47:	74 07                	je     802f50 <alloc_block_FF+0x19c>
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 00                	mov    (%eax),%eax
  802f4e:	eb 05                	jmp    802f55 <alloc_block_FF+0x1a1>
  802f50:	b8 00 00 00 00       	mov    $0x0,%eax
  802f55:	a3 40 51 80 00       	mov    %eax,0x805140
  802f5a:	a1 40 51 80 00       	mov    0x805140,%eax
  802f5f:	85 c0                	test   %eax,%eax
  802f61:	0f 85 60 fe ff ff    	jne    802dc7 <alloc_block_FF+0x13>
  802f67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6b:	0f 85 56 fe ff ff    	jne    802dc7 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802f71:	b8 00 00 00 00       	mov    $0x0,%eax
  802f76:	c9                   	leave  
  802f77:	c3                   	ret    

00802f78 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802f78:	55                   	push   %ebp
  802f79:	89 e5                	mov    %esp,%ebp
  802f7b:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802f7e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802f85:	a1 38 51 80 00       	mov    0x805138,%eax
  802f8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f8d:	eb 3a                	jmp    802fc9 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	8b 40 0c             	mov    0xc(%eax),%eax
  802f95:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f98:	72 27                	jb     802fc1 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802f9a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802f9e:	75 0b                	jne    802fab <alloc_block_BF+0x33>
					best_size= element->size;
  802fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802fa9:	eb 16                	jmp    802fc1 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fae:	8b 50 0c             	mov    0xc(%eax),%edx
  802fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb4:	39 c2                	cmp    %eax,%edx
  802fb6:	77 09                	ja     802fc1 <alloc_block_BF+0x49>
					best_size=element->size;
  802fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbe:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802fc1:	a1 40 51 80 00       	mov    0x805140,%eax
  802fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fcd:	74 07                	je     802fd6 <alloc_block_BF+0x5e>
  802fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd2:	8b 00                	mov    (%eax),%eax
  802fd4:	eb 05                	jmp    802fdb <alloc_block_BF+0x63>
  802fd6:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdb:	a3 40 51 80 00       	mov    %eax,0x805140
  802fe0:	a1 40 51 80 00       	mov    0x805140,%eax
  802fe5:	85 c0                	test   %eax,%eax
  802fe7:	75 a6                	jne    802f8f <alloc_block_BF+0x17>
  802fe9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fed:	75 a0                	jne    802f8f <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802fef:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802ff3:	0f 84 d3 01 00 00    	je     8031cc <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802ff9:	a1 38 51 80 00       	mov    0x805138,%eax
  802ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803001:	e9 98 01 00 00       	jmp    80319e <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  803006:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803009:	3b 45 08             	cmp    0x8(%ebp),%eax
  80300c:	0f 86 da 00 00 00    	jbe    8030ec <alloc_block_BF+0x174>
  803012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803015:	8b 50 0c             	mov    0xc(%eax),%edx
  803018:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301b:	39 c2                	cmp    %eax,%edx
  80301d:	0f 85 c9 00 00 00    	jne    8030ec <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  803023:	a1 48 51 80 00       	mov    0x805148,%eax
  803028:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80302b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80302f:	75 17                	jne    803048 <alloc_block_BF+0xd0>
  803031:	83 ec 04             	sub    $0x4,%esp
  803034:	68 7b 44 80 00       	push   $0x80447b
  803039:	68 ea 00 00 00       	push   $0xea
  80303e:	68 d3 43 80 00       	push   $0x8043d3
  803043:	e8 fc db ff ff       	call   800c44 <_panic>
  803048:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304b:	8b 00                	mov    (%eax),%eax
  80304d:	85 c0                	test   %eax,%eax
  80304f:	74 10                	je     803061 <alloc_block_BF+0xe9>
  803051:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803054:	8b 00                	mov    (%eax),%eax
  803056:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803059:	8b 52 04             	mov    0x4(%edx),%edx
  80305c:	89 50 04             	mov    %edx,0x4(%eax)
  80305f:	eb 0b                	jmp    80306c <alloc_block_BF+0xf4>
  803061:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803064:	8b 40 04             	mov    0x4(%eax),%eax
  803067:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80306c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306f:	8b 40 04             	mov    0x4(%eax),%eax
  803072:	85 c0                	test   %eax,%eax
  803074:	74 0f                	je     803085 <alloc_block_BF+0x10d>
  803076:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803079:	8b 40 04             	mov    0x4(%eax),%eax
  80307c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80307f:	8b 12                	mov    (%edx),%edx
  803081:	89 10                	mov    %edx,(%eax)
  803083:	eb 0a                	jmp    80308f <alloc_block_BF+0x117>
  803085:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803088:	8b 00                	mov    (%eax),%eax
  80308a:	a3 48 51 80 00       	mov    %eax,0x805148
  80308f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803092:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803098:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a2:	a1 54 51 80 00       	mov    0x805154,%eax
  8030a7:	48                   	dec    %eax
  8030a8:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  8030ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b0:	8b 50 08             	mov    0x8(%eax),%edx
  8030b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b6:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  8030b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8030bf:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  8030c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c8:	2b 45 08             	sub    0x8(%ebp),%eax
  8030cb:	89 c2                	mov    %eax,%edx
  8030cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d0:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  8030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d6:	8b 50 08             	mov    0x8(%eax),%edx
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	01 c2                	add    %eax,%edx
  8030de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e1:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  8030e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e7:	e9 e5 00 00 00       	jmp    8031d1 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  8030ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ef:	8b 50 0c             	mov    0xc(%eax),%edx
  8030f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f5:	39 c2                	cmp    %eax,%edx
  8030f7:	0f 85 99 00 00 00    	jne    803196 <alloc_block_BF+0x21e>
  8030fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803100:	3b 45 08             	cmp    0x8(%ebp),%eax
  803103:	0f 85 8d 00 00 00    	jne    803196 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  803109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  80310f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803113:	75 17                	jne    80312c <alloc_block_BF+0x1b4>
  803115:	83 ec 04             	sub    $0x4,%esp
  803118:	68 7b 44 80 00       	push   $0x80447b
  80311d:	68 f7 00 00 00       	push   $0xf7
  803122:	68 d3 43 80 00       	push   $0x8043d3
  803127:	e8 18 db ff ff       	call   800c44 <_panic>
  80312c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312f:	8b 00                	mov    (%eax),%eax
  803131:	85 c0                	test   %eax,%eax
  803133:	74 10                	je     803145 <alloc_block_BF+0x1cd>
  803135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803138:	8b 00                	mov    (%eax),%eax
  80313a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80313d:	8b 52 04             	mov    0x4(%edx),%edx
  803140:	89 50 04             	mov    %edx,0x4(%eax)
  803143:	eb 0b                	jmp    803150 <alloc_block_BF+0x1d8>
  803145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803148:	8b 40 04             	mov    0x4(%eax),%eax
  80314b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803153:	8b 40 04             	mov    0x4(%eax),%eax
  803156:	85 c0                	test   %eax,%eax
  803158:	74 0f                	je     803169 <alloc_block_BF+0x1f1>
  80315a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315d:	8b 40 04             	mov    0x4(%eax),%eax
  803160:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803163:	8b 12                	mov    (%edx),%edx
  803165:	89 10                	mov    %edx,(%eax)
  803167:	eb 0a                	jmp    803173 <alloc_block_BF+0x1fb>
  803169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316c:	8b 00                	mov    (%eax),%eax
  80316e:	a3 38 51 80 00       	mov    %eax,0x805138
  803173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803176:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80317c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803186:	a1 44 51 80 00       	mov    0x805144,%eax
  80318b:	48                   	dec    %eax
  80318c:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  803191:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803194:	eb 3b                	jmp    8031d1 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  803196:	a1 40 51 80 00       	mov    0x805140,%eax
  80319b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80319e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a2:	74 07                	je     8031ab <alloc_block_BF+0x233>
  8031a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a7:	8b 00                	mov    (%eax),%eax
  8031a9:	eb 05                	jmp    8031b0 <alloc_block_BF+0x238>
  8031ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b0:	a3 40 51 80 00       	mov    %eax,0x805140
  8031b5:	a1 40 51 80 00       	mov    0x805140,%eax
  8031ba:	85 c0                	test   %eax,%eax
  8031bc:	0f 85 44 fe ff ff    	jne    803006 <alloc_block_BF+0x8e>
  8031c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c6:	0f 85 3a fe ff ff    	jne    803006 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  8031cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d1:	c9                   	leave  
  8031d2:	c3                   	ret    

008031d3 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8031d3:	55                   	push   %ebp
  8031d4:	89 e5                	mov    %esp,%ebp
  8031d6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8031d9:	83 ec 04             	sub    $0x4,%esp
  8031dc:	68 9c 44 80 00       	push   $0x80449c
  8031e1:	68 04 01 00 00       	push   $0x104
  8031e6:	68 d3 43 80 00       	push   $0x8043d3
  8031eb:	e8 54 da ff ff       	call   800c44 <_panic>

008031f0 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  8031f0:	55                   	push   %ebp
  8031f1:	89 e5                	mov    %esp,%ebp
  8031f3:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  8031f6:	a1 38 51 80 00       	mov    0x805138,%eax
  8031fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  8031fe:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803203:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  803206:	a1 38 51 80 00       	mov    0x805138,%eax
  80320b:	85 c0                	test   %eax,%eax
  80320d:	75 68                	jne    803277 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  80320f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803213:	75 17                	jne    80322c <insert_sorted_with_merge_freeList+0x3c>
  803215:	83 ec 04             	sub    $0x4,%esp
  803218:	68 b0 43 80 00       	push   $0x8043b0
  80321d:	68 14 01 00 00       	push   $0x114
  803222:	68 d3 43 80 00       	push   $0x8043d3
  803227:	e8 18 da ff ff       	call   800c44 <_panic>
  80322c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803232:	8b 45 08             	mov    0x8(%ebp),%eax
  803235:	89 10                	mov    %edx,(%eax)
  803237:	8b 45 08             	mov    0x8(%ebp),%eax
  80323a:	8b 00                	mov    (%eax),%eax
  80323c:	85 c0                	test   %eax,%eax
  80323e:	74 0d                	je     80324d <insert_sorted_with_merge_freeList+0x5d>
  803240:	a1 38 51 80 00       	mov    0x805138,%eax
  803245:	8b 55 08             	mov    0x8(%ebp),%edx
  803248:	89 50 04             	mov    %edx,0x4(%eax)
  80324b:	eb 08                	jmp    803255 <insert_sorted_with_merge_freeList+0x65>
  80324d:	8b 45 08             	mov    0x8(%ebp),%eax
  803250:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803255:	8b 45 08             	mov    0x8(%ebp),%eax
  803258:	a3 38 51 80 00       	mov    %eax,0x805138
  80325d:	8b 45 08             	mov    0x8(%ebp),%eax
  803260:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803267:	a1 44 51 80 00       	mov    0x805144,%eax
  80326c:	40                   	inc    %eax
  80326d:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803272:	e9 d2 06 00 00       	jmp    803949 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  803277:	8b 45 08             	mov    0x8(%ebp),%eax
  80327a:	8b 50 08             	mov    0x8(%eax),%edx
  80327d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803280:	8b 40 08             	mov    0x8(%eax),%eax
  803283:	39 c2                	cmp    %eax,%edx
  803285:	0f 83 22 01 00 00    	jae    8033ad <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	8b 50 08             	mov    0x8(%eax),%edx
  803291:	8b 45 08             	mov    0x8(%ebp),%eax
  803294:	8b 40 0c             	mov    0xc(%eax),%eax
  803297:	01 c2                	add    %eax,%edx
  803299:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329c:	8b 40 08             	mov    0x8(%eax),%eax
  80329f:	39 c2                	cmp    %eax,%edx
  8032a1:	0f 85 9e 00 00 00    	jne    803345 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  8032a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032aa:	8b 50 08             	mov    0x8(%eax),%edx
  8032ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b0:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  8032b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b6:	8b 50 0c             	mov    0xc(%eax),%edx
  8032b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8032bf:	01 c2                	add    %eax,%edx
  8032c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c4:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  8032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8032d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d4:	8b 50 08             	mov    0x8(%eax),%edx
  8032d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032da:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8032dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e1:	75 17                	jne    8032fa <insert_sorted_with_merge_freeList+0x10a>
  8032e3:	83 ec 04             	sub    $0x4,%esp
  8032e6:	68 b0 43 80 00       	push   $0x8043b0
  8032eb:	68 21 01 00 00       	push   $0x121
  8032f0:	68 d3 43 80 00       	push   $0x8043d3
  8032f5:	e8 4a d9 ff ff       	call   800c44 <_panic>
  8032fa:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803300:	8b 45 08             	mov    0x8(%ebp),%eax
  803303:	89 10                	mov    %edx,(%eax)
  803305:	8b 45 08             	mov    0x8(%ebp),%eax
  803308:	8b 00                	mov    (%eax),%eax
  80330a:	85 c0                	test   %eax,%eax
  80330c:	74 0d                	je     80331b <insert_sorted_with_merge_freeList+0x12b>
  80330e:	a1 48 51 80 00       	mov    0x805148,%eax
  803313:	8b 55 08             	mov    0x8(%ebp),%edx
  803316:	89 50 04             	mov    %edx,0x4(%eax)
  803319:	eb 08                	jmp    803323 <insert_sorted_with_merge_freeList+0x133>
  80331b:	8b 45 08             	mov    0x8(%ebp),%eax
  80331e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803323:	8b 45 08             	mov    0x8(%ebp),%eax
  803326:	a3 48 51 80 00       	mov    %eax,0x805148
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803335:	a1 54 51 80 00       	mov    0x805154,%eax
  80333a:	40                   	inc    %eax
  80333b:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  803340:	e9 04 06 00 00       	jmp    803949 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  803345:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803349:	75 17                	jne    803362 <insert_sorted_with_merge_freeList+0x172>
  80334b:	83 ec 04             	sub    $0x4,%esp
  80334e:	68 b0 43 80 00       	push   $0x8043b0
  803353:	68 26 01 00 00       	push   $0x126
  803358:	68 d3 43 80 00       	push   $0x8043d3
  80335d:	e8 e2 d8 ff ff       	call   800c44 <_panic>
  803362:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803368:	8b 45 08             	mov    0x8(%ebp),%eax
  80336b:	89 10                	mov    %edx,(%eax)
  80336d:	8b 45 08             	mov    0x8(%ebp),%eax
  803370:	8b 00                	mov    (%eax),%eax
  803372:	85 c0                	test   %eax,%eax
  803374:	74 0d                	je     803383 <insert_sorted_with_merge_freeList+0x193>
  803376:	a1 38 51 80 00       	mov    0x805138,%eax
  80337b:	8b 55 08             	mov    0x8(%ebp),%edx
  80337e:	89 50 04             	mov    %edx,0x4(%eax)
  803381:	eb 08                	jmp    80338b <insert_sorted_with_merge_freeList+0x19b>
  803383:	8b 45 08             	mov    0x8(%ebp),%eax
  803386:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80338b:	8b 45 08             	mov    0x8(%ebp),%eax
  80338e:	a3 38 51 80 00       	mov    %eax,0x805138
  803393:	8b 45 08             	mov    0x8(%ebp),%eax
  803396:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80339d:	a1 44 51 80 00       	mov    0x805144,%eax
  8033a2:	40                   	inc    %eax
  8033a3:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  8033a8:	e9 9c 05 00 00       	jmp    803949 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  8033ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b0:	8b 50 08             	mov    0x8(%eax),%edx
  8033b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b6:	8b 40 08             	mov    0x8(%eax),%eax
  8033b9:	39 c2                	cmp    %eax,%edx
  8033bb:	0f 86 16 01 00 00    	jbe    8034d7 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  8033c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c4:	8b 50 08             	mov    0x8(%eax),%edx
  8033c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8033cd:	01 c2                	add    %eax,%edx
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	8b 40 08             	mov    0x8(%eax),%eax
  8033d5:	39 c2                	cmp    %eax,%edx
  8033d7:	0f 85 92 00 00 00    	jne    80346f <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  8033dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e0:	8b 50 0c             	mov    0xc(%eax),%edx
  8033e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e9:	01 c2                	add    %eax,%edx
  8033eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ee:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8033fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fe:	8b 50 08             	mov    0x8(%eax),%edx
  803401:	8b 45 08             	mov    0x8(%ebp),%eax
  803404:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803407:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80340b:	75 17                	jne    803424 <insert_sorted_with_merge_freeList+0x234>
  80340d:	83 ec 04             	sub    $0x4,%esp
  803410:	68 b0 43 80 00       	push   $0x8043b0
  803415:	68 31 01 00 00       	push   $0x131
  80341a:	68 d3 43 80 00       	push   $0x8043d3
  80341f:	e8 20 d8 ff ff       	call   800c44 <_panic>
  803424:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80342a:	8b 45 08             	mov    0x8(%ebp),%eax
  80342d:	89 10                	mov    %edx,(%eax)
  80342f:	8b 45 08             	mov    0x8(%ebp),%eax
  803432:	8b 00                	mov    (%eax),%eax
  803434:	85 c0                	test   %eax,%eax
  803436:	74 0d                	je     803445 <insert_sorted_with_merge_freeList+0x255>
  803438:	a1 48 51 80 00       	mov    0x805148,%eax
  80343d:	8b 55 08             	mov    0x8(%ebp),%edx
  803440:	89 50 04             	mov    %edx,0x4(%eax)
  803443:	eb 08                	jmp    80344d <insert_sorted_with_merge_freeList+0x25d>
  803445:	8b 45 08             	mov    0x8(%ebp),%eax
  803448:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80344d:	8b 45 08             	mov    0x8(%ebp),%eax
  803450:	a3 48 51 80 00       	mov    %eax,0x805148
  803455:	8b 45 08             	mov    0x8(%ebp),%eax
  803458:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80345f:	a1 54 51 80 00       	mov    0x805154,%eax
  803464:	40                   	inc    %eax
  803465:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  80346a:	e9 da 04 00 00       	jmp    803949 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  80346f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803473:	75 17                	jne    80348c <insert_sorted_with_merge_freeList+0x29c>
  803475:	83 ec 04             	sub    $0x4,%esp
  803478:	68 58 44 80 00       	push   $0x804458
  80347d:	68 37 01 00 00       	push   $0x137
  803482:	68 d3 43 80 00       	push   $0x8043d3
  803487:	e8 b8 d7 ff ff       	call   800c44 <_panic>
  80348c:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	89 50 04             	mov    %edx,0x4(%eax)
  803498:	8b 45 08             	mov    0x8(%ebp),%eax
  80349b:	8b 40 04             	mov    0x4(%eax),%eax
  80349e:	85 c0                	test   %eax,%eax
  8034a0:	74 0c                	je     8034ae <insert_sorted_with_merge_freeList+0x2be>
  8034a2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8034aa:	89 10                	mov    %edx,(%eax)
  8034ac:	eb 08                	jmp    8034b6 <insert_sorted_with_merge_freeList+0x2c6>
  8034ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b1:	a3 38 51 80 00       	mov    %eax,0x805138
  8034b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034be:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c7:	a1 44 51 80 00       	mov    0x805144,%eax
  8034cc:	40                   	inc    %eax
  8034cd:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  8034d2:	e9 72 04 00 00       	jmp    803949 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8034d7:	a1 38 51 80 00       	mov    0x805138,%eax
  8034dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034df:	e9 35 04 00 00       	jmp    803919 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  8034e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e7:	8b 00                	mov    (%eax),%eax
  8034e9:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  8034ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ef:	8b 50 08             	mov    0x8(%eax),%edx
  8034f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f5:	8b 40 08             	mov    0x8(%eax),%eax
  8034f8:	39 c2                	cmp    %eax,%edx
  8034fa:	0f 86 11 04 00 00    	jbe    803911 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  803500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803503:	8b 50 08             	mov    0x8(%eax),%edx
  803506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803509:	8b 40 0c             	mov    0xc(%eax),%eax
  80350c:	01 c2                	add    %eax,%edx
  80350e:	8b 45 08             	mov    0x8(%ebp),%eax
  803511:	8b 40 08             	mov    0x8(%eax),%eax
  803514:	39 c2                	cmp    %eax,%edx
  803516:	0f 83 8b 00 00 00    	jae    8035a7 <insert_sorted_with_merge_freeList+0x3b7>
  80351c:	8b 45 08             	mov    0x8(%ebp),%eax
  80351f:	8b 50 08             	mov    0x8(%eax),%edx
  803522:	8b 45 08             	mov    0x8(%ebp),%eax
  803525:	8b 40 0c             	mov    0xc(%eax),%eax
  803528:	01 c2                	add    %eax,%edx
  80352a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80352d:	8b 40 08             	mov    0x8(%eax),%eax
  803530:	39 c2                	cmp    %eax,%edx
  803532:	73 73                	jae    8035a7 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  803534:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803538:	74 06                	je     803540 <insert_sorted_with_merge_freeList+0x350>
  80353a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80353e:	75 17                	jne    803557 <insert_sorted_with_merge_freeList+0x367>
  803540:	83 ec 04             	sub    $0x4,%esp
  803543:	68 24 44 80 00       	push   $0x804424
  803548:	68 48 01 00 00       	push   $0x148
  80354d:	68 d3 43 80 00       	push   $0x8043d3
  803552:	e8 ed d6 ff ff       	call   800c44 <_panic>
  803557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355a:	8b 10                	mov    (%eax),%edx
  80355c:	8b 45 08             	mov    0x8(%ebp),%eax
  80355f:	89 10                	mov    %edx,(%eax)
  803561:	8b 45 08             	mov    0x8(%ebp),%eax
  803564:	8b 00                	mov    (%eax),%eax
  803566:	85 c0                	test   %eax,%eax
  803568:	74 0b                	je     803575 <insert_sorted_with_merge_freeList+0x385>
  80356a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356d:	8b 00                	mov    (%eax),%eax
  80356f:	8b 55 08             	mov    0x8(%ebp),%edx
  803572:	89 50 04             	mov    %edx,0x4(%eax)
  803575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803578:	8b 55 08             	mov    0x8(%ebp),%edx
  80357b:	89 10                	mov    %edx,(%eax)
  80357d:	8b 45 08             	mov    0x8(%ebp),%eax
  803580:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803583:	89 50 04             	mov    %edx,0x4(%eax)
  803586:	8b 45 08             	mov    0x8(%ebp),%eax
  803589:	8b 00                	mov    (%eax),%eax
  80358b:	85 c0                	test   %eax,%eax
  80358d:	75 08                	jne    803597 <insert_sorted_with_merge_freeList+0x3a7>
  80358f:	8b 45 08             	mov    0x8(%ebp),%eax
  803592:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803597:	a1 44 51 80 00       	mov    0x805144,%eax
  80359c:	40                   	inc    %eax
  80359d:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  8035a2:	e9 a2 03 00 00       	jmp    803949 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8035a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035aa:	8b 50 08             	mov    0x8(%eax),%edx
  8035ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b3:	01 c2                	add    %eax,%edx
  8035b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b8:	8b 40 08             	mov    0x8(%eax),%eax
  8035bb:	39 c2                	cmp    %eax,%edx
  8035bd:	0f 83 ae 00 00 00    	jae    803671 <insert_sorted_with_merge_freeList+0x481>
  8035c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c6:	8b 50 08             	mov    0x8(%eax),%edx
  8035c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cc:	8b 48 08             	mov    0x8(%eax),%ecx
  8035cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d5:	01 c8                	add    %ecx,%eax
  8035d7:	39 c2                	cmp    %eax,%edx
  8035d9:	0f 85 92 00 00 00    	jne    803671 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  8035df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e2:	8b 50 0c             	mov    0xc(%eax),%edx
  8035e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8035eb:	01 c2                	add    %eax,%edx
  8035ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f0:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  8035f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8035fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803600:	8b 50 08             	mov    0x8(%eax),%edx
  803603:	8b 45 08             	mov    0x8(%ebp),%eax
  803606:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803609:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80360d:	75 17                	jne    803626 <insert_sorted_with_merge_freeList+0x436>
  80360f:	83 ec 04             	sub    $0x4,%esp
  803612:	68 b0 43 80 00       	push   $0x8043b0
  803617:	68 51 01 00 00       	push   $0x151
  80361c:	68 d3 43 80 00       	push   $0x8043d3
  803621:	e8 1e d6 ff ff       	call   800c44 <_panic>
  803626:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80362c:	8b 45 08             	mov    0x8(%ebp),%eax
  80362f:	89 10                	mov    %edx,(%eax)
  803631:	8b 45 08             	mov    0x8(%ebp),%eax
  803634:	8b 00                	mov    (%eax),%eax
  803636:	85 c0                	test   %eax,%eax
  803638:	74 0d                	je     803647 <insert_sorted_with_merge_freeList+0x457>
  80363a:	a1 48 51 80 00       	mov    0x805148,%eax
  80363f:	8b 55 08             	mov    0x8(%ebp),%edx
  803642:	89 50 04             	mov    %edx,0x4(%eax)
  803645:	eb 08                	jmp    80364f <insert_sorted_with_merge_freeList+0x45f>
  803647:	8b 45 08             	mov    0x8(%ebp),%eax
  80364a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80364f:	8b 45 08             	mov    0x8(%ebp),%eax
  803652:	a3 48 51 80 00       	mov    %eax,0x805148
  803657:	8b 45 08             	mov    0x8(%ebp),%eax
  80365a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803661:	a1 54 51 80 00       	mov    0x805154,%eax
  803666:	40                   	inc    %eax
  803667:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  80366c:	e9 d8 02 00 00       	jmp    803949 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  803671:	8b 45 08             	mov    0x8(%ebp),%eax
  803674:	8b 50 08             	mov    0x8(%eax),%edx
  803677:	8b 45 08             	mov    0x8(%ebp),%eax
  80367a:	8b 40 0c             	mov    0xc(%eax),%eax
  80367d:	01 c2                	add    %eax,%edx
  80367f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803682:	8b 40 08             	mov    0x8(%eax),%eax
  803685:	39 c2                	cmp    %eax,%edx
  803687:	0f 85 ba 00 00 00    	jne    803747 <insert_sorted_with_merge_freeList+0x557>
  80368d:	8b 45 08             	mov    0x8(%ebp),%eax
  803690:	8b 50 08             	mov    0x8(%eax),%edx
  803693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803696:	8b 48 08             	mov    0x8(%eax),%ecx
  803699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369c:	8b 40 0c             	mov    0xc(%eax),%eax
  80369f:	01 c8                	add    %ecx,%eax
  8036a1:	39 c2                	cmp    %eax,%edx
  8036a3:	0f 86 9e 00 00 00    	jbe    803747 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  8036a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ac:	8b 50 0c             	mov    0xc(%eax),%edx
  8036af:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8036b5:	01 c2                	add    %eax,%edx
  8036b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ba:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  8036bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c0:	8b 50 08             	mov    0x8(%eax),%edx
  8036c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c6:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  8036c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8036d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d6:	8b 50 08             	mov    0x8(%eax),%edx
  8036d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036dc:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8036df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e3:	75 17                	jne    8036fc <insert_sorted_with_merge_freeList+0x50c>
  8036e5:	83 ec 04             	sub    $0x4,%esp
  8036e8:	68 b0 43 80 00       	push   $0x8043b0
  8036ed:	68 5b 01 00 00       	push   $0x15b
  8036f2:	68 d3 43 80 00       	push   $0x8043d3
  8036f7:	e8 48 d5 ff ff       	call   800c44 <_panic>
  8036fc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803702:	8b 45 08             	mov    0x8(%ebp),%eax
  803705:	89 10                	mov    %edx,(%eax)
  803707:	8b 45 08             	mov    0x8(%ebp),%eax
  80370a:	8b 00                	mov    (%eax),%eax
  80370c:	85 c0                	test   %eax,%eax
  80370e:	74 0d                	je     80371d <insert_sorted_with_merge_freeList+0x52d>
  803710:	a1 48 51 80 00       	mov    0x805148,%eax
  803715:	8b 55 08             	mov    0x8(%ebp),%edx
  803718:	89 50 04             	mov    %edx,0x4(%eax)
  80371b:	eb 08                	jmp    803725 <insert_sorted_with_merge_freeList+0x535>
  80371d:	8b 45 08             	mov    0x8(%ebp),%eax
  803720:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803725:	8b 45 08             	mov    0x8(%ebp),%eax
  803728:	a3 48 51 80 00       	mov    %eax,0x805148
  80372d:	8b 45 08             	mov    0x8(%ebp),%eax
  803730:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803737:	a1 54 51 80 00       	mov    0x805154,%eax
  80373c:	40                   	inc    %eax
  80373d:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803742:	e9 02 02 00 00       	jmp    803949 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803747:	8b 45 08             	mov    0x8(%ebp),%eax
  80374a:	8b 50 08             	mov    0x8(%eax),%edx
  80374d:	8b 45 08             	mov    0x8(%ebp),%eax
  803750:	8b 40 0c             	mov    0xc(%eax),%eax
  803753:	01 c2                	add    %eax,%edx
  803755:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803758:	8b 40 08             	mov    0x8(%eax),%eax
  80375b:	39 c2                	cmp    %eax,%edx
  80375d:	0f 85 ae 01 00 00    	jne    803911 <insert_sorted_with_merge_freeList+0x721>
  803763:	8b 45 08             	mov    0x8(%ebp),%eax
  803766:	8b 50 08             	mov    0x8(%eax),%edx
  803769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376c:	8b 48 08             	mov    0x8(%eax),%ecx
  80376f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803772:	8b 40 0c             	mov    0xc(%eax),%eax
  803775:	01 c8                	add    %ecx,%eax
  803777:	39 c2                	cmp    %eax,%edx
  803779:	0f 85 92 01 00 00    	jne    803911 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  80377f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803782:	8b 50 0c             	mov    0xc(%eax),%edx
  803785:	8b 45 08             	mov    0x8(%ebp),%eax
  803788:	8b 40 0c             	mov    0xc(%eax),%eax
  80378b:	01 c2                	add    %eax,%edx
  80378d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803790:	8b 40 0c             	mov    0xc(%eax),%eax
  803793:	01 c2                	add    %eax,%edx
  803795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803798:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  80379b:	8b 45 08             	mov    0x8(%ebp),%eax
  80379e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8037a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a8:	8b 50 08             	mov    0x8(%eax),%edx
  8037ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ae:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  8037b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8037bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037be:	8b 50 08             	mov    0x8(%eax),%edx
  8037c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c4:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  8037c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037cb:	75 17                	jne    8037e4 <insert_sorted_with_merge_freeList+0x5f4>
  8037cd:	83 ec 04             	sub    $0x4,%esp
  8037d0:	68 7b 44 80 00       	push   $0x80447b
  8037d5:	68 63 01 00 00       	push   $0x163
  8037da:	68 d3 43 80 00       	push   $0x8043d3
  8037df:	e8 60 d4 ff ff       	call   800c44 <_panic>
  8037e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e7:	8b 00                	mov    (%eax),%eax
  8037e9:	85 c0                	test   %eax,%eax
  8037eb:	74 10                	je     8037fd <insert_sorted_with_merge_freeList+0x60d>
  8037ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f0:	8b 00                	mov    (%eax),%eax
  8037f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037f5:	8b 52 04             	mov    0x4(%edx),%edx
  8037f8:	89 50 04             	mov    %edx,0x4(%eax)
  8037fb:	eb 0b                	jmp    803808 <insert_sorted_with_merge_freeList+0x618>
  8037fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803800:	8b 40 04             	mov    0x4(%eax),%eax
  803803:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803808:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80380b:	8b 40 04             	mov    0x4(%eax),%eax
  80380e:	85 c0                	test   %eax,%eax
  803810:	74 0f                	je     803821 <insert_sorted_with_merge_freeList+0x631>
  803812:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803815:	8b 40 04             	mov    0x4(%eax),%eax
  803818:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80381b:	8b 12                	mov    (%edx),%edx
  80381d:	89 10                	mov    %edx,(%eax)
  80381f:	eb 0a                	jmp    80382b <insert_sorted_with_merge_freeList+0x63b>
  803821:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803824:	8b 00                	mov    (%eax),%eax
  803826:	a3 38 51 80 00       	mov    %eax,0x805138
  80382b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803834:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803837:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80383e:	a1 44 51 80 00       	mov    0x805144,%eax
  803843:	48                   	dec    %eax
  803844:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  803849:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80384d:	75 17                	jne    803866 <insert_sorted_with_merge_freeList+0x676>
  80384f:	83 ec 04             	sub    $0x4,%esp
  803852:	68 b0 43 80 00       	push   $0x8043b0
  803857:	68 64 01 00 00       	push   $0x164
  80385c:	68 d3 43 80 00       	push   $0x8043d3
  803861:	e8 de d3 ff ff       	call   800c44 <_panic>
  803866:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80386c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386f:	89 10                	mov    %edx,(%eax)
  803871:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803874:	8b 00                	mov    (%eax),%eax
  803876:	85 c0                	test   %eax,%eax
  803878:	74 0d                	je     803887 <insert_sorted_with_merge_freeList+0x697>
  80387a:	a1 48 51 80 00       	mov    0x805148,%eax
  80387f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803882:	89 50 04             	mov    %edx,0x4(%eax)
  803885:	eb 08                	jmp    80388f <insert_sorted_with_merge_freeList+0x69f>
  803887:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80388a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80388f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803892:	a3 48 51 80 00       	mov    %eax,0x805148
  803897:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a1:	a1 54 51 80 00       	mov    0x805154,%eax
  8038a6:	40                   	inc    %eax
  8038a7:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8038ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038b0:	75 17                	jne    8038c9 <insert_sorted_with_merge_freeList+0x6d9>
  8038b2:	83 ec 04             	sub    $0x4,%esp
  8038b5:	68 b0 43 80 00       	push   $0x8043b0
  8038ba:	68 65 01 00 00       	push   $0x165
  8038bf:	68 d3 43 80 00       	push   $0x8043d3
  8038c4:	e8 7b d3 ff ff       	call   800c44 <_panic>
  8038c9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d2:	89 10                	mov    %edx,(%eax)
  8038d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d7:	8b 00                	mov    (%eax),%eax
  8038d9:	85 c0                	test   %eax,%eax
  8038db:	74 0d                	je     8038ea <insert_sorted_with_merge_freeList+0x6fa>
  8038dd:	a1 48 51 80 00       	mov    0x805148,%eax
  8038e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8038e5:	89 50 04             	mov    %edx,0x4(%eax)
  8038e8:	eb 08                	jmp    8038f2 <insert_sorted_with_merge_freeList+0x702>
  8038ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ed:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f5:	a3 48 51 80 00       	mov    %eax,0x805148
  8038fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803904:	a1 54 51 80 00       	mov    0x805154,%eax
  803909:	40                   	inc    %eax
  80390a:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  80390f:	eb 38                	jmp    803949 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803911:	a1 40 51 80 00       	mov    0x805140,%eax
  803916:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803919:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80391d:	74 07                	je     803926 <insert_sorted_with_merge_freeList+0x736>
  80391f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803922:	8b 00                	mov    (%eax),%eax
  803924:	eb 05                	jmp    80392b <insert_sorted_with_merge_freeList+0x73b>
  803926:	b8 00 00 00 00       	mov    $0x0,%eax
  80392b:	a3 40 51 80 00       	mov    %eax,0x805140
  803930:	a1 40 51 80 00       	mov    0x805140,%eax
  803935:	85 c0                	test   %eax,%eax
  803937:	0f 85 a7 fb ff ff    	jne    8034e4 <insert_sorted_with_merge_freeList+0x2f4>
  80393d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803941:	0f 85 9d fb ff ff    	jne    8034e4 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  803947:	eb 00                	jmp    803949 <insert_sorted_with_merge_freeList+0x759>
  803949:	90                   	nop
  80394a:	c9                   	leave  
  80394b:	c3                   	ret    

0080394c <__udivdi3>:
  80394c:	55                   	push   %ebp
  80394d:	57                   	push   %edi
  80394e:	56                   	push   %esi
  80394f:	53                   	push   %ebx
  803950:	83 ec 1c             	sub    $0x1c,%esp
  803953:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803957:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80395b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80395f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803963:	89 ca                	mov    %ecx,%edx
  803965:	89 f8                	mov    %edi,%eax
  803967:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80396b:	85 f6                	test   %esi,%esi
  80396d:	75 2d                	jne    80399c <__udivdi3+0x50>
  80396f:	39 cf                	cmp    %ecx,%edi
  803971:	77 65                	ja     8039d8 <__udivdi3+0x8c>
  803973:	89 fd                	mov    %edi,%ebp
  803975:	85 ff                	test   %edi,%edi
  803977:	75 0b                	jne    803984 <__udivdi3+0x38>
  803979:	b8 01 00 00 00       	mov    $0x1,%eax
  80397e:	31 d2                	xor    %edx,%edx
  803980:	f7 f7                	div    %edi
  803982:	89 c5                	mov    %eax,%ebp
  803984:	31 d2                	xor    %edx,%edx
  803986:	89 c8                	mov    %ecx,%eax
  803988:	f7 f5                	div    %ebp
  80398a:	89 c1                	mov    %eax,%ecx
  80398c:	89 d8                	mov    %ebx,%eax
  80398e:	f7 f5                	div    %ebp
  803990:	89 cf                	mov    %ecx,%edi
  803992:	89 fa                	mov    %edi,%edx
  803994:	83 c4 1c             	add    $0x1c,%esp
  803997:	5b                   	pop    %ebx
  803998:	5e                   	pop    %esi
  803999:	5f                   	pop    %edi
  80399a:	5d                   	pop    %ebp
  80399b:	c3                   	ret    
  80399c:	39 ce                	cmp    %ecx,%esi
  80399e:	77 28                	ja     8039c8 <__udivdi3+0x7c>
  8039a0:	0f bd fe             	bsr    %esi,%edi
  8039a3:	83 f7 1f             	xor    $0x1f,%edi
  8039a6:	75 40                	jne    8039e8 <__udivdi3+0x9c>
  8039a8:	39 ce                	cmp    %ecx,%esi
  8039aa:	72 0a                	jb     8039b6 <__udivdi3+0x6a>
  8039ac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039b0:	0f 87 9e 00 00 00    	ja     803a54 <__udivdi3+0x108>
  8039b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8039bb:	89 fa                	mov    %edi,%edx
  8039bd:	83 c4 1c             	add    $0x1c,%esp
  8039c0:	5b                   	pop    %ebx
  8039c1:	5e                   	pop    %esi
  8039c2:	5f                   	pop    %edi
  8039c3:	5d                   	pop    %ebp
  8039c4:	c3                   	ret    
  8039c5:	8d 76 00             	lea    0x0(%esi),%esi
  8039c8:	31 ff                	xor    %edi,%edi
  8039ca:	31 c0                	xor    %eax,%eax
  8039cc:	89 fa                	mov    %edi,%edx
  8039ce:	83 c4 1c             	add    $0x1c,%esp
  8039d1:	5b                   	pop    %ebx
  8039d2:	5e                   	pop    %esi
  8039d3:	5f                   	pop    %edi
  8039d4:	5d                   	pop    %ebp
  8039d5:	c3                   	ret    
  8039d6:	66 90                	xchg   %ax,%ax
  8039d8:	89 d8                	mov    %ebx,%eax
  8039da:	f7 f7                	div    %edi
  8039dc:	31 ff                	xor    %edi,%edi
  8039de:	89 fa                	mov    %edi,%edx
  8039e0:	83 c4 1c             	add    $0x1c,%esp
  8039e3:	5b                   	pop    %ebx
  8039e4:	5e                   	pop    %esi
  8039e5:	5f                   	pop    %edi
  8039e6:	5d                   	pop    %ebp
  8039e7:	c3                   	ret    
  8039e8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039ed:	89 eb                	mov    %ebp,%ebx
  8039ef:	29 fb                	sub    %edi,%ebx
  8039f1:	89 f9                	mov    %edi,%ecx
  8039f3:	d3 e6                	shl    %cl,%esi
  8039f5:	89 c5                	mov    %eax,%ebp
  8039f7:	88 d9                	mov    %bl,%cl
  8039f9:	d3 ed                	shr    %cl,%ebp
  8039fb:	89 e9                	mov    %ebp,%ecx
  8039fd:	09 f1                	or     %esi,%ecx
  8039ff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a03:	89 f9                	mov    %edi,%ecx
  803a05:	d3 e0                	shl    %cl,%eax
  803a07:	89 c5                	mov    %eax,%ebp
  803a09:	89 d6                	mov    %edx,%esi
  803a0b:	88 d9                	mov    %bl,%cl
  803a0d:	d3 ee                	shr    %cl,%esi
  803a0f:	89 f9                	mov    %edi,%ecx
  803a11:	d3 e2                	shl    %cl,%edx
  803a13:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a17:	88 d9                	mov    %bl,%cl
  803a19:	d3 e8                	shr    %cl,%eax
  803a1b:	09 c2                	or     %eax,%edx
  803a1d:	89 d0                	mov    %edx,%eax
  803a1f:	89 f2                	mov    %esi,%edx
  803a21:	f7 74 24 0c          	divl   0xc(%esp)
  803a25:	89 d6                	mov    %edx,%esi
  803a27:	89 c3                	mov    %eax,%ebx
  803a29:	f7 e5                	mul    %ebp
  803a2b:	39 d6                	cmp    %edx,%esi
  803a2d:	72 19                	jb     803a48 <__udivdi3+0xfc>
  803a2f:	74 0b                	je     803a3c <__udivdi3+0xf0>
  803a31:	89 d8                	mov    %ebx,%eax
  803a33:	31 ff                	xor    %edi,%edi
  803a35:	e9 58 ff ff ff       	jmp    803992 <__udivdi3+0x46>
  803a3a:	66 90                	xchg   %ax,%ax
  803a3c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a40:	89 f9                	mov    %edi,%ecx
  803a42:	d3 e2                	shl    %cl,%edx
  803a44:	39 c2                	cmp    %eax,%edx
  803a46:	73 e9                	jae    803a31 <__udivdi3+0xe5>
  803a48:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a4b:	31 ff                	xor    %edi,%edi
  803a4d:	e9 40 ff ff ff       	jmp    803992 <__udivdi3+0x46>
  803a52:	66 90                	xchg   %ax,%ax
  803a54:	31 c0                	xor    %eax,%eax
  803a56:	e9 37 ff ff ff       	jmp    803992 <__udivdi3+0x46>
  803a5b:	90                   	nop

00803a5c <__umoddi3>:
  803a5c:	55                   	push   %ebp
  803a5d:	57                   	push   %edi
  803a5e:	56                   	push   %esi
  803a5f:	53                   	push   %ebx
  803a60:	83 ec 1c             	sub    $0x1c,%esp
  803a63:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a67:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a6f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a73:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a77:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a7b:	89 f3                	mov    %esi,%ebx
  803a7d:	89 fa                	mov    %edi,%edx
  803a7f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a83:	89 34 24             	mov    %esi,(%esp)
  803a86:	85 c0                	test   %eax,%eax
  803a88:	75 1a                	jne    803aa4 <__umoddi3+0x48>
  803a8a:	39 f7                	cmp    %esi,%edi
  803a8c:	0f 86 a2 00 00 00    	jbe    803b34 <__umoddi3+0xd8>
  803a92:	89 c8                	mov    %ecx,%eax
  803a94:	89 f2                	mov    %esi,%edx
  803a96:	f7 f7                	div    %edi
  803a98:	89 d0                	mov    %edx,%eax
  803a9a:	31 d2                	xor    %edx,%edx
  803a9c:	83 c4 1c             	add    $0x1c,%esp
  803a9f:	5b                   	pop    %ebx
  803aa0:	5e                   	pop    %esi
  803aa1:	5f                   	pop    %edi
  803aa2:	5d                   	pop    %ebp
  803aa3:	c3                   	ret    
  803aa4:	39 f0                	cmp    %esi,%eax
  803aa6:	0f 87 ac 00 00 00    	ja     803b58 <__umoddi3+0xfc>
  803aac:	0f bd e8             	bsr    %eax,%ebp
  803aaf:	83 f5 1f             	xor    $0x1f,%ebp
  803ab2:	0f 84 ac 00 00 00    	je     803b64 <__umoddi3+0x108>
  803ab8:	bf 20 00 00 00       	mov    $0x20,%edi
  803abd:	29 ef                	sub    %ebp,%edi
  803abf:	89 fe                	mov    %edi,%esi
  803ac1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ac5:	89 e9                	mov    %ebp,%ecx
  803ac7:	d3 e0                	shl    %cl,%eax
  803ac9:	89 d7                	mov    %edx,%edi
  803acb:	89 f1                	mov    %esi,%ecx
  803acd:	d3 ef                	shr    %cl,%edi
  803acf:	09 c7                	or     %eax,%edi
  803ad1:	89 e9                	mov    %ebp,%ecx
  803ad3:	d3 e2                	shl    %cl,%edx
  803ad5:	89 14 24             	mov    %edx,(%esp)
  803ad8:	89 d8                	mov    %ebx,%eax
  803ada:	d3 e0                	shl    %cl,%eax
  803adc:	89 c2                	mov    %eax,%edx
  803ade:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ae2:	d3 e0                	shl    %cl,%eax
  803ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ae8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aec:	89 f1                	mov    %esi,%ecx
  803aee:	d3 e8                	shr    %cl,%eax
  803af0:	09 d0                	or     %edx,%eax
  803af2:	d3 eb                	shr    %cl,%ebx
  803af4:	89 da                	mov    %ebx,%edx
  803af6:	f7 f7                	div    %edi
  803af8:	89 d3                	mov    %edx,%ebx
  803afa:	f7 24 24             	mull   (%esp)
  803afd:	89 c6                	mov    %eax,%esi
  803aff:	89 d1                	mov    %edx,%ecx
  803b01:	39 d3                	cmp    %edx,%ebx
  803b03:	0f 82 87 00 00 00    	jb     803b90 <__umoddi3+0x134>
  803b09:	0f 84 91 00 00 00    	je     803ba0 <__umoddi3+0x144>
  803b0f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b13:	29 f2                	sub    %esi,%edx
  803b15:	19 cb                	sbb    %ecx,%ebx
  803b17:	89 d8                	mov    %ebx,%eax
  803b19:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b1d:	d3 e0                	shl    %cl,%eax
  803b1f:	89 e9                	mov    %ebp,%ecx
  803b21:	d3 ea                	shr    %cl,%edx
  803b23:	09 d0                	or     %edx,%eax
  803b25:	89 e9                	mov    %ebp,%ecx
  803b27:	d3 eb                	shr    %cl,%ebx
  803b29:	89 da                	mov    %ebx,%edx
  803b2b:	83 c4 1c             	add    $0x1c,%esp
  803b2e:	5b                   	pop    %ebx
  803b2f:	5e                   	pop    %esi
  803b30:	5f                   	pop    %edi
  803b31:	5d                   	pop    %ebp
  803b32:	c3                   	ret    
  803b33:	90                   	nop
  803b34:	89 fd                	mov    %edi,%ebp
  803b36:	85 ff                	test   %edi,%edi
  803b38:	75 0b                	jne    803b45 <__umoddi3+0xe9>
  803b3a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b3f:	31 d2                	xor    %edx,%edx
  803b41:	f7 f7                	div    %edi
  803b43:	89 c5                	mov    %eax,%ebp
  803b45:	89 f0                	mov    %esi,%eax
  803b47:	31 d2                	xor    %edx,%edx
  803b49:	f7 f5                	div    %ebp
  803b4b:	89 c8                	mov    %ecx,%eax
  803b4d:	f7 f5                	div    %ebp
  803b4f:	89 d0                	mov    %edx,%eax
  803b51:	e9 44 ff ff ff       	jmp    803a9a <__umoddi3+0x3e>
  803b56:	66 90                	xchg   %ax,%ax
  803b58:	89 c8                	mov    %ecx,%eax
  803b5a:	89 f2                	mov    %esi,%edx
  803b5c:	83 c4 1c             	add    $0x1c,%esp
  803b5f:	5b                   	pop    %ebx
  803b60:	5e                   	pop    %esi
  803b61:	5f                   	pop    %edi
  803b62:	5d                   	pop    %ebp
  803b63:	c3                   	ret    
  803b64:	3b 04 24             	cmp    (%esp),%eax
  803b67:	72 06                	jb     803b6f <__umoddi3+0x113>
  803b69:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b6d:	77 0f                	ja     803b7e <__umoddi3+0x122>
  803b6f:	89 f2                	mov    %esi,%edx
  803b71:	29 f9                	sub    %edi,%ecx
  803b73:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b77:	89 14 24             	mov    %edx,(%esp)
  803b7a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b7e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b82:	8b 14 24             	mov    (%esp),%edx
  803b85:	83 c4 1c             	add    $0x1c,%esp
  803b88:	5b                   	pop    %ebx
  803b89:	5e                   	pop    %esi
  803b8a:	5f                   	pop    %edi
  803b8b:	5d                   	pop    %ebp
  803b8c:	c3                   	ret    
  803b8d:	8d 76 00             	lea    0x0(%esi),%esi
  803b90:	2b 04 24             	sub    (%esp),%eax
  803b93:	19 fa                	sbb    %edi,%edx
  803b95:	89 d1                	mov    %edx,%ecx
  803b97:	89 c6                	mov    %eax,%esi
  803b99:	e9 71 ff ff ff       	jmp    803b0f <__umoddi3+0xb3>
  803b9e:	66 90                	xchg   %ax,%ax
  803ba0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ba4:	72 ea                	jb     803b90 <__umoddi3+0x134>
  803ba6:	89 d9                	mov    %ebx,%ecx
  803ba8:	e9 62 ff ff ff       	jmp    803b0f <__umoddi3+0xb3>
