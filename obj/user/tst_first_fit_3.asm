
obj/user/tst_first_fit_3:     file format elf32-i386


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
  800031:	e8 50 0d 00 00       	call   800d86 <libmain>
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

	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 9b 29 00 00       	call   8029e5 <sys_set_uheap_strategy>
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
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

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
  80009b:	68 40 3e 80 00       	push   $0x803e40
  8000a0:	6a 16                	push   $0x16
  8000a2:	68 5c 3e 80 00       	push   $0x803e5c
  8000a7:	e8 16 0e 00 00       	call   800ec2 <_panic>
	}

	int envID = sys_getenvid();
  8000ac:	e8 e6 26 00 00       	call   802797 <sys_getenvid>
  8000b1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000b4:	83 ec 0c             	sub    $0xc,%esp
  8000b7:	6a 00                	push   $0x0
  8000b9:	e8 e4 1f 00 00       	call   8020a2 <malloc>
  8000be:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000c1:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000c8:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  8000cf:	8d 55 8c             	lea    -0x74(%ebp),%edx
  8000d2:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000dc:	89 d7                	mov    %edx,%edi
  8000de:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate Shared 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000e0:	e8 eb 23 00 00       	call   8024d0 <sys_calculate_free_frames>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e8:	e8 83 24 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  8000ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8000f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f3:	83 ec 04             	sub    $0x4,%esp
  8000f6:	6a 01                	push   $0x1
  8000f8:	50                   	push   %eax
  8000f9:	68 73 3e 80 00       	push   $0x803e73
  8000fe:	e8 ee 20 00 00       	call   8021f1 <smalloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if (ptr_allocations[0] != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800109:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80010c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800111:	74 14                	je     800127 <_main+0xef>
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 78 3e 80 00       	push   $0x803e78
  80011b:	6a 2a                	push   $0x2a
  80011d:	68 5c 3e 80 00       	push   $0x803e5c
  800122:	e8 9b 0d 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  256+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800127:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80012a:	e8 a1 23 00 00       	call   8024d0 <sys_calculate_free_frames>
  80012f:	29 c3                	sub    %eax,%ebx
  800131:	89 d8                	mov    %ebx,%eax
  800133:	3d 03 01 00 00       	cmp    $0x103,%eax
  800138:	74 14                	je     80014e <_main+0x116>
  80013a:	83 ec 04             	sub    $0x4,%esp
  80013d:	68 e4 3e 80 00       	push   $0x803ee4
  800142:	6a 2b                	push   $0x2b
  800144:	68 5c 3e 80 00       	push   $0x803e5c
  800149:	e8 74 0d 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014e:	e8 1d 24 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800153:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800156:	74 14                	je     80016c <_main+0x134>
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 62 3f 80 00       	push   $0x803f62
  800160:	6a 2c                	push   $0x2c
  800162:	68 5c 3e 80 00       	push   $0x803e5c
  800167:	e8 56 0d 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80016c:	e8 5f 23 00 00       	call   8024d0 <sys_calculate_free_frames>
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800174:	e8 f7 23 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800179:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80017c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80017f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	50                   	push   %eax
  800186:	e8 17 1f 00 00       	call   8020a2 <malloc>
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  800191:	8b 45 90             	mov    -0x70(%ebp),%eax
  800194:	89 c2                	mov    %eax,%edx
  800196:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800199:	05 00 00 00 80       	add    $0x80000000,%eax
  80019e:	39 c2                	cmp    %eax,%edx
  8001a0:	74 14                	je     8001b6 <_main+0x17e>
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	68 80 3f 80 00       	push   $0x803f80
  8001aa:	6a 32                	push   $0x32
  8001ac:	68 5c 3e 80 00       	push   $0x803e5c
  8001b1:	e8 0c 0d 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b6:	e8 b5 23 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  8001bb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 62 3f 80 00       	push   $0x803f62
  8001c8:	6a 34                	push   $0x34
  8001ca:	68 5c 3e 80 00       	push   $0x803e5c
  8001cf:	e8 ee 0c 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001d4:	e8 f7 22 00 00       	call   8024d0 <sys_calculate_free_frames>
  8001d9:	89 c2                	mov    %eax,%edx
  8001db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001de:	39 c2                	cmp    %eax,%edx
  8001e0:	74 14                	je     8001f6 <_main+0x1be>
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	68 b0 3f 80 00       	push   $0x803fb0
  8001ea:	6a 35                	push   $0x35
  8001ec:	68 5c 3e 80 00       	push   $0x803e5c
  8001f1:	e8 cc 0c 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001f6:	e8 d5 22 00 00       	call   8024d0 <sys_calculate_free_frames>
  8001fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001fe:	e8 6d 23 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800203:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800206:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800209:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	50                   	push   %eax
  800210:	e8 8d 1e 00 00       	call   8020a2 <malloc>
  800215:	83 c4 10             	add    $0x10,%esp
  800218:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  80021b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80021e:	89 c2                	mov    %eax,%edx
  800220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800223:	01 c0                	add    %eax,%eax
  800225:	05 00 00 00 80       	add    $0x80000000,%eax
  80022a:	39 c2                	cmp    %eax,%edx
  80022c:	74 14                	je     800242 <_main+0x20a>
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	68 80 3f 80 00       	push   $0x803f80
  800236:	6a 3b                	push   $0x3b
  800238:	68 5c 3e 80 00       	push   $0x803e5c
  80023d:	e8 80 0c 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800242:	e8 29 23 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800247:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80024a:	74 14                	je     800260 <_main+0x228>
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	68 62 3f 80 00       	push   $0x803f62
  800254:	6a 3d                	push   $0x3d
  800256:	68 5c 3e 80 00       	push   $0x803e5c
  80025b:	e8 62 0c 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800260:	e8 6b 22 00 00       	call   8024d0 <sys_calculate_free_frames>
  800265:	89 c2                	mov    %eax,%edx
  800267:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80026a:	39 c2                	cmp    %eax,%edx
  80026c:	74 14                	je     800282 <_main+0x24a>
  80026e:	83 ec 04             	sub    $0x4,%esp
  800271:	68 b0 3f 80 00       	push   $0x803fb0
  800276:	6a 3e                	push   $0x3e
  800278:	68 5c 3e 80 00       	push   $0x803e5c
  80027d:	e8 40 0c 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800282:	e8 49 22 00 00       	call   8024d0 <sys_calculate_free_frames>
  800287:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80028a:	e8 e1 22 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  80028f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800292:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800295:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	50                   	push   %eax
  80029c:	e8 01 1e 00 00       	call   8020a2 <malloc>
  8002a1:	83 c4 10             	add    $0x10,%esp
  8002a4:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  8002a7:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002aa:	89 c1                	mov    %eax,%ecx
  8002ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002af:	89 c2                	mov    %eax,%edx
  8002b1:	01 d2                	add    %edx,%edx
  8002b3:	01 d0                	add    %edx,%eax
  8002b5:	05 00 00 00 80       	add    $0x80000000,%eax
  8002ba:	39 c1                	cmp    %eax,%ecx
  8002bc:	74 14                	je     8002d2 <_main+0x29a>
  8002be:	83 ec 04             	sub    $0x4,%esp
  8002c1:	68 80 3f 80 00       	push   $0x803f80
  8002c6:	6a 44                	push   $0x44
  8002c8:	68 5c 3e 80 00       	push   $0x803e5c
  8002cd:	e8 f0 0b 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002d2:	e8 99 22 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  8002d7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002da:	74 14                	je     8002f0 <_main+0x2b8>
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	68 62 3f 80 00       	push   $0x803f62
  8002e4:	6a 46                	push   $0x46
  8002e6:	68 5c 3e 80 00       	push   $0x803e5c
  8002eb:	e8 d2 0b 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002f0:	e8 db 21 00 00       	call   8024d0 <sys_calculate_free_frames>
  8002f5:	89 c2                	mov    %eax,%edx
  8002f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 b0 3f 80 00       	push   $0x803fb0
  800306:	6a 47                	push   $0x47
  800308:	68 5c 3e 80 00       	push   $0x803e5c
  80030d:	e8 b0 0b 00 00       	call   800ec2 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800312:	e8 b9 21 00 00       	call   8024d0 <sys_calculate_free_frames>
  800317:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80031a:	e8 51 22 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  80031f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800322:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800325:	01 c0                	add    %eax,%eax
  800327:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80032a:	83 ec 0c             	sub    $0xc,%esp
  80032d:	50                   	push   %eax
  80032e:	e8 6f 1d 00 00       	call   8020a2 <malloc>
  800333:	83 c4 10             	add    $0x10,%esp
  800336:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800339:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80033c:	89 c2                	mov    %eax,%edx
  80033e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800341:	c1 e0 02             	shl    $0x2,%eax
  800344:	05 00 00 00 80       	add    $0x80000000,%eax
  800349:	39 c2                	cmp    %eax,%edx
  80034b:	74 14                	je     800361 <_main+0x329>
  80034d:	83 ec 04             	sub    $0x4,%esp
  800350:	68 80 3f 80 00       	push   $0x803f80
  800355:	6a 4d                	push   $0x4d
  800357:	68 5c 3e 80 00       	push   $0x803e5c
  80035c:	e8 61 0b 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800361:	e8 0a 22 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800366:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800369:	74 14                	je     80037f <_main+0x347>
  80036b:	83 ec 04             	sub    $0x4,%esp
  80036e:	68 62 3f 80 00       	push   $0x803f62
  800373:	6a 4f                	push   $0x4f
  800375:	68 5c 3e 80 00       	push   $0x803e5c
  80037a:	e8 43 0b 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80037f:	e8 4c 21 00 00       	call   8024d0 <sys_calculate_free_frames>
  800384:	89 c2                	mov    %eax,%edx
  800386:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800389:	39 c2                	cmp    %eax,%edx
  80038b:	74 14                	je     8003a1 <_main+0x369>
  80038d:	83 ec 04             	sub    $0x4,%esp
  800390:	68 b0 3f 80 00       	push   $0x803fb0
  800395:	6a 50                	push   $0x50
  800397:	68 5c 3e 80 00       	push   $0x803e5c
  80039c:	e8 21 0b 00 00       	call   800ec2 <_panic>

		//Allocate Shared 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8003a1:	e8 2a 21 00 00       	call   8024d0 <sys_calculate_free_frames>
  8003a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003a9:	e8 c2 21 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  8003ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  8003b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003b4:	01 c0                	add    %eax,%eax
  8003b6:	83 ec 04             	sub    $0x4,%esp
  8003b9:	6a 01                	push   $0x1
  8003bb:	50                   	push   %eax
  8003bc:	68 c3 3f 80 00       	push   $0x803fc3
  8003c1:	e8 2b 1e 00 00       	call   8021f1 <smalloc>
  8003c6:	83 c4 10             	add    $0x10,%esp
  8003c9:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if (ptr_allocations[5] != (uint32*)(USER_HEAP_START + 6*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8003cc:	8b 4d a0             	mov    -0x60(%ebp),%ecx
  8003cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d2:	89 d0                	mov    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	01 c0                	add    %eax,%eax
  8003da:	05 00 00 00 80       	add    $0x80000000,%eax
  8003df:	39 c1                	cmp    %eax,%ecx
  8003e1:	74 14                	je     8003f7 <_main+0x3bf>
  8003e3:	83 ec 04             	sub    $0x4,%esp
  8003e6:	68 78 3e 80 00       	push   $0x803e78
  8003eb:	6a 56                	push   $0x56
  8003ed:	68 5c 3e 80 00       	push   $0x803e5c
  8003f2:	e8 cb 0a 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  512+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8003f7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003fa:	e8 d1 20 00 00       	call   8024d0 <sys_calculate_free_frames>
  8003ff:	29 c3                	sub    %eax,%ebx
  800401:	89 d8                	mov    %ebx,%eax
  800403:	3d 03 02 00 00       	cmp    $0x203,%eax
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 e4 3e 80 00       	push   $0x803ee4
  800412:	6a 57                	push   $0x57
  800414:	68 5c 3e 80 00       	push   $0x803e5c
  800419:	e8 a4 0a 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80041e:	e8 4d 21 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800423:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800426:	74 14                	je     80043c <_main+0x404>
  800428:	83 ec 04             	sub    $0x4,%esp
  80042b:	68 62 3f 80 00       	push   $0x803f62
  800430:	6a 58                	push   $0x58
  800432:	68 5c 3e 80 00       	push   $0x803e5c
  800437:	e8 86 0a 00 00       	call   800ec2 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80043c:	e8 8f 20 00 00       	call   8024d0 <sys_calculate_free_frames>
  800441:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800444:	e8 27 21 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800449:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  80044c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044f:	89 c2                	mov    %eax,%edx
  800451:	01 d2                	add    %edx,%edx
  800453:	01 d0                	add    %edx,%eax
  800455:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800458:	83 ec 0c             	sub    $0xc,%esp
  80045b:	50                   	push   %eax
  80045c:	e8 41 1c 00 00       	call   8020a2 <malloc>
  800461:	83 c4 10             	add    $0x10,%esp
  800464:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800467:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80046a:	89 c2                	mov    %eax,%edx
  80046c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80046f:	c1 e0 03             	shl    $0x3,%eax
  800472:	05 00 00 00 80       	add    $0x80000000,%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <_main+0x457>
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 80 3f 80 00       	push   $0x803f80
  800483:	6a 5e                	push   $0x5e
  800485:	68 5c 3e 80 00       	push   $0x803e5c
  80048a:	e8 33 0a 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80048f:	e8 dc 20 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800494:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800497:	74 14                	je     8004ad <_main+0x475>
  800499:	83 ec 04             	sub    $0x4,%esp
  80049c:	68 62 3f 80 00       	push   $0x803f62
  8004a1:	6a 60                	push   $0x60
  8004a3:	68 5c 3e 80 00       	push   $0x803e5c
  8004a8:	e8 15 0a 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8004ad:	e8 1e 20 00 00       	call   8024d0 <sys_calculate_free_frames>
  8004b2:	89 c2                	mov    %eax,%edx
  8004b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b7:	39 c2                	cmp    %eax,%edx
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 b0 3f 80 00       	push   $0x803fb0
  8004c3:	6a 61                	push   $0x61
  8004c5:	68 5c 3e 80 00       	push   $0x803e5c
  8004ca:	e8 f3 09 00 00       	call   800ec2 <_panic>

		//Allocate Shared 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004cf:	e8 fc 1f 00 00       	call   8024d0 <sys_calculate_free_frames>
  8004d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004d7:	e8 94 20 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  8004dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  8004df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004e2:	89 c2                	mov    %eax,%edx
  8004e4:	01 d2                	add    %edx,%edx
  8004e6:	01 d0                	add    %edx,%eax
  8004e8:	83 ec 04             	sub    $0x4,%esp
  8004eb:	6a 00                	push   $0x0
  8004ed:	50                   	push   %eax
  8004ee:	68 c5 3f 80 00       	push   $0x803fc5
  8004f3:	e8 f9 1c 00 00       	call   8021f1 <smalloc>
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if (ptr_allocations[7] != (uint32*)(USER_HEAP_START + 11*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8004fe:	8b 4d a8             	mov    -0x58(%ebp),%ecx
  800501:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800504:	89 d0                	mov    %edx,%eax
  800506:	c1 e0 02             	shl    $0x2,%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	01 c0                	add    %eax,%eax
  80050d:	01 d0                	add    %edx,%eax
  80050f:	05 00 00 00 80       	add    $0x80000000,%eax
  800514:	39 c1                	cmp    %eax,%ecx
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 78 3e 80 00       	push   $0x803e78
  800520:	6a 67                	push   $0x67
  800522:	68 5c 3e 80 00       	push   $0x803e5c
  800527:	e8 96 09 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  768+2+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80052c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80052f:	e8 9c 1f 00 00       	call   8024d0 <sys_calculate_free_frames>
  800534:	29 c3                	sub    %eax,%ebx
  800536:	89 d8                	mov    %ebx,%eax
  800538:	3d 04 03 00 00       	cmp    $0x304,%eax
  80053d:	74 14                	je     800553 <_main+0x51b>
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 e4 3e 80 00       	push   $0x803ee4
  800547:	6a 68                	push   $0x68
  800549:	68 5c 3e 80 00       	push   $0x803e5c
  80054e:	e8 6f 09 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800553:	e8 18 20 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800558:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 62 3f 80 00       	push   $0x803f62
  800565:	6a 69                	push   $0x69
  800567:	68 5c 3e 80 00       	push   $0x803e5c
  80056c:	e8 51 09 00 00       	call   800ec2 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800571:	e8 5a 1f 00 00       	call   8024d0 <sys_calculate_free_frames>
  800576:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800579:	e8 f2 1f 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  80057e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  800581:	8b 45 90             	mov    -0x70(%ebp),%eax
  800584:	83 ec 0c             	sub    $0xc,%esp
  800587:	50                   	push   %eax
  800588:	e8 90 1b 00 00       	call   80211d <free>
  80058d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800590:	e8 db 1f 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800595:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800598:	74 14                	je     8005ae <_main+0x576>
  80059a:	83 ec 04             	sub    $0x4,%esp
  80059d:	68 c7 3f 80 00       	push   $0x803fc7
  8005a2:	6a 73                	push   $0x73
  8005a4:	68 5c 3e 80 00       	push   $0x803e5c
  8005a9:	e8 14 09 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ae:	e8 1d 1f 00 00       	call   8024d0 <sys_calculate_free_frames>
  8005b3:	89 c2                	mov    %eax,%edx
  8005b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b8:	39 c2                	cmp    %eax,%edx
  8005ba:	74 14                	je     8005d0 <_main+0x598>
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	68 de 3f 80 00       	push   $0x803fde
  8005c4:	6a 74                	push   $0x74
  8005c6:	68 5c 3e 80 00       	push   $0x803e5c
  8005cb:	e8 f2 08 00 00       	call   800ec2 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d0:	e8 fb 1e 00 00       	call   8024d0 <sys_calculate_free_frames>
  8005d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005d8:	e8 93 1f 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  8005dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  8005e0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8005e3:	83 ec 0c             	sub    $0xc,%esp
  8005e6:	50                   	push   %eax
  8005e7:	e8 31 1b 00 00       	call   80211d <free>
  8005ec:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005ef:	e8 7c 1f 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  8005f4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f7:	74 14                	je     80060d <_main+0x5d5>
  8005f9:	83 ec 04             	sub    $0x4,%esp
  8005fc:	68 c7 3f 80 00       	push   $0x803fc7
  800601:	6a 7b                	push   $0x7b
  800603:	68 5c 3e 80 00       	push   $0x803e5c
  800608:	e8 b5 08 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80060d:	e8 be 1e 00 00       	call   8024d0 <sys_calculate_free_frames>
  800612:	89 c2                	mov    %eax,%edx
  800614:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800617:	39 c2                	cmp    %eax,%edx
  800619:	74 14                	je     80062f <_main+0x5f7>
  80061b:	83 ec 04             	sub    $0x4,%esp
  80061e:	68 de 3f 80 00       	push   $0x803fde
  800623:	6a 7c                	push   $0x7c
  800625:	68 5c 3e 80 00       	push   $0x803e5c
  80062a:	e8 93 08 00 00       	call   800ec2 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80062f:	e8 9c 1e 00 00       	call   8024d0 <sys_calculate_free_frames>
  800634:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800637:	e8 34 1f 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  80063c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  80063f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800642:	83 ec 0c             	sub    $0xc,%esp
  800645:	50                   	push   %eax
  800646:	e8 d2 1a 00 00       	call   80211d <free>
  80064b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80064e:	e8 1d 1f 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800653:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800656:	74 17                	je     80066f <_main+0x637>
  800658:	83 ec 04             	sub    $0x4,%esp
  80065b:	68 c7 3f 80 00       	push   $0x803fc7
  800660:	68 83 00 00 00       	push   $0x83
  800665:	68 5c 3e 80 00       	push   $0x803e5c
  80066a:	e8 53 08 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80066f:	e8 5c 1e 00 00       	call   8024d0 <sys_calculate_free_frames>
  800674:	89 c2                	mov    %eax,%edx
  800676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800679:	39 c2                	cmp    %eax,%edx
  80067b:	74 17                	je     800694 <_main+0x65c>
  80067d:	83 ec 04             	sub    $0x4,%esp
  800680:	68 de 3f 80 00       	push   $0x803fde
  800685:	68 84 00 00 00       	push   $0x84
  80068a:	68 5c 3e 80 00       	push   $0x803e5c
  80068f:	e8 2e 08 00 00       	call   800ec2 <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800694:	e8 37 1e 00 00       	call   8024d0 <sys_calculate_free_frames>
  800699:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80069c:	e8 cf 1e 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  8006a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8006a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006a7:	89 d0                	mov    %edx,%eax
  8006a9:	c1 e0 09             	shl    $0x9,%eax
  8006ac:	29 d0                	sub    %edx,%eax
  8006ae:	83 ec 0c             	sub    $0xc,%esp
  8006b1:	50                   	push   %eax
  8006b2:	e8 eb 19 00 00       	call   8020a2 <malloc>
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8006bd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8006c0:	89 c2                	mov    %eax,%edx
  8006c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006c5:	05 00 00 00 80       	add    $0x80000000,%eax
  8006ca:	39 c2                	cmp    %eax,%edx
  8006cc:	74 17                	je     8006e5 <_main+0x6ad>
  8006ce:	83 ec 04             	sub    $0x4,%esp
  8006d1:	68 80 3f 80 00       	push   $0x803f80
  8006d6:	68 8d 00 00 00       	push   $0x8d
  8006db:	68 5c 3e 80 00       	push   $0x803e5c
  8006e0:	e8 dd 07 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006e5:	e8 86 1e 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  8006ea:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006ed:	74 17                	je     800706 <_main+0x6ce>
  8006ef:	83 ec 04             	sub    $0x4,%esp
  8006f2:	68 62 3f 80 00       	push   $0x803f62
  8006f7:	68 8f 00 00 00       	push   $0x8f
  8006fc:	68 5c 3e 80 00       	push   $0x803e5c
  800701:	e8 bc 07 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800706:	e8 c5 1d 00 00       	call   8024d0 <sys_calculate_free_frames>
  80070b:	89 c2                	mov    %eax,%edx
  80070d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800710:	39 c2                	cmp    %eax,%edx
  800712:	74 17                	je     80072b <_main+0x6f3>
  800714:	83 ec 04             	sub    $0x4,%esp
  800717:	68 b0 3f 80 00       	push   $0x803fb0
  80071c:	68 90 00 00 00       	push   $0x90
  800721:	68 5c 3e 80 00       	push   $0x803e5c
  800726:	e8 97 07 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80072b:	e8 a0 1d 00 00       	call   8024d0 <sys_calculate_free_frames>
  800730:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800733:	e8 38 1e 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800738:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80073b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80073e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800741:	83 ec 0c             	sub    $0xc,%esp
  800744:	50                   	push   %eax
  800745:	e8 58 19 00 00       	call   8020a2 <malloc>
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800750:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800753:	89 c2                	mov    %eax,%edx
  800755:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800758:	c1 e0 02             	shl    $0x2,%eax
  80075b:	05 00 00 00 80       	add    $0x80000000,%eax
  800760:	39 c2                	cmp    %eax,%edx
  800762:	74 17                	je     80077b <_main+0x743>
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	68 80 3f 80 00       	push   $0x803f80
  80076c:	68 96 00 00 00       	push   $0x96
  800771:	68 5c 3e 80 00       	push   $0x803e5c
  800776:	e8 47 07 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80077b:	e8 f0 1d 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800780:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800783:	74 17                	je     80079c <_main+0x764>
  800785:	83 ec 04             	sub    $0x4,%esp
  800788:	68 62 3f 80 00       	push   $0x803f62
  80078d:	68 98 00 00 00       	push   $0x98
  800792:	68 5c 3e 80 00       	push   $0x803e5c
  800797:	e8 26 07 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80079c:	e8 2f 1d 00 00       	call   8024d0 <sys_calculate_free_frames>
  8007a1:	89 c2                	mov    %eax,%edx
  8007a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a6:	39 c2                	cmp    %eax,%edx
  8007a8:	74 17                	je     8007c1 <_main+0x789>
  8007aa:	83 ec 04             	sub    $0x4,%esp
  8007ad:	68 b0 3f 80 00       	push   $0x803fb0
  8007b2:	68 99 00 00 00       	push   $0x99
  8007b7:	68 5c 3e 80 00       	push   $0x803e5c
  8007bc:	e8 01 07 00 00       	call   800ec2 <_panic>

		//Allocate Shared 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007c1:	e8 0a 1d 00 00       	call   8024d0 <sys_calculate_free_frames>
  8007c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007c9:	e8 a2 1d 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  8007ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//ptr_allocations[10] = malloc(256*kilo - kilo);
		ptr_allocations[10] = smalloc("a", 256*kilo - kilo, 0);
  8007d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007d4:	89 d0                	mov    %edx,%eax
  8007d6:	c1 e0 08             	shl    $0x8,%eax
  8007d9:	29 d0                	sub    %edx,%eax
  8007db:	83 ec 04             	sub    $0x4,%esp
  8007de:	6a 00                	push   $0x0
  8007e0:	50                   	push   %eax
  8007e1:	68 eb 3f 80 00       	push   $0x803feb
  8007e6:	e8 06 1a 00 00       	call   8021f1 <smalloc>
  8007eb:	83 c4 10             	add    $0x10,%esp
  8007ee:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  8007f1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8007f4:	89 c2                	mov    %eax,%edx
  8007f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007f9:	c1 e0 09             	shl    $0x9,%eax
  8007fc:	89 c1                	mov    %eax,%ecx
  8007fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800801:	01 c8                	add    %ecx,%eax
  800803:	05 00 00 00 80       	add    $0x80000000,%eax
  800808:	39 c2                	cmp    %eax,%edx
  80080a:	74 17                	je     800823 <_main+0x7eb>
  80080c:	83 ec 04             	sub    $0x4,%esp
  80080f:	68 80 3f 80 00       	push   $0x803f80
  800814:	68 a0 00 00 00       	push   $0xa0
  800819:	68 5c 3e 80 00       	push   $0x803e5c
  80081e:	e8 9f 06 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800823:	e8 48 1d 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800828:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80082b:	74 17                	je     800844 <_main+0x80c>
  80082d:	83 ec 04             	sub    $0x4,%esp
  800830:	68 62 3f 80 00       	push   $0x803f62
  800835:	68 a1 00 00 00       	push   $0xa1
  80083a:	68 5c 3e 80 00       	push   $0x803e5c
  80083f:	e8 7e 06 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 64+0+2) panic("Wrong allocation: %d", (freeFrames - sys_calculate_free_frames()));
  800844:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800847:	e8 84 1c 00 00       	call   8024d0 <sys_calculate_free_frames>
  80084c:	29 c3                	sub    %eax,%ebx
  80084e:	89 d8                	mov    %ebx,%eax
  800850:	83 f8 42             	cmp    $0x42,%eax
  800853:	74 21                	je     800876 <_main+0x83e>
  800855:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800858:	e8 73 1c 00 00       	call   8024d0 <sys_calculate_free_frames>
  80085d:	29 c3                	sub    %eax,%ebx
  80085f:	89 d8                	mov    %ebx,%eax
  800861:	50                   	push   %eax
  800862:	68 ed 3f 80 00       	push   $0x803fed
  800867:	68 a2 00 00 00       	push   $0xa2
  80086c:	68 5c 3e 80 00       	push   $0x803e5c
  800871:	e8 4c 06 00 00       	call   800ec2 <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800876:	e8 55 1c 00 00       	call   8024d0 <sys_calculate_free_frames>
  80087b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80087e:	e8 ed 1c 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800883:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800886:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800889:	01 c0                	add    %eax,%eax
  80088b:	83 ec 0c             	sub    $0xc,%esp
  80088e:	50                   	push   %eax
  80088f:	e8 0e 18 00 00       	call   8020a2 <malloc>
  800894:	83 c4 10             	add    $0x10,%esp
  800897:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80089a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80089d:	89 c2                	mov    %eax,%edx
  80089f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a2:	c1 e0 03             	shl    $0x3,%eax
  8008a5:	05 00 00 00 80       	add    $0x80000000,%eax
  8008aa:	39 c2                	cmp    %eax,%edx
  8008ac:	74 17                	je     8008c5 <_main+0x88d>
  8008ae:	83 ec 04             	sub    $0x4,%esp
  8008b1:	68 80 3f 80 00       	push   $0x803f80
  8008b6:	68 a8 00 00 00       	push   $0xa8
  8008bb:	68 5c 3e 80 00       	push   $0x803e5c
  8008c0:	e8 fd 05 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8008c5:	e8 a6 1c 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  8008ca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 62 3f 80 00       	push   $0x803f62
  8008d7:	68 aa 00 00 00       	push   $0xaa
  8008dc:	68 5c 3e 80 00       	push   $0x803e5c
  8008e1:	e8 dc 05 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008e6:	e8 e5 1b 00 00       	call   8024d0 <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 b0 3f 80 00       	push   $0x803fb0
  8008fc:	68 ab 00 00 00       	push   $0xab
  800901:	68 5c 3e 80 00       	push   $0x803e5c
  800906:	e8 b7 05 00 00       	call   800ec2 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  80090b:	e8 c0 1b 00 00       	call   8024d0 <sys_calculate_free_frames>
  800910:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800913:	e8 58 1c 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800918:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//ptr_allocations[12] = malloc(4*Mega - kilo);
		ptr_allocations[12] = smalloc("b", 4*Mega - kilo, 0);
  80091b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091e:	c1 e0 02             	shl    $0x2,%eax
  800921:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	6a 00                	push   $0x0
  800929:	50                   	push   %eax
  80092a:	68 02 40 80 00       	push   $0x804002
  80092f:	e8 bd 18 00 00       	call   8021f1 <smalloc>
  800934:	83 c4 10             	add    $0x10,%esp
  800937:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  80093a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80093d:	89 c1                	mov    %eax,%ecx
  80093f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800942:	89 d0                	mov    %edx,%eax
  800944:	01 c0                	add    %eax,%eax
  800946:	01 d0                	add    %edx,%eax
  800948:	01 c0                	add    %eax,%eax
  80094a:	01 d0                	add    %edx,%eax
  80094c:	01 c0                	add    %eax,%eax
  80094e:	05 00 00 00 80       	add    $0x80000000,%eax
  800953:	39 c1                	cmp    %eax,%ecx
  800955:	74 17                	je     80096e <_main+0x936>
  800957:	83 ec 04             	sub    $0x4,%esp
  80095a:	68 80 3f 80 00       	push   $0x803f80
  80095f:	68 b2 00 00 00       	push   $0xb2
  800964:	68 5c 3e 80 00       	push   $0x803e5c
  800969:	e8 54 05 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1024+1+2) panic("Wrong allocation: ");
  80096e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800971:	e8 5a 1b 00 00       	call   8024d0 <sys_calculate_free_frames>
  800976:	29 c3                	sub    %eax,%ebx
  800978:	89 d8                	mov    %ebx,%eax
  80097a:	3d 03 04 00 00       	cmp    $0x403,%eax
  80097f:	74 17                	je     800998 <_main+0x960>
  800981:	83 ec 04             	sub    $0x4,%esp
  800984:	68 b0 3f 80 00       	push   $0x803fb0
  800989:	68 b3 00 00 00       	push   $0xb3
  80098e:	68 5c 3e 80 00       	push   $0x803e5c
  800993:	e8 2a 05 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800998:	e8 d3 1b 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 62 3f 80 00       	push   $0x803f62
  8009aa:	68 b4 00 00 00       	push   $0xb4
  8009af:	68 5c 3e 80 00       	push   $0x803e5c
  8009b4:	e8 09 05 00 00       	call   800ec2 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  8009b9:	e8 12 1b 00 00       	call   8024d0 <sys_calculate_free_frames>
  8009be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009c1:	e8 aa 1b 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  8009c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  8009c9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8009cc:	83 ec 0c             	sub    $0xc,%esp
  8009cf:	50                   	push   %eax
  8009d0:	e8 48 17 00 00       	call   80211d <free>
  8009d5:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009d8:	e8 93 1b 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  8009dd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009e0:	74 17                	je     8009f9 <_main+0x9c1>
  8009e2:	83 ec 04             	sub    $0x4,%esp
  8009e5:	68 c7 3f 80 00       	push   $0x803fc7
  8009ea:	68 bf 00 00 00       	push   $0xbf
  8009ef:	68 5c 3e 80 00       	push   $0x803e5c
  8009f4:	e8 c9 04 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009f9:	e8 d2 1a 00 00       	call   8024d0 <sys_calculate_free_frames>
  8009fe:	89 c2                	mov    %eax,%edx
  800a00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a03:	39 c2                	cmp    %eax,%edx
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 de 3f 80 00       	push   $0x803fde
  800a0f:	68 c0 00 00 00       	push   $0xc0
  800a14:	68 5c 3e 80 00       	push   $0x803e5c
  800a19:	e8 a4 04 00 00       	call   800ec2 <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a1e:	e8 ad 1a 00 00       	call   8024d0 <sys_calculate_free_frames>
  800a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a26:	e8 45 1b 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800a2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  800a2e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800a31:	83 ec 0c             	sub    $0xc,%esp
  800a34:	50                   	push   %eax
  800a35:	e8 e3 16 00 00       	call   80211d <free>
  800a3a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a3d:	e8 2e 1b 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800a42:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800a45:	74 17                	je     800a5e <_main+0xa26>
  800a47:	83 ec 04             	sub    $0x4,%esp
  800a4a:	68 c7 3f 80 00       	push   $0x803fc7
  800a4f:	68 c7 00 00 00       	push   $0xc7
  800a54:	68 5c 3e 80 00       	push   $0x803e5c
  800a59:	e8 64 04 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a5e:	e8 6d 1a 00 00       	call   8024d0 <sys_calculate_free_frames>
  800a63:	89 c2                	mov    %eax,%edx
  800a65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a68:	39 c2                	cmp    %eax,%edx
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 de 3f 80 00       	push   $0x803fde
  800a74:	68 c8 00 00 00       	push   $0xc8
  800a79:	68 5c 3e 80 00       	push   $0x803e5c
  800a7e:	e8 3f 04 00 00       	call   800ec2 <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 48 1a 00 00       	call   8024d0 <sys_calculate_free_frames>
  800a88:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 e0 1a 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800a90:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800a93:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	50                   	push   %eax
  800a9a:	e8 7e 16 00 00       	call   80211d <free>
  800a9f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800aa2:	e8 c9 1a 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800aa7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800aaa:	74 17                	je     800ac3 <_main+0xa8b>
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	68 c7 3f 80 00       	push   $0x803fc7
  800ab4:	68 cf 00 00 00       	push   $0xcf
  800ab9:	68 5c 3e 80 00       	push   $0x803e5c
  800abe:	e8 ff 03 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800ac3:	e8 08 1a 00 00       	call   8024d0 <sys_calculate_free_frames>
  800ac8:	89 c2                	mov    %eax,%edx
  800aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acd:	39 c2                	cmp    %eax,%edx
  800acf:	74 17                	je     800ae8 <_main+0xab0>
  800ad1:	83 ec 04             	sub    $0x4,%esp
  800ad4:	68 de 3f 80 00       	push   $0x803fde
  800ad9:	68 d0 00 00 00       	push   $0xd0
  800ade:	68 5c 3e 80 00       	push   $0x803e5c
  800ae3:	e8 da 03 00 00       	call   800ec2 <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 1 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800ae8:	e8 e3 19 00 00       	call   8024d0 <sys_calculate_free_frames>
  800aed:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800af0:	e8 7b 1a 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800af5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[13] = malloc(1*Mega + 256*kilo - kilo);
  800af8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800afb:	c1 e0 08             	shl    $0x8,%eax
  800afe:	89 c2                	mov    %eax,%edx
  800b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b03:	01 d0                	add    %edx,%eax
  800b05:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800b08:	83 ec 0c             	sub    $0xc,%esp
  800b0b:	50                   	push   %eax
  800b0c:	e8 91 15 00 00       	call   8020a2 <malloc>
  800b11:	83 c4 10             	add    $0x10,%esp
  800b14:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800b17:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b1a:	89 c1                	mov    %eax,%ecx
  800b1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b1f:	89 d0                	mov    %edx,%eax
  800b21:	01 c0                	add    %eax,%eax
  800b23:	01 d0                	add    %edx,%eax
  800b25:	c1 e0 08             	shl    $0x8,%eax
  800b28:	89 c2                	mov    %eax,%edx
  800b2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b2d:	01 d0                	add    %edx,%eax
  800b2f:	05 00 00 00 80       	add    $0x80000000,%eax
  800b34:	39 c1                	cmp    %eax,%ecx
  800b36:	74 17                	je     800b4f <_main+0xb17>
  800b38:	83 ec 04             	sub    $0x4,%esp
  800b3b:	68 80 3f 80 00       	push   $0x803f80
  800b40:	68 da 00 00 00       	push   $0xda
  800b45:	68 5c 3e 80 00       	push   $0x803e5c
  800b4a:	e8 73 03 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b4f:	e8 1c 1a 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800b54:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800b57:	74 17                	je     800b70 <_main+0xb38>
  800b59:	83 ec 04             	sub    $0x4,%esp
  800b5c:	68 62 3f 80 00       	push   $0x803f62
  800b61:	68 dc 00 00 00       	push   $0xdc
  800b66:	68 5c 3e 80 00       	push   $0x803e5c
  800b6b:	e8 52 03 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b70:	e8 5b 19 00 00       	call   8024d0 <sys_calculate_free_frames>
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b7a:	39 c2                	cmp    %eax,%edx
  800b7c:	74 17                	je     800b95 <_main+0xb5d>
  800b7e:	83 ec 04             	sub    $0x4,%esp
  800b81:	68 b0 3f 80 00       	push   $0x803fb0
  800b86:	68 dd 00 00 00       	push   $0xdd
  800b8b:	68 5c 3e 80 00       	push   $0x803e5c
  800b90:	e8 2d 03 00 00       	call   800ec2 <_panic>

		//Allocate Shared 4 MB [should be placed at the end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800b95:	e8 36 19 00 00       	call   8024d0 <sys_calculate_free_frames>
  800b9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800b9d:	e8 ce 19 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800ba2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[14] = smalloc("w", 4*Mega, 0);
  800ba5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ba8:	c1 e0 02             	shl    $0x2,%eax
  800bab:	83 ec 04             	sub    $0x4,%esp
  800bae:	6a 00                	push   $0x0
  800bb0:	50                   	push   %eax
  800bb1:	68 04 40 80 00       	push   $0x804004
  800bb6:	e8 36 16 00 00       	call   8021f1 <smalloc>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (ptr_allocations[14] != (uint32*)(USER_HEAP_START + 18*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800bc1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800bc4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bc7:	89 d0                	mov    %edx,%eax
  800bc9:	c1 e0 03             	shl    $0x3,%eax
  800bcc:	01 d0                	add    %edx,%eax
  800bce:	01 c0                	add    %eax,%eax
  800bd0:	05 00 00 00 80       	add    $0x80000000,%eax
  800bd5:	39 c1                	cmp    %eax,%ecx
  800bd7:	74 17                	je     800bf0 <_main+0xbb8>
  800bd9:	83 ec 04             	sub    $0x4,%esp
  800bdc:	68 78 3e 80 00       	push   $0x803e78
  800be1:	68 e3 00 00 00       	push   $0xe3
  800be6:	68 5c 3e 80 00       	push   $0x803e5c
  800beb:	e8 d2 02 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1024+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800bf0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800bf3:	e8 d8 18 00 00       	call   8024d0 <sys_calculate_free_frames>
  800bf8:	29 c3                	sub    %eax,%ebx
  800bfa:	89 d8                	mov    %ebx,%eax
  800bfc:	3d 03 04 00 00       	cmp    $0x403,%eax
  800c01:	74 17                	je     800c1a <_main+0xbe2>
  800c03:	83 ec 04             	sub    $0x4,%esp
  800c06:	68 e4 3e 80 00       	push   $0x803ee4
  800c0b:	68 e4 00 00 00       	push   $0xe4
  800c10:	68 5c 3e 80 00       	push   $0x803e5c
  800c15:	e8 a8 02 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c1a:	e8 51 19 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800c1f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800c22:	74 17                	je     800c3b <_main+0xc03>
  800c24:	83 ec 04             	sub    $0x4,%esp
  800c27:	68 62 3f 80 00       	push   $0x803f62
  800c2c:	68 e5 00 00 00       	push   $0xe5
  800c31:	68 5c 3e 80 00       	push   $0x803e5c
  800c36:	e8 87 02 00 00       	call   800ec2 <_panic>

		//Get shared of 3 MB [should be placed in the remaining part of the contiguous (256 KB + 4 MB) hole
		freeFrames = sys_calculate_free_frames() ;
  800c3b:	e8 90 18 00 00       	call   8024d0 <sys_calculate_free_frames>
  800c40:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c43:	e8 28 19 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800c48:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[15] = sget(envID, "z");
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	68 c5 3f 80 00       	push   $0x803fc5
  800c53:	ff 75 ec             	pushl  -0x14(%ebp)
  800c56:	e8 3f 16 00 00       	call   80229a <sget>
  800c5b:	83 c4 10             	add    $0x10,%esp
  800c5e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (ptr_allocations[15] != (uint32*)(USER_HEAP_START + 3*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800c61:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c67:	89 c1                	mov    %eax,%ecx
  800c69:	01 c9                	add    %ecx,%ecx
  800c6b:	01 c8                	add    %ecx,%eax
  800c6d:	05 00 00 00 80       	add    $0x80000000,%eax
  800c72:	39 c2                	cmp    %eax,%edx
  800c74:	74 17                	je     800c8d <_main+0xc55>
  800c76:	83 ec 04             	sub    $0x4,%esp
  800c79:	68 78 3e 80 00       	push   $0x803e78
  800c7e:	68 eb 00 00 00       	push   $0xeb
  800c83:	68 5c 3e 80 00       	push   $0x803e5c
  800c88:	e8 35 02 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800c8d:	e8 3e 18 00 00       	call   8024d0 <sys_calculate_free_frames>
  800c92:	89 c2                	mov    %eax,%edx
  800c94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	74 17                	je     800cb2 <_main+0xc7a>
  800c9b:	83 ec 04             	sub    $0x4,%esp
  800c9e:	68 e4 3e 80 00       	push   $0x803ee4
  800ca3:	68 ec 00 00 00       	push   $0xec
  800ca8:	68 5c 3e 80 00       	push   $0x803e5c
  800cad:	e8 10 02 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800cb2:	e8 b9 18 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800cb7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800cba:	74 17                	je     800cd3 <_main+0xc9b>
  800cbc:	83 ec 04             	sub    $0x4,%esp
  800cbf:	68 62 3f 80 00       	push   $0x803f62
  800cc4:	68 ed 00 00 00       	push   $0xed
  800cc9:	68 5c 3e 80 00       	push   $0x803e5c
  800cce:	e8 ef 01 00 00       	call   800ec2 <_panic>

		//Get shared of 1st 1 MB [should be placed in the remaining part of the 3 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800cd3:	e8 f8 17 00 00       	call   8024d0 <sys_calculate_free_frames>
  800cd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800cdb:	e8 90 18 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800ce0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[16] = sget(envID, "x");
  800ce3:	83 ec 08             	sub    $0x8,%esp
  800ce6:	68 73 3e 80 00       	push   $0x803e73
  800ceb:	ff 75 ec             	pushl  -0x14(%ebp)
  800cee:	e8 a7 15 00 00       	call   80229a <sget>
  800cf3:	83 c4 10             	add    $0x10,%esp
  800cf6:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (ptr_allocations[16] != (uint32*)(USER_HEAP_START + 10*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800cf9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800cfc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800cff:	89 d0                	mov    %edx,%eax
  800d01:	c1 e0 02             	shl    $0x2,%eax
  800d04:	01 d0                	add    %edx,%eax
  800d06:	01 c0                	add    %eax,%eax
  800d08:	05 00 00 00 80       	add    $0x80000000,%eax
  800d0d:	39 c1                	cmp    %eax,%ecx
  800d0f:	74 17                	je     800d28 <_main+0xcf0>
  800d11:	83 ec 04             	sub    $0x4,%esp
  800d14:	68 78 3e 80 00       	push   $0x803e78
  800d19:	68 f3 00 00 00       	push   $0xf3
  800d1e:	68 5c 3e 80 00       	push   $0x803e5c
  800d23:	e8 9a 01 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800d28:	e8 a3 17 00 00       	call   8024d0 <sys_calculate_free_frames>
  800d2d:	89 c2                	mov    %eax,%edx
  800d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d32:	39 c2                	cmp    %eax,%edx
  800d34:	74 17                	je     800d4d <_main+0xd15>
  800d36:	83 ec 04             	sub    $0x4,%esp
  800d39:	68 e4 3e 80 00       	push   $0x803ee4
  800d3e:	68 f4 00 00 00       	push   $0xf4
  800d43:	68 5c 3e 80 00       	push   $0x803e5c
  800d48:	e8 75 01 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800d4d:	e8 1e 18 00 00       	call   802570 <sys_pf_calculate_allocated_pages>
  800d52:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800d55:	74 17                	je     800d6e <_main+0xd36>
  800d57:	83 ec 04             	sub    $0x4,%esp
  800d5a:	68 62 3f 80 00       	push   $0x803f62
  800d5f:	68 f5 00 00 00       	push   $0xf5
  800d64:	68 5c 3e 80 00       	push   $0x803e5c
  800d69:	e8 54 01 00 00       	call   800ec2 <_panic>

	}
	cprintf("Congratulations!! test FIRST FIT allocation (3) completed successfully.\n");
  800d6e:	83 ec 0c             	sub    $0xc,%esp
  800d71:	68 08 40 80 00       	push   $0x804008
  800d76:	e8 fb 03 00 00       	call   801176 <cprintf>
  800d7b:	83 c4 10             	add    $0x10,%esp

	return;
  800d7e:	90                   	nop
}
  800d7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d82:	5b                   	pop    %ebx
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800d8c:	e8 1f 1a 00 00       	call   8027b0 <sys_getenvindex>
  800d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d97:	89 d0                	mov    %edx,%eax
  800d99:	c1 e0 03             	shl    $0x3,%eax
  800d9c:	01 d0                	add    %edx,%eax
  800d9e:	01 c0                	add    %eax,%eax
  800da0:	01 d0                	add    %edx,%eax
  800da2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800da9:	01 d0                	add    %edx,%eax
  800dab:	c1 e0 04             	shl    $0x4,%eax
  800dae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800db3:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800db8:	a1 20 50 80 00       	mov    0x805020,%eax
  800dbd:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800dc3:	84 c0                	test   %al,%al
  800dc5:	74 0f                	je     800dd6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800dc7:	a1 20 50 80 00       	mov    0x805020,%eax
  800dcc:	05 5c 05 00 00       	add    $0x55c,%eax
  800dd1:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800dd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dda:	7e 0a                	jle    800de6 <libmain+0x60>
		binaryname = argv[0];
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	8b 00                	mov    (%eax),%eax
  800de1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800de6:	83 ec 08             	sub    $0x8,%esp
  800de9:	ff 75 0c             	pushl  0xc(%ebp)
  800dec:	ff 75 08             	pushl  0x8(%ebp)
  800def:	e8 44 f2 ff ff       	call   800038 <_main>
  800df4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800df7:	e8 c1 17 00 00       	call   8025bd <sys_disable_interrupt>
	cprintf("**************************************\n");
  800dfc:	83 ec 0c             	sub    $0xc,%esp
  800dff:	68 6c 40 80 00       	push   $0x80406c
  800e04:	e8 6d 03 00 00       	call   801176 <cprintf>
  800e09:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800e0c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e11:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800e17:	a1 20 50 80 00       	mov    0x805020,%eax
  800e1c:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800e22:	83 ec 04             	sub    $0x4,%esp
  800e25:	52                   	push   %edx
  800e26:	50                   	push   %eax
  800e27:	68 94 40 80 00       	push   $0x804094
  800e2c:	e8 45 03 00 00       	call   801176 <cprintf>
  800e31:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800e34:	a1 20 50 80 00       	mov    0x805020,%eax
  800e39:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800e3f:	a1 20 50 80 00       	mov    0x805020,%eax
  800e44:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800e4a:	a1 20 50 80 00       	mov    0x805020,%eax
  800e4f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800e55:	51                   	push   %ecx
  800e56:	52                   	push   %edx
  800e57:	50                   	push   %eax
  800e58:	68 bc 40 80 00       	push   $0x8040bc
  800e5d:	e8 14 03 00 00       	call   801176 <cprintf>
  800e62:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800e65:	a1 20 50 80 00       	mov    0x805020,%eax
  800e6a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800e70:	83 ec 08             	sub    $0x8,%esp
  800e73:	50                   	push   %eax
  800e74:	68 14 41 80 00       	push   $0x804114
  800e79:	e8 f8 02 00 00       	call   801176 <cprintf>
  800e7e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	68 6c 40 80 00       	push   $0x80406c
  800e89:	e8 e8 02 00 00       	call   801176 <cprintf>
  800e8e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800e91:	e8 41 17 00 00       	call   8025d7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800e96:	e8 19 00 00 00       	call   800eb4 <exit>
}
  800e9b:	90                   	nop
  800e9c:	c9                   	leave  
  800e9d:	c3                   	ret    

00800e9e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800ea4:	83 ec 0c             	sub    $0xc,%esp
  800ea7:	6a 00                	push   $0x0
  800ea9:	e8 ce 18 00 00       	call   80277c <sys_destroy_env>
  800eae:	83 c4 10             	add    $0x10,%esp
}
  800eb1:	90                   	nop
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <exit>:

void
exit(void)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800eba:	e8 23 19 00 00       	call   8027e2 <sys_exit_env>
}
  800ebf:	90                   	nop
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800ec8:	8d 45 10             	lea    0x10(%ebp),%eax
  800ecb:	83 c0 04             	add    $0x4,%eax
  800ece:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ed1:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ed6:	85 c0                	test   %eax,%eax
  800ed8:	74 16                	je     800ef0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800eda:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800edf:	83 ec 08             	sub    $0x8,%esp
  800ee2:	50                   	push   %eax
  800ee3:	68 28 41 80 00       	push   $0x804128
  800ee8:	e8 89 02 00 00       	call   801176 <cprintf>
  800eed:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ef0:	a1 00 50 80 00       	mov    0x805000,%eax
  800ef5:	ff 75 0c             	pushl  0xc(%ebp)
  800ef8:	ff 75 08             	pushl  0x8(%ebp)
  800efb:	50                   	push   %eax
  800efc:	68 2d 41 80 00       	push   $0x80412d
  800f01:	e8 70 02 00 00       	call   801176 <cprintf>
  800f06:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	83 ec 08             	sub    $0x8,%esp
  800f0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f12:	50                   	push   %eax
  800f13:	e8 f3 01 00 00       	call   80110b <vcprintf>
  800f18:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800f1b:	83 ec 08             	sub    $0x8,%esp
  800f1e:	6a 00                	push   $0x0
  800f20:	68 49 41 80 00       	push   $0x804149
  800f25:	e8 e1 01 00 00       	call   80110b <vcprintf>
  800f2a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800f2d:	e8 82 ff ff ff       	call   800eb4 <exit>

	// should not return here
	while (1) ;
  800f32:	eb fe                	jmp    800f32 <_panic+0x70>

00800f34 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800f3a:	a1 20 50 80 00       	mov    0x805020,%eax
  800f3f:	8b 50 74             	mov    0x74(%eax),%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	39 c2                	cmp    %eax,%edx
  800f47:	74 14                	je     800f5d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800f49:	83 ec 04             	sub    $0x4,%esp
  800f4c:	68 4c 41 80 00       	push   $0x80414c
  800f51:	6a 26                	push   $0x26
  800f53:	68 98 41 80 00       	push   $0x804198
  800f58:	e8 65 ff ff ff       	call   800ec2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800f5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800f64:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f6b:	e9 c2 00 00 00       	jmp    801032 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f73:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	01 d0                	add    %edx,%eax
  800f7f:	8b 00                	mov    (%eax),%eax
  800f81:	85 c0                	test   %eax,%eax
  800f83:	75 08                	jne    800f8d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800f85:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800f88:	e9 a2 00 00 00       	jmp    80102f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800f8d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f94:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800f9b:	eb 69                	jmp    801006 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800f9d:	a1 20 50 80 00       	mov    0x805020,%eax
  800fa2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800fa8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800fab:	89 d0                	mov    %edx,%eax
  800fad:	01 c0                	add    %eax,%eax
  800faf:	01 d0                	add    %edx,%eax
  800fb1:	c1 e0 03             	shl    $0x3,%eax
  800fb4:	01 c8                	add    %ecx,%eax
  800fb6:	8a 40 04             	mov    0x4(%eax),%al
  800fb9:	84 c0                	test   %al,%al
  800fbb:	75 46                	jne    801003 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800fbd:	a1 20 50 80 00       	mov    0x805020,%eax
  800fc2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800fc8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800fcb:	89 d0                	mov    %edx,%eax
  800fcd:	01 c0                	add    %eax,%eax
  800fcf:	01 d0                	add    %edx,%eax
  800fd1:	c1 e0 03             	shl    $0x3,%eax
  800fd4:	01 c8                	add    %ecx,%eax
  800fd6:	8b 00                	mov    (%eax),%eax
  800fd8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800fdb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800fde:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fe3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	01 c8                	add    %ecx,%eax
  800ff4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ff6:	39 c2                	cmp    %eax,%edx
  800ff8:	75 09                	jne    801003 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800ffa:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801001:	eb 12                	jmp    801015 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801003:	ff 45 e8             	incl   -0x18(%ebp)
  801006:	a1 20 50 80 00       	mov    0x805020,%eax
  80100b:	8b 50 74             	mov    0x74(%eax),%edx
  80100e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801011:	39 c2                	cmp    %eax,%edx
  801013:	77 88                	ja     800f9d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801015:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801019:	75 14                	jne    80102f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80101b:	83 ec 04             	sub    $0x4,%esp
  80101e:	68 a4 41 80 00       	push   $0x8041a4
  801023:	6a 3a                	push   $0x3a
  801025:	68 98 41 80 00       	push   $0x804198
  80102a:	e8 93 fe ff ff       	call   800ec2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80102f:	ff 45 f0             	incl   -0x10(%ebp)
  801032:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801035:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801038:	0f 8c 32 ff ff ff    	jl     800f70 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80103e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801045:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80104c:	eb 26                	jmp    801074 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80104e:	a1 20 50 80 00       	mov    0x805020,%eax
  801053:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801059:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80105c:	89 d0                	mov    %edx,%eax
  80105e:	01 c0                	add    %eax,%eax
  801060:	01 d0                	add    %edx,%eax
  801062:	c1 e0 03             	shl    $0x3,%eax
  801065:	01 c8                	add    %ecx,%eax
  801067:	8a 40 04             	mov    0x4(%eax),%al
  80106a:	3c 01                	cmp    $0x1,%al
  80106c:	75 03                	jne    801071 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80106e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801071:	ff 45 e0             	incl   -0x20(%ebp)
  801074:	a1 20 50 80 00       	mov    0x805020,%eax
  801079:	8b 50 74             	mov    0x74(%eax),%edx
  80107c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80107f:	39 c2                	cmp    %eax,%edx
  801081:	77 cb                	ja     80104e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801086:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801089:	74 14                	je     80109f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80108b:	83 ec 04             	sub    $0x4,%esp
  80108e:	68 f8 41 80 00       	push   $0x8041f8
  801093:	6a 44                	push   $0x44
  801095:	68 98 41 80 00       	push   $0x804198
  80109a:	e8 23 fe ff ff       	call   800ec2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80109f:	90                   	nop
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8010a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ab:	8b 00                	mov    (%eax),%eax
  8010ad:	8d 48 01             	lea    0x1(%eax),%ecx
  8010b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b3:	89 0a                	mov    %ecx,(%edx)
  8010b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b8:	88 d1                	mov    %dl,%cl
  8010ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8010c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c4:	8b 00                	mov    (%eax),%eax
  8010c6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8010cb:	75 2c                	jne    8010f9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8010cd:	a0 24 50 80 00       	mov    0x805024,%al
  8010d2:	0f b6 c0             	movzbl %al,%eax
  8010d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d8:	8b 12                	mov    (%edx),%edx
  8010da:	89 d1                	mov    %edx,%ecx
  8010dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010df:	83 c2 08             	add    $0x8,%edx
  8010e2:	83 ec 04             	sub    $0x4,%esp
  8010e5:	50                   	push   %eax
  8010e6:	51                   	push   %ecx
  8010e7:	52                   	push   %edx
  8010e8:	e8 22 13 00 00       	call   80240f <sys_cputs>
  8010ed:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8010f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fc:	8b 40 04             	mov    0x4(%eax),%eax
  8010ff:	8d 50 01             	lea    0x1(%eax),%edx
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	89 50 04             	mov    %edx,0x4(%eax)
}
  801108:	90                   	nop
  801109:	c9                   	leave  
  80110a:	c3                   	ret    

0080110b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801114:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80111b:	00 00 00 
	b.cnt = 0;
  80111e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801125:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801128:	ff 75 0c             	pushl  0xc(%ebp)
  80112b:	ff 75 08             	pushl  0x8(%ebp)
  80112e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801134:	50                   	push   %eax
  801135:	68 a2 10 80 00       	push   $0x8010a2
  80113a:	e8 11 02 00 00       	call   801350 <vprintfmt>
  80113f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801142:	a0 24 50 80 00       	mov    0x805024,%al
  801147:	0f b6 c0             	movzbl %al,%eax
  80114a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801150:	83 ec 04             	sub    $0x4,%esp
  801153:	50                   	push   %eax
  801154:	52                   	push   %edx
  801155:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80115b:	83 c0 08             	add    $0x8,%eax
  80115e:	50                   	push   %eax
  80115f:	e8 ab 12 00 00       	call   80240f <sys_cputs>
  801164:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801167:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80116e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801174:	c9                   	leave  
  801175:	c3                   	ret    

00801176 <cprintf>:

int cprintf(const char *fmt, ...) {
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80117c:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801183:	8d 45 0c             	lea    0xc(%ebp),%eax
  801186:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	83 ec 08             	sub    $0x8,%esp
  80118f:	ff 75 f4             	pushl  -0xc(%ebp)
  801192:	50                   	push   %eax
  801193:	e8 73 ff ff ff       	call   80110b <vcprintf>
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80119e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011a1:	c9                   	leave  
  8011a2:	c3                   	ret    

008011a3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011a9:	e8 0f 14 00 00       	call   8025bd <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8011ae:	8d 45 0c             	lea    0xc(%ebp),%eax
  8011b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	83 ec 08             	sub    $0x8,%esp
  8011ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8011bd:	50                   	push   %eax
  8011be:	e8 48 ff ff ff       	call   80110b <vcprintf>
  8011c3:	83 c4 10             	add    $0x10,%esp
  8011c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8011c9:	e8 09 14 00 00       	call   8025d7 <sys_enable_interrupt>
	return cnt;
  8011ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	53                   	push   %ebx
  8011d7:	83 ec 14             	sub    $0x14,%esp
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011e6:	8b 45 18             	mov    0x18(%ebp),%eax
  8011e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8011f1:	77 55                	ja     801248 <printnum+0x75>
  8011f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8011f6:	72 05                	jb     8011fd <printnum+0x2a>
  8011f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011fb:	77 4b                	ja     801248 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011fd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801200:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801203:	8b 45 18             	mov    0x18(%ebp),%eax
  801206:	ba 00 00 00 00       	mov    $0x0,%edx
  80120b:	52                   	push   %edx
  80120c:	50                   	push   %eax
  80120d:	ff 75 f4             	pushl  -0xc(%ebp)
  801210:	ff 75 f0             	pushl  -0x10(%ebp)
  801213:	e8 b4 29 00 00       	call   803bcc <__udivdi3>
  801218:	83 c4 10             	add    $0x10,%esp
  80121b:	83 ec 04             	sub    $0x4,%esp
  80121e:	ff 75 20             	pushl  0x20(%ebp)
  801221:	53                   	push   %ebx
  801222:	ff 75 18             	pushl  0x18(%ebp)
  801225:	52                   	push   %edx
  801226:	50                   	push   %eax
  801227:	ff 75 0c             	pushl  0xc(%ebp)
  80122a:	ff 75 08             	pushl  0x8(%ebp)
  80122d:	e8 a1 ff ff ff       	call   8011d3 <printnum>
  801232:	83 c4 20             	add    $0x20,%esp
  801235:	eb 1a                	jmp    801251 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801237:	83 ec 08             	sub    $0x8,%esp
  80123a:	ff 75 0c             	pushl  0xc(%ebp)
  80123d:	ff 75 20             	pushl  0x20(%ebp)
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	ff d0                	call   *%eax
  801245:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801248:	ff 4d 1c             	decl   0x1c(%ebp)
  80124b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80124f:	7f e6                	jg     801237 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801251:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801254:	bb 00 00 00 00       	mov    $0x0,%ebx
  801259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125f:	53                   	push   %ebx
  801260:	51                   	push   %ecx
  801261:	52                   	push   %edx
  801262:	50                   	push   %eax
  801263:	e8 74 2a 00 00       	call   803cdc <__umoddi3>
  801268:	83 c4 10             	add    $0x10,%esp
  80126b:	05 74 44 80 00       	add    $0x804474,%eax
  801270:	8a 00                	mov    (%eax),%al
  801272:	0f be c0             	movsbl %al,%eax
  801275:	83 ec 08             	sub    $0x8,%esp
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	50                   	push   %eax
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	ff d0                	call   *%eax
  801281:	83 c4 10             	add    $0x10,%esp
}
  801284:	90                   	nop
  801285:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80128d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801291:	7e 1c                	jle    8012af <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8d 50 08             	lea    0x8(%eax),%edx
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	89 10                	mov    %edx,(%eax)
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	8b 00                	mov    (%eax),%eax
  8012a5:	83 e8 08             	sub    $0x8,%eax
  8012a8:	8b 50 04             	mov    0x4(%eax),%edx
  8012ab:	8b 00                	mov    (%eax),%eax
  8012ad:	eb 40                	jmp    8012ef <getuint+0x65>
	else if (lflag)
  8012af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b3:	74 1e                	je     8012d3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8b 00                	mov    (%eax),%eax
  8012ba:	8d 50 04             	lea    0x4(%eax),%edx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	89 10                	mov    %edx,(%eax)
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8b 00                	mov    (%eax),%eax
  8012c7:	83 e8 04             	sub    $0x4,%eax
  8012ca:	8b 00                	mov    (%eax),%eax
  8012cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d1:	eb 1c                	jmp    8012ef <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8b 00                	mov    (%eax),%eax
  8012d8:	8d 50 04             	lea    0x4(%eax),%edx
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	89 10                	mov    %edx,(%eax)
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	8b 00                	mov    (%eax),%eax
  8012e5:	83 e8 04             	sub    $0x4,%eax
  8012e8:	8b 00                	mov    (%eax),%eax
  8012ea:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8012ef:	5d                   	pop    %ebp
  8012f0:	c3                   	ret    

008012f1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8012f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8012f8:	7e 1c                	jle    801316 <getint+0x25>
		return va_arg(*ap, long long);
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	8b 00                	mov    (%eax),%eax
  8012ff:	8d 50 08             	lea    0x8(%eax),%edx
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	89 10                	mov    %edx,(%eax)
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8b 00                	mov    (%eax),%eax
  80130c:	83 e8 08             	sub    $0x8,%eax
  80130f:	8b 50 04             	mov    0x4(%eax),%edx
  801312:	8b 00                	mov    (%eax),%eax
  801314:	eb 38                	jmp    80134e <getint+0x5d>
	else if (lflag)
  801316:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80131a:	74 1a                	je     801336 <getint+0x45>
		return va_arg(*ap, long);
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8b 00                	mov    (%eax),%eax
  801321:	8d 50 04             	lea    0x4(%eax),%edx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	89 10                	mov    %edx,(%eax)
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8b 00                	mov    (%eax),%eax
  80132e:	83 e8 04             	sub    $0x4,%eax
  801331:	8b 00                	mov    (%eax),%eax
  801333:	99                   	cltd   
  801334:	eb 18                	jmp    80134e <getint+0x5d>
	else
		return va_arg(*ap, int);
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8b 00                	mov    (%eax),%eax
  80133b:	8d 50 04             	lea    0x4(%eax),%edx
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	89 10                	mov    %edx,(%eax)
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	83 e8 04             	sub    $0x4,%eax
  80134b:	8b 00                	mov    (%eax),%eax
  80134d:	99                   	cltd   
}
  80134e:	5d                   	pop    %ebp
  80134f:	c3                   	ret    

00801350 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	56                   	push   %esi
  801354:	53                   	push   %ebx
  801355:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801358:	eb 17                	jmp    801371 <vprintfmt+0x21>
			if (ch == '\0')
  80135a:	85 db                	test   %ebx,%ebx
  80135c:	0f 84 af 03 00 00    	je     801711 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801362:	83 ec 08             	sub    $0x8,%esp
  801365:	ff 75 0c             	pushl  0xc(%ebp)
  801368:	53                   	push   %ebx
  801369:	8b 45 08             	mov    0x8(%ebp),%eax
  80136c:	ff d0                	call   *%eax
  80136e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801371:	8b 45 10             	mov    0x10(%ebp),%eax
  801374:	8d 50 01             	lea    0x1(%eax),%edx
  801377:	89 55 10             	mov    %edx,0x10(%ebp)
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	0f b6 d8             	movzbl %al,%ebx
  80137f:	83 fb 25             	cmp    $0x25,%ebx
  801382:	75 d6                	jne    80135a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801384:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801388:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80138f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801396:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80139d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8013a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a7:	8d 50 01             	lea    0x1(%eax),%edx
  8013aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ad:	8a 00                	mov    (%eax),%al
  8013af:	0f b6 d8             	movzbl %al,%ebx
  8013b2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8013b5:	83 f8 55             	cmp    $0x55,%eax
  8013b8:	0f 87 2b 03 00 00    	ja     8016e9 <vprintfmt+0x399>
  8013be:	8b 04 85 98 44 80 00 	mov    0x804498(,%eax,4),%eax
  8013c5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8013c7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8013cb:	eb d7                	jmp    8013a4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8013cd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8013d1:	eb d1                	jmp    8013a4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8013da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013dd:	89 d0                	mov    %edx,%eax
  8013df:	c1 e0 02             	shl    $0x2,%eax
  8013e2:	01 d0                	add    %edx,%eax
  8013e4:	01 c0                	add    %eax,%eax
  8013e6:	01 d8                	add    %ebx,%eax
  8013e8:	83 e8 30             	sub    $0x30,%eax
  8013eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8013ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8013f6:	83 fb 2f             	cmp    $0x2f,%ebx
  8013f9:	7e 3e                	jle    801439 <vprintfmt+0xe9>
  8013fb:	83 fb 39             	cmp    $0x39,%ebx
  8013fe:	7f 39                	jg     801439 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801400:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801403:	eb d5                	jmp    8013da <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801405:	8b 45 14             	mov    0x14(%ebp),%eax
  801408:	83 c0 04             	add    $0x4,%eax
  80140b:	89 45 14             	mov    %eax,0x14(%ebp)
  80140e:	8b 45 14             	mov    0x14(%ebp),%eax
  801411:	83 e8 04             	sub    $0x4,%eax
  801414:	8b 00                	mov    (%eax),%eax
  801416:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801419:	eb 1f                	jmp    80143a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80141b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80141f:	79 83                	jns    8013a4 <vprintfmt+0x54>
				width = 0;
  801421:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801428:	e9 77 ff ff ff       	jmp    8013a4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80142d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801434:	e9 6b ff ff ff       	jmp    8013a4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801439:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80143a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80143e:	0f 89 60 ff ff ff    	jns    8013a4 <vprintfmt+0x54>
				width = precision, precision = -1;
  801444:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801447:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80144a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801451:	e9 4e ff ff ff       	jmp    8013a4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801456:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801459:	e9 46 ff ff ff       	jmp    8013a4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80145e:	8b 45 14             	mov    0x14(%ebp),%eax
  801461:	83 c0 04             	add    $0x4,%eax
  801464:	89 45 14             	mov    %eax,0x14(%ebp)
  801467:	8b 45 14             	mov    0x14(%ebp),%eax
  80146a:	83 e8 04             	sub    $0x4,%eax
  80146d:	8b 00                	mov    (%eax),%eax
  80146f:	83 ec 08             	sub    $0x8,%esp
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	50                   	push   %eax
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	ff d0                	call   *%eax
  80147b:	83 c4 10             	add    $0x10,%esp
			break;
  80147e:	e9 89 02 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801483:	8b 45 14             	mov    0x14(%ebp),%eax
  801486:	83 c0 04             	add    $0x4,%eax
  801489:	89 45 14             	mov    %eax,0x14(%ebp)
  80148c:	8b 45 14             	mov    0x14(%ebp),%eax
  80148f:	83 e8 04             	sub    $0x4,%eax
  801492:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801494:	85 db                	test   %ebx,%ebx
  801496:	79 02                	jns    80149a <vprintfmt+0x14a>
				err = -err;
  801498:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80149a:	83 fb 64             	cmp    $0x64,%ebx
  80149d:	7f 0b                	jg     8014aa <vprintfmt+0x15a>
  80149f:	8b 34 9d e0 42 80 00 	mov    0x8042e0(,%ebx,4),%esi
  8014a6:	85 f6                	test   %esi,%esi
  8014a8:	75 19                	jne    8014c3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8014aa:	53                   	push   %ebx
  8014ab:	68 85 44 80 00       	push   $0x804485
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 5e 02 00 00       	call   801719 <printfmt>
  8014bb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8014be:	e9 49 02 00 00       	jmp    80170c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8014c3:	56                   	push   %esi
  8014c4:	68 8e 44 80 00       	push   $0x80448e
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	ff 75 08             	pushl  0x8(%ebp)
  8014cf:	e8 45 02 00 00       	call   801719 <printfmt>
  8014d4:	83 c4 10             	add    $0x10,%esp
			break;
  8014d7:	e9 30 02 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8014dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8014df:	83 c0 04             	add    $0x4,%eax
  8014e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8014e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e8:	83 e8 04             	sub    $0x4,%eax
  8014eb:	8b 30                	mov    (%eax),%esi
  8014ed:	85 f6                	test   %esi,%esi
  8014ef:	75 05                	jne    8014f6 <vprintfmt+0x1a6>
				p = "(null)";
  8014f1:	be 91 44 80 00       	mov    $0x804491,%esi
			if (width > 0 && padc != '-')
  8014f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014fa:	7e 6d                	jle    801569 <vprintfmt+0x219>
  8014fc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801500:	74 67                	je     801569 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801505:	83 ec 08             	sub    $0x8,%esp
  801508:	50                   	push   %eax
  801509:	56                   	push   %esi
  80150a:	e8 0c 03 00 00       	call   80181b <strnlen>
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801515:	eb 16                	jmp    80152d <vprintfmt+0x1dd>
					putch(padc, putdat);
  801517:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80151b:	83 ec 08             	sub    $0x8,%esp
  80151e:	ff 75 0c             	pushl  0xc(%ebp)
  801521:	50                   	push   %eax
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	ff d0                	call   *%eax
  801527:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80152a:	ff 4d e4             	decl   -0x1c(%ebp)
  80152d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801531:	7f e4                	jg     801517 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801533:	eb 34                	jmp    801569 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801535:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801539:	74 1c                	je     801557 <vprintfmt+0x207>
  80153b:	83 fb 1f             	cmp    $0x1f,%ebx
  80153e:	7e 05                	jle    801545 <vprintfmt+0x1f5>
  801540:	83 fb 7e             	cmp    $0x7e,%ebx
  801543:	7e 12                	jle    801557 <vprintfmt+0x207>
					putch('?', putdat);
  801545:	83 ec 08             	sub    $0x8,%esp
  801548:	ff 75 0c             	pushl  0xc(%ebp)
  80154b:	6a 3f                	push   $0x3f
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	ff d0                	call   *%eax
  801552:	83 c4 10             	add    $0x10,%esp
  801555:	eb 0f                	jmp    801566 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801557:	83 ec 08             	sub    $0x8,%esp
  80155a:	ff 75 0c             	pushl  0xc(%ebp)
  80155d:	53                   	push   %ebx
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
  801561:	ff d0                	call   *%eax
  801563:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801566:	ff 4d e4             	decl   -0x1c(%ebp)
  801569:	89 f0                	mov    %esi,%eax
  80156b:	8d 70 01             	lea    0x1(%eax),%esi
  80156e:	8a 00                	mov    (%eax),%al
  801570:	0f be d8             	movsbl %al,%ebx
  801573:	85 db                	test   %ebx,%ebx
  801575:	74 24                	je     80159b <vprintfmt+0x24b>
  801577:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80157b:	78 b8                	js     801535 <vprintfmt+0x1e5>
  80157d:	ff 4d e0             	decl   -0x20(%ebp)
  801580:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801584:	79 af                	jns    801535 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801586:	eb 13                	jmp    80159b <vprintfmt+0x24b>
				putch(' ', putdat);
  801588:	83 ec 08             	sub    $0x8,%esp
  80158b:	ff 75 0c             	pushl  0xc(%ebp)
  80158e:	6a 20                	push   $0x20
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	ff d0                	call   *%eax
  801595:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801598:	ff 4d e4             	decl   -0x1c(%ebp)
  80159b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80159f:	7f e7                	jg     801588 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8015a1:	e9 66 01 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8015a6:	83 ec 08             	sub    $0x8,%esp
  8015a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8015ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8015af:	50                   	push   %eax
  8015b0:	e8 3c fd ff ff       	call   8012f1 <getint>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8015be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c4:	85 d2                	test   %edx,%edx
  8015c6:	79 23                	jns    8015eb <vprintfmt+0x29b>
				putch('-', putdat);
  8015c8:	83 ec 08             	sub    $0x8,%esp
  8015cb:	ff 75 0c             	pushl  0xc(%ebp)
  8015ce:	6a 2d                	push   $0x2d
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	ff d0                	call   *%eax
  8015d5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8015d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015de:	f7 d8                	neg    %eax
  8015e0:	83 d2 00             	adc    $0x0,%edx
  8015e3:	f7 da                	neg    %edx
  8015e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8015eb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8015f2:	e9 bc 00 00 00       	jmp    8016b3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8015f7:	83 ec 08             	sub    $0x8,%esp
  8015fa:	ff 75 e8             	pushl  -0x18(%ebp)
  8015fd:	8d 45 14             	lea    0x14(%ebp),%eax
  801600:	50                   	push   %eax
  801601:	e8 84 fc ff ff       	call   80128a <getuint>
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80160c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80160f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801616:	e9 98 00 00 00       	jmp    8016b3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80161b:	83 ec 08             	sub    $0x8,%esp
  80161e:	ff 75 0c             	pushl  0xc(%ebp)
  801621:	6a 58                	push   $0x58
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	ff d0                	call   *%eax
  801628:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80162b:	83 ec 08             	sub    $0x8,%esp
  80162e:	ff 75 0c             	pushl  0xc(%ebp)
  801631:	6a 58                	push   $0x58
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	ff d0                	call   *%eax
  801638:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80163b:	83 ec 08             	sub    $0x8,%esp
  80163e:	ff 75 0c             	pushl  0xc(%ebp)
  801641:	6a 58                	push   $0x58
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	ff d0                	call   *%eax
  801648:	83 c4 10             	add    $0x10,%esp
			break;
  80164b:	e9 bc 00 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801650:	83 ec 08             	sub    $0x8,%esp
  801653:	ff 75 0c             	pushl  0xc(%ebp)
  801656:	6a 30                	push   $0x30
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	ff d0                	call   *%eax
  80165d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801660:	83 ec 08             	sub    $0x8,%esp
  801663:	ff 75 0c             	pushl  0xc(%ebp)
  801666:	6a 78                	push   $0x78
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	ff d0                	call   *%eax
  80166d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801670:	8b 45 14             	mov    0x14(%ebp),%eax
  801673:	83 c0 04             	add    $0x4,%eax
  801676:	89 45 14             	mov    %eax,0x14(%ebp)
  801679:	8b 45 14             	mov    0x14(%ebp),%eax
  80167c:	83 e8 04             	sub    $0x4,%eax
  80167f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801681:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801684:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80168b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801692:	eb 1f                	jmp    8016b3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801694:	83 ec 08             	sub    $0x8,%esp
  801697:	ff 75 e8             	pushl  -0x18(%ebp)
  80169a:	8d 45 14             	lea    0x14(%ebp),%eax
  80169d:	50                   	push   %eax
  80169e:	e8 e7 fb ff ff       	call   80128a <getuint>
  8016a3:	83 c4 10             	add    $0x10,%esp
  8016a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8016ac:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8016b3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8016b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ba:	83 ec 04             	sub    $0x4,%esp
  8016bd:	52                   	push   %edx
  8016be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016c1:	50                   	push   %eax
  8016c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c8:	ff 75 0c             	pushl  0xc(%ebp)
  8016cb:	ff 75 08             	pushl  0x8(%ebp)
  8016ce:	e8 00 fb ff ff       	call   8011d3 <printnum>
  8016d3:	83 c4 20             	add    $0x20,%esp
			break;
  8016d6:	eb 34                	jmp    80170c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8016d8:	83 ec 08             	sub    $0x8,%esp
  8016db:	ff 75 0c             	pushl  0xc(%ebp)
  8016de:	53                   	push   %ebx
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	ff d0                	call   *%eax
  8016e4:	83 c4 10             	add    $0x10,%esp
			break;
  8016e7:	eb 23                	jmp    80170c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8016e9:	83 ec 08             	sub    $0x8,%esp
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	6a 25                	push   $0x25
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	ff d0                	call   *%eax
  8016f6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8016f9:	ff 4d 10             	decl   0x10(%ebp)
  8016fc:	eb 03                	jmp    801701 <vprintfmt+0x3b1>
  8016fe:	ff 4d 10             	decl   0x10(%ebp)
  801701:	8b 45 10             	mov    0x10(%ebp),%eax
  801704:	48                   	dec    %eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	3c 25                	cmp    $0x25,%al
  801709:	75 f3                	jne    8016fe <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80170b:	90                   	nop
		}
	}
  80170c:	e9 47 fc ff ff       	jmp    801358 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801711:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801712:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801715:	5b                   	pop    %ebx
  801716:	5e                   	pop    %esi
  801717:	5d                   	pop    %ebp
  801718:	c3                   	ret    

00801719 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80171f:	8d 45 10             	lea    0x10(%ebp),%eax
  801722:	83 c0 04             	add    $0x4,%eax
  801725:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801728:	8b 45 10             	mov    0x10(%ebp),%eax
  80172b:	ff 75 f4             	pushl  -0xc(%ebp)
  80172e:	50                   	push   %eax
  80172f:	ff 75 0c             	pushl  0xc(%ebp)
  801732:	ff 75 08             	pushl  0x8(%ebp)
  801735:	e8 16 fc ff ff       	call   801350 <vprintfmt>
  80173a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80173d:	90                   	nop
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801743:	8b 45 0c             	mov    0xc(%ebp),%eax
  801746:	8b 40 08             	mov    0x8(%eax),%eax
  801749:	8d 50 01             	lea    0x1(%eax),%edx
  80174c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801752:	8b 45 0c             	mov    0xc(%ebp),%eax
  801755:	8b 10                	mov    (%eax),%edx
  801757:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175a:	8b 40 04             	mov    0x4(%eax),%eax
  80175d:	39 c2                	cmp    %eax,%edx
  80175f:	73 12                	jae    801773 <sprintputch+0x33>
		*b->buf++ = ch;
  801761:	8b 45 0c             	mov    0xc(%ebp),%eax
  801764:	8b 00                	mov    (%eax),%eax
  801766:	8d 48 01             	lea    0x1(%eax),%ecx
  801769:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176c:	89 0a                	mov    %ecx,(%edx)
  80176e:	8b 55 08             	mov    0x8(%ebp),%edx
  801771:	88 10                	mov    %dl,(%eax)
}
  801773:	90                   	nop
  801774:	5d                   	pop    %ebp
  801775:	c3                   	ret    

00801776 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801782:	8b 45 0c             	mov    0xc(%ebp),%eax
  801785:	8d 50 ff             	lea    -0x1(%eax),%edx
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	01 d0                	add    %edx,%eax
  80178d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801790:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801797:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80179b:	74 06                	je     8017a3 <vsnprintf+0x2d>
  80179d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017a1:	7f 07                	jg     8017aa <vsnprintf+0x34>
		return -E_INVAL;
  8017a3:	b8 03 00 00 00       	mov    $0x3,%eax
  8017a8:	eb 20                	jmp    8017ca <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8017aa:	ff 75 14             	pushl  0x14(%ebp)
  8017ad:	ff 75 10             	pushl  0x10(%ebp)
  8017b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8017b3:	50                   	push   %eax
  8017b4:	68 40 17 80 00       	push   $0x801740
  8017b9:	e8 92 fb ff ff       	call   801350 <vprintfmt>
  8017be:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8017c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8017c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8017d2:	8d 45 10             	lea    0x10(%ebp),%eax
  8017d5:	83 c0 04             	add    $0x4,%eax
  8017d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8017db:	8b 45 10             	mov    0x10(%ebp),%eax
  8017de:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e1:	50                   	push   %eax
  8017e2:	ff 75 0c             	pushl  0xc(%ebp)
  8017e5:	ff 75 08             	pushl  0x8(%ebp)
  8017e8:	e8 89 ff ff ff       	call   801776 <vsnprintf>
  8017ed:	83 c4 10             	add    $0x10,%esp
  8017f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8017f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8017fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801805:	eb 06                	jmp    80180d <strlen+0x15>
		n++;
  801807:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80180a:	ff 45 08             	incl   0x8(%ebp)
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	84 c0                	test   %al,%al
  801814:	75 f1                	jne    801807 <strlen+0xf>
		n++;
	return n;
  801816:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801821:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801828:	eb 09                	jmp    801833 <strnlen+0x18>
		n++;
  80182a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80182d:	ff 45 08             	incl   0x8(%ebp)
  801830:	ff 4d 0c             	decl   0xc(%ebp)
  801833:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801837:	74 09                	je     801842 <strnlen+0x27>
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	8a 00                	mov    (%eax),%al
  80183e:	84 c0                	test   %al,%al
  801840:	75 e8                	jne    80182a <strnlen+0xf>
		n++;
	return n;
  801842:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801853:	90                   	nop
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	8d 50 01             	lea    0x1(%eax),%edx
  80185a:	89 55 08             	mov    %edx,0x8(%ebp)
  80185d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801860:	8d 4a 01             	lea    0x1(%edx),%ecx
  801863:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801866:	8a 12                	mov    (%edx),%dl
  801868:	88 10                	mov    %dl,(%eax)
  80186a:	8a 00                	mov    (%eax),%al
  80186c:	84 c0                	test   %al,%al
  80186e:	75 e4                	jne    801854 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801870:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801881:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801888:	eb 1f                	jmp    8018a9 <strncpy+0x34>
		*dst++ = *src;
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8d 50 01             	lea    0x1(%eax),%edx
  801890:	89 55 08             	mov    %edx,0x8(%ebp)
  801893:	8b 55 0c             	mov    0xc(%ebp),%edx
  801896:	8a 12                	mov    (%edx),%dl
  801898:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80189a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189d:	8a 00                	mov    (%eax),%al
  80189f:	84 c0                	test   %al,%al
  8018a1:	74 03                	je     8018a6 <strncpy+0x31>
			src++;
  8018a3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8018a6:	ff 45 fc             	incl   -0x4(%ebp)
  8018a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018ac:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018af:	72 d9                	jb     80188a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8018b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8018c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018c6:	74 30                	je     8018f8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8018c8:	eb 16                	jmp    8018e0 <strlcpy+0x2a>
			*dst++ = *src++;
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	8d 50 01             	lea    0x1(%eax),%edx
  8018d0:	89 55 08             	mov    %edx,0x8(%ebp)
  8018d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018d9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8018dc:	8a 12                	mov    (%edx),%dl
  8018de:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8018e0:	ff 4d 10             	decl   0x10(%ebp)
  8018e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018e7:	74 09                	je     8018f2 <strlcpy+0x3c>
  8018e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ec:	8a 00                	mov    (%eax),%al
  8018ee:	84 c0                	test   %al,%al
  8018f0:	75 d8                	jne    8018ca <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018fe:	29 c2                	sub    %eax,%edx
  801900:	89 d0                	mov    %edx,%eax
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801907:	eb 06                	jmp    80190f <strcmp+0xb>
		p++, q++;
  801909:	ff 45 08             	incl   0x8(%ebp)
  80190c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
  801912:	8a 00                	mov    (%eax),%al
  801914:	84 c0                	test   %al,%al
  801916:	74 0e                	je     801926 <strcmp+0x22>
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	8a 10                	mov    (%eax),%dl
  80191d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801920:	8a 00                	mov    (%eax),%al
  801922:	38 c2                	cmp    %al,%dl
  801924:	74 e3                	je     801909 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	8a 00                	mov    (%eax),%al
  80192b:	0f b6 d0             	movzbl %al,%edx
  80192e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801931:	8a 00                	mov    (%eax),%al
  801933:	0f b6 c0             	movzbl %al,%eax
  801936:	29 c2                	sub    %eax,%edx
  801938:	89 d0                	mov    %edx,%eax
}
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    

0080193c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80193f:	eb 09                	jmp    80194a <strncmp+0xe>
		n--, p++, q++;
  801941:	ff 4d 10             	decl   0x10(%ebp)
  801944:	ff 45 08             	incl   0x8(%ebp)
  801947:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80194a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80194e:	74 17                	je     801967 <strncmp+0x2b>
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	8a 00                	mov    (%eax),%al
  801955:	84 c0                	test   %al,%al
  801957:	74 0e                	je     801967 <strncmp+0x2b>
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	8a 10                	mov    (%eax),%dl
  80195e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801961:	8a 00                	mov    (%eax),%al
  801963:	38 c2                	cmp    %al,%dl
  801965:	74 da                	je     801941 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801967:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196b:	75 07                	jne    801974 <strncmp+0x38>
		return 0;
  80196d:	b8 00 00 00 00       	mov    $0x0,%eax
  801972:	eb 14                	jmp    801988 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801974:	8b 45 08             	mov    0x8(%ebp),%eax
  801977:	8a 00                	mov    (%eax),%al
  801979:	0f b6 d0             	movzbl %al,%edx
  80197c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197f:	8a 00                	mov    (%eax),%al
  801981:	0f b6 c0             	movzbl %al,%eax
  801984:	29 c2                	sub    %eax,%edx
  801986:	89 d0                	mov    %edx,%eax
}
  801988:	5d                   	pop    %ebp
  801989:	c3                   	ret    

0080198a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	8b 45 0c             	mov    0xc(%ebp),%eax
  801993:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801996:	eb 12                	jmp    8019aa <strchr+0x20>
		if (*s == c)
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	8a 00                	mov    (%eax),%al
  80199d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8019a0:	75 05                	jne    8019a7 <strchr+0x1d>
			return (char *) s;
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	eb 11                	jmp    8019b8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8019a7:	ff 45 08             	incl   0x8(%ebp)
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	8a 00                	mov    (%eax),%al
  8019af:	84 c0                	test   %al,%al
  8019b1:	75 e5                	jne    801998 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8019b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8019c6:	eb 0d                	jmp    8019d5 <strfind+0x1b>
		if (*s == c)
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	8a 00                	mov    (%eax),%al
  8019cd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8019d0:	74 0e                	je     8019e0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8019d2:	ff 45 08             	incl   0x8(%ebp)
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	8a 00                	mov    (%eax),%al
  8019da:	84 c0                	test   %al,%al
  8019dc:	75 ea                	jne    8019c8 <strfind+0xe>
  8019de:	eb 01                	jmp    8019e1 <strfind+0x27>
		if (*s == c)
			break;
  8019e0:	90                   	nop
	return (char *) s;
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8019f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8019f8:	eb 0e                	jmp    801a08 <memset+0x22>
		*p++ = c;
  8019fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fd:	8d 50 01             	lea    0x1(%eax),%edx
  801a00:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a06:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801a08:	ff 4d f8             	decl   -0x8(%ebp)
  801a0b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801a0f:	79 e9                	jns    8019fa <memset+0x14>
		*p++ = c;

	return v;
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801a28:	eb 16                	jmp    801a40 <memcpy+0x2a>
		*d++ = *s++;
  801a2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2d:	8d 50 01             	lea    0x1(%eax),%edx
  801a30:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a36:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a39:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801a3c:	8a 12                	mov    (%edx),%dl
  801a3e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801a40:	8b 45 10             	mov    0x10(%ebp),%eax
  801a43:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a46:	89 55 10             	mov    %edx,0x10(%ebp)
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	75 dd                	jne    801a2a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a67:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a6a:	73 50                	jae    801abc <memmove+0x6a>
  801a6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a72:	01 d0                	add    %edx,%eax
  801a74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a77:	76 43                	jbe    801abc <memmove+0x6a>
		s += n;
  801a79:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801a7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a82:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801a85:	eb 10                	jmp    801a97 <memmove+0x45>
			*--d = *--s;
  801a87:	ff 4d f8             	decl   -0x8(%ebp)
  801a8a:	ff 4d fc             	decl   -0x4(%ebp)
  801a8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a90:	8a 10                	mov    (%eax),%dl
  801a92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a95:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801a97:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a9d:	89 55 10             	mov    %edx,0x10(%ebp)
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	75 e3                	jne    801a87 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801aa4:	eb 23                	jmp    801ac9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801aa6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa9:	8d 50 01             	lea    0x1(%eax),%edx
  801aac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aaf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab2:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ab5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ab8:	8a 12                	mov    (%edx),%dl
  801aba:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801abc:	8b 45 10             	mov    0x10(%ebp),%eax
  801abf:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ac2:	89 55 10             	mov    %edx,0x10(%ebp)
  801ac5:	85 c0                	test   %eax,%eax
  801ac7:	75 dd                	jne    801aa6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  801add:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801ae0:	eb 2a                	jmp    801b0c <memcmp+0x3e>
		if (*s1 != *s2)
  801ae2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ae5:	8a 10                	mov    (%eax),%dl
  801ae7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aea:	8a 00                	mov    (%eax),%al
  801aec:	38 c2                	cmp    %al,%dl
  801aee:	74 16                	je     801b06 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801af0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801af3:	8a 00                	mov    (%eax),%al
  801af5:	0f b6 d0             	movzbl %al,%edx
  801af8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afb:	8a 00                	mov    (%eax),%al
  801afd:	0f b6 c0             	movzbl %al,%eax
  801b00:	29 c2                	sub    %eax,%edx
  801b02:	89 d0                	mov    %edx,%eax
  801b04:	eb 18                	jmp    801b1e <memcmp+0x50>
		s1++, s2++;
  801b06:	ff 45 fc             	incl   -0x4(%ebp)
  801b09:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801b0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b12:	89 55 10             	mov    %edx,0x10(%ebp)
  801b15:	85 c0                	test   %eax,%eax
  801b17:	75 c9                	jne    801ae2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801b26:	8b 55 08             	mov    0x8(%ebp),%edx
  801b29:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2c:	01 d0                	add    %edx,%eax
  801b2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801b31:	eb 15                	jmp    801b48 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	8a 00                	mov    (%eax),%al
  801b38:	0f b6 d0             	movzbl %al,%edx
  801b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3e:	0f b6 c0             	movzbl %al,%eax
  801b41:	39 c2                	cmp    %eax,%edx
  801b43:	74 0d                	je     801b52 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801b45:	ff 45 08             	incl   0x8(%ebp)
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b4e:	72 e3                	jb     801b33 <memfind+0x13>
  801b50:	eb 01                	jmp    801b53 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801b52:	90                   	nop
	return (void *) s;
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801b5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801b65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b6c:	eb 03                	jmp    801b71 <strtol+0x19>
		s++;
  801b6e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	8a 00                	mov    (%eax),%al
  801b76:	3c 20                	cmp    $0x20,%al
  801b78:	74 f4                	je     801b6e <strtol+0x16>
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	8a 00                	mov    (%eax),%al
  801b7f:	3c 09                	cmp    $0x9,%al
  801b81:	74 eb                	je     801b6e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	8a 00                	mov    (%eax),%al
  801b88:	3c 2b                	cmp    $0x2b,%al
  801b8a:	75 05                	jne    801b91 <strtol+0x39>
		s++;
  801b8c:	ff 45 08             	incl   0x8(%ebp)
  801b8f:	eb 13                	jmp    801ba4 <strtol+0x4c>
	else if (*s == '-')
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	8a 00                	mov    (%eax),%al
  801b96:	3c 2d                	cmp    $0x2d,%al
  801b98:	75 0a                	jne    801ba4 <strtol+0x4c>
		s++, neg = 1;
  801b9a:	ff 45 08             	incl   0x8(%ebp)
  801b9d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ba4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ba8:	74 06                	je     801bb0 <strtol+0x58>
  801baa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801bae:	75 20                	jne    801bd0 <strtol+0x78>
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	8a 00                	mov    (%eax),%al
  801bb5:	3c 30                	cmp    $0x30,%al
  801bb7:	75 17                	jne    801bd0 <strtol+0x78>
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	40                   	inc    %eax
  801bbd:	8a 00                	mov    (%eax),%al
  801bbf:	3c 78                	cmp    $0x78,%al
  801bc1:	75 0d                	jne    801bd0 <strtol+0x78>
		s += 2, base = 16;
  801bc3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801bc7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801bce:	eb 28                	jmp    801bf8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801bd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bd4:	75 15                	jne    801beb <strtol+0x93>
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	8a 00                	mov    (%eax),%al
  801bdb:	3c 30                	cmp    $0x30,%al
  801bdd:	75 0c                	jne    801beb <strtol+0x93>
		s++, base = 8;
  801bdf:	ff 45 08             	incl   0x8(%ebp)
  801be2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801be9:	eb 0d                	jmp    801bf8 <strtol+0xa0>
	else if (base == 0)
  801beb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bef:	75 07                	jne    801bf8 <strtol+0xa0>
		base = 10;
  801bf1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	8a 00                	mov    (%eax),%al
  801bfd:	3c 2f                	cmp    $0x2f,%al
  801bff:	7e 19                	jle    801c1a <strtol+0xc2>
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	8a 00                	mov    (%eax),%al
  801c06:	3c 39                	cmp    $0x39,%al
  801c08:	7f 10                	jg     801c1a <strtol+0xc2>
			dig = *s - '0';
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	8a 00                	mov    (%eax),%al
  801c0f:	0f be c0             	movsbl %al,%eax
  801c12:	83 e8 30             	sub    $0x30,%eax
  801c15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c18:	eb 42                	jmp    801c5c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	8a 00                	mov    (%eax),%al
  801c1f:	3c 60                	cmp    $0x60,%al
  801c21:	7e 19                	jle    801c3c <strtol+0xe4>
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	8a 00                	mov    (%eax),%al
  801c28:	3c 7a                	cmp    $0x7a,%al
  801c2a:	7f 10                	jg     801c3c <strtol+0xe4>
			dig = *s - 'a' + 10;
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	8a 00                	mov    (%eax),%al
  801c31:	0f be c0             	movsbl %al,%eax
  801c34:	83 e8 57             	sub    $0x57,%eax
  801c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c3a:	eb 20                	jmp    801c5c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	8a 00                	mov    (%eax),%al
  801c41:	3c 40                	cmp    $0x40,%al
  801c43:	7e 39                	jle    801c7e <strtol+0x126>
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	8a 00                	mov    (%eax),%al
  801c4a:	3c 5a                	cmp    $0x5a,%al
  801c4c:	7f 30                	jg     801c7e <strtol+0x126>
			dig = *s - 'A' + 10;
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	8a 00                	mov    (%eax),%al
  801c53:	0f be c0             	movsbl %al,%eax
  801c56:	83 e8 37             	sub    $0x37,%eax
  801c59:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c62:	7d 19                	jge    801c7d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801c64:	ff 45 08             	incl   0x8(%ebp)
  801c67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6a:	0f af 45 10          	imul   0x10(%ebp),%eax
  801c6e:	89 c2                	mov    %eax,%edx
  801c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c73:	01 d0                	add    %edx,%eax
  801c75:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801c78:	e9 7b ff ff ff       	jmp    801bf8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801c7d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801c7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c82:	74 08                	je     801c8c <strtol+0x134>
		*endptr = (char *) s;
  801c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c87:	8b 55 08             	mov    0x8(%ebp),%edx
  801c8a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801c8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c90:	74 07                	je     801c99 <strtol+0x141>
  801c92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c95:	f7 d8                	neg    %eax
  801c97:	eb 03                	jmp    801c9c <strtol+0x144>
  801c99:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <ltostr>:

void
ltostr(long value, char *str)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801ca4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801cab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801cb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cb6:	79 13                	jns    801ccb <ltostr+0x2d>
	{
		neg = 1;
  801cb8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801cc5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801cc8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801cd3:	99                   	cltd   
  801cd4:	f7 f9                	idiv   %ecx
  801cd6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801cd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cdc:	8d 50 01             	lea    0x1(%eax),%edx
  801cdf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ce2:	89 c2                	mov    %eax,%edx
  801ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce7:	01 d0                	add    %edx,%eax
  801ce9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cec:	83 c2 30             	add    $0x30,%edx
  801cef:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801cf1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801cf9:	f7 e9                	imul   %ecx
  801cfb:	c1 fa 02             	sar    $0x2,%edx
  801cfe:	89 c8                	mov    %ecx,%eax
  801d00:	c1 f8 1f             	sar    $0x1f,%eax
  801d03:	29 c2                	sub    %eax,%edx
  801d05:	89 d0                	mov    %edx,%eax
  801d07:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801d0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d0d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d12:	f7 e9                	imul   %ecx
  801d14:	c1 fa 02             	sar    $0x2,%edx
  801d17:	89 c8                	mov    %ecx,%eax
  801d19:	c1 f8 1f             	sar    $0x1f,%eax
  801d1c:	29 c2                	sub    %eax,%edx
  801d1e:	89 d0                	mov    %edx,%eax
  801d20:	c1 e0 02             	shl    $0x2,%eax
  801d23:	01 d0                	add    %edx,%eax
  801d25:	01 c0                	add    %eax,%eax
  801d27:	29 c1                	sub    %eax,%ecx
  801d29:	89 ca                	mov    %ecx,%edx
  801d2b:	85 d2                	test   %edx,%edx
  801d2d:	75 9c                	jne    801ccb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801d2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801d36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d39:	48                   	dec    %eax
  801d3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801d3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d41:	74 3d                	je     801d80 <ltostr+0xe2>
		start = 1 ;
  801d43:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801d4a:	eb 34                	jmp    801d80 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801d4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d52:	01 d0                	add    %edx,%eax
  801d54:	8a 00                	mov    (%eax),%al
  801d56:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801d59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5f:	01 c2                	add    %eax,%edx
  801d61:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d67:	01 c8                	add    %ecx,%eax
  801d69:	8a 00                	mov    (%eax),%al
  801d6b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801d6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d73:	01 c2                	add    %eax,%edx
  801d75:	8a 45 eb             	mov    -0x15(%ebp),%al
  801d78:	88 02                	mov    %al,(%edx)
		start++ ;
  801d7a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801d7d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d83:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d86:	7c c4                	jl     801d4c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801d88:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8e:	01 d0                	add    %edx,%eax
  801d90:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801d93:	90                   	nop
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801d9c:	ff 75 08             	pushl  0x8(%ebp)
  801d9f:	e8 54 fa ff ff       	call   8017f8 <strlen>
  801da4:	83 c4 04             	add    $0x4,%esp
  801da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801daa:	ff 75 0c             	pushl  0xc(%ebp)
  801dad:	e8 46 fa ff ff       	call   8017f8 <strlen>
  801db2:	83 c4 04             	add    $0x4,%esp
  801db5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801db8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801dbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801dc6:	eb 17                	jmp    801ddf <strcconcat+0x49>
		final[s] = str1[s] ;
  801dc8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dcb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dce:	01 c2                	add    %eax,%edx
  801dd0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd6:	01 c8                	add    %ecx,%eax
  801dd8:	8a 00                	mov    (%eax),%al
  801dda:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ddc:	ff 45 fc             	incl   -0x4(%ebp)
  801ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801de2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801de5:	7c e1                	jl     801dc8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801de7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801dee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801df5:	eb 1f                	jmp    801e16 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801df7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dfa:	8d 50 01             	lea    0x1(%eax),%edx
  801dfd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801e00:	89 c2                	mov    %eax,%edx
  801e02:	8b 45 10             	mov    0x10(%ebp),%eax
  801e05:	01 c2                	add    %eax,%edx
  801e07:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0d:	01 c8                	add    %ecx,%eax
  801e0f:	8a 00                	mov    (%eax),%al
  801e11:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801e13:	ff 45 f8             	incl   -0x8(%ebp)
  801e16:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e19:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e1c:	7c d9                	jl     801df7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801e1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e21:	8b 45 10             	mov    0x10(%ebp),%eax
  801e24:	01 d0                	add    %edx,%eax
  801e26:	c6 00 00             	movb   $0x0,(%eax)
}
  801e29:	90                   	nop
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801e2f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801e38:	8b 45 14             	mov    0x14(%ebp),%eax
  801e3b:	8b 00                	mov    (%eax),%eax
  801e3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e44:	8b 45 10             	mov    0x10(%ebp),%eax
  801e47:	01 d0                	add    %edx,%eax
  801e49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801e4f:	eb 0c                	jmp    801e5d <strsplit+0x31>
			*string++ = 0;
  801e51:	8b 45 08             	mov    0x8(%ebp),%eax
  801e54:	8d 50 01             	lea    0x1(%eax),%edx
  801e57:	89 55 08             	mov    %edx,0x8(%ebp)
  801e5a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	8a 00                	mov    (%eax),%al
  801e62:	84 c0                	test   %al,%al
  801e64:	74 18                	je     801e7e <strsplit+0x52>
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	8a 00                	mov    (%eax),%al
  801e6b:	0f be c0             	movsbl %al,%eax
  801e6e:	50                   	push   %eax
  801e6f:	ff 75 0c             	pushl  0xc(%ebp)
  801e72:	e8 13 fb ff ff       	call   80198a <strchr>
  801e77:	83 c4 08             	add    $0x8,%esp
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	75 d3                	jne    801e51 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	8a 00                	mov    (%eax),%al
  801e83:	84 c0                	test   %al,%al
  801e85:	74 5a                	je     801ee1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801e87:	8b 45 14             	mov    0x14(%ebp),%eax
  801e8a:	8b 00                	mov    (%eax),%eax
  801e8c:	83 f8 0f             	cmp    $0xf,%eax
  801e8f:	75 07                	jne    801e98 <strsplit+0x6c>
		{
			return 0;
  801e91:	b8 00 00 00 00       	mov    $0x0,%eax
  801e96:	eb 66                	jmp    801efe <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801e98:	8b 45 14             	mov    0x14(%ebp),%eax
  801e9b:	8b 00                	mov    (%eax),%eax
  801e9d:	8d 48 01             	lea    0x1(%eax),%ecx
  801ea0:	8b 55 14             	mov    0x14(%ebp),%edx
  801ea3:	89 0a                	mov    %ecx,(%edx)
  801ea5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eac:	8b 45 10             	mov    0x10(%ebp),%eax
  801eaf:	01 c2                	add    %eax,%edx
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801eb6:	eb 03                	jmp    801ebb <strsplit+0x8f>
			string++;
  801eb8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	8a 00                	mov    (%eax),%al
  801ec0:	84 c0                	test   %al,%al
  801ec2:	74 8b                	je     801e4f <strsplit+0x23>
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	8a 00                	mov    (%eax),%al
  801ec9:	0f be c0             	movsbl %al,%eax
  801ecc:	50                   	push   %eax
  801ecd:	ff 75 0c             	pushl  0xc(%ebp)
  801ed0:	e8 b5 fa ff ff       	call   80198a <strchr>
  801ed5:	83 c4 08             	add    $0x8,%esp
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	74 dc                	je     801eb8 <strsplit+0x8c>
			string++;
	}
  801edc:	e9 6e ff ff ff       	jmp    801e4f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ee1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ee2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee5:	8b 00                	mov    (%eax),%eax
  801ee7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eee:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef1:	01 d0                	add    %edx,%eax
  801ef3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ef9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801f06:	a1 04 50 80 00       	mov    0x805004,%eax
  801f0b:	85 c0                	test   %eax,%eax
  801f0d:	74 1f                	je     801f2e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801f0f:	e8 1d 00 00 00       	call   801f31 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801f14:	83 ec 0c             	sub    $0xc,%esp
  801f17:	68 f0 45 80 00       	push   $0x8045f0
  801f1c:	e8 55 f2 ff ff       	call   801176 <cprintf>
  801f21:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801f24:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801f2b:	00 00 00 
	}
}
  801f2e:	90                   	nop
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801f37:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801f3e:	00 00 00 
  801f41:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801f48:	00 00 00 
  801f4b:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801f52:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801f55:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801f5c:	00 00 00 
  801f5f:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801f66:	00 00 00 
  801f69:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801f70:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801f73:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801f7a:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801f7d:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f87:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f8c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f91:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801f96:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f9d:	a1 20 51 80 00       	mov    0x805120,%eax
  801fa2:	c1 e0 04             	shl    $0x4,%eax
  801fa5:	89 c2                	mov    %eax,%edx
  801fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801faa:	01 d0                	add    %edx,%eax
  801fac:	48                   	dec    %eax
  801fad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801fb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb3:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb8:	f7 75 f0             	divl   -0x10(%ebp)
  801fbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fbe:	29 d0                	sub    %edx,%eax
  801fc0:	89 c2                	mov    %eax,%edx
  801fc2:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fcc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801fd1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fd6:	83 ec 04             	sub    $0x4,%esp
  801fd9:	6a 06                	push   $0x6
  801fdb:	52                   	push   %edx
  801fdc:	50                   	push   %eax
  801fdd:	e8 71 05 00 00       	call   802553 <sys_allocate_chunk>
  801fe2:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801fe5:	a1 20 51 80 00       	mov    0x805120,%eax
  801fea:	83 ec 0c             	sub    $0xc,%esp
  801fed:	50                   	push   %eax
  801fee:	e8 e6 0b 00 00       	call   802bd9 <initialize_MemBlocksList>
  801ff3:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801ff6:	a1 48 51 80 00       	mov    0x805148,%eax
  801ffb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801ffe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802002:	75 14                	jne    802018 <initialize_dyn_block_system+0xe7>
  802004:	83 ec 04             	sub    $0x4,%esp
  802007:	68 15 46 80 00       	push   $0x804615
  80200c:	6a 2b                	push   $0x2b
  80200e:	68 33 46 80 00       	push   $0x804633
  802013:	e8 aa ee ff ff       	call   800ec2 <_panic>
  802018:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80201b:	8b 00                	mov    (%eax),%eax
  80201d:	85 c0                	test   %eax,%eax
  80201f:	74 10                	je     802031 <initialize_dyn_block_system+0x100>
  802021:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802024:	8b 00                	mov    (%eax),%eax
  802026:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802029:	8b 52 04             	mov    0x4(%edx),%edx
  80202c:	89 50 04             	mov    %edx,0x4(%eax)
  80202f:	eb 0b                	jmp    80203c <initialize_dyn_block_system+0x10b>
  802031:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802034:	8b 40 04             	mov    0x4(%eax),%eax
  802037:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80203c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80203f:	8b 40 04             	mov    0x4(%eax),%eax
  802042:	85 c0                	test   %eax,%eax
  802044:	74 0f                	je     802055 <initialize_dyn_block_system+0x124>
  802046:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802049:	8b 40 04             	mov    0x4(%eax),%eax
  80204c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80204f:	8b 12                	mov    (%edx),%edx
  802051:	89 10                	mov    %edx,(%eax)
  802053:	eb 0a                	jmp    80205f <initialize_dyn_block_system+0x12e>
  802055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802058:	8b 00                	mov    (%eax),%eax
  80205a:	a3 48 51 80 00       	mov    %eax,0x805148
  80205f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802062:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802068:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80206b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802072:	a1 54 51 80 00       	mov    0x805154,%eax
  802077:	48                   	dec    %eax
  802078:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  80207d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802080:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  802087:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80208a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  802091:	83 ec 0c             	sub    $0xc,%esp
  802094:	ff 75 e4             	pushl  -0x1c(%ebp)
  802097:	e8 d2 13 00 00       	call   80346e <insert_sorted_with_merge_freeList>
  80209c:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80209f:	90                   	nop
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
  8020a5:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020a8:	e8 53 fe ff ff       	call   801f00 <InitializeUHeap>
	if (size == 0) return NULL ;
  8020ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020b1:	75 07                	jne    8020ba <malloc+0x18>
  8020b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b8:	eb 61                	jmp    80211b <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8020ba:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8020c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c7:	01 d0                	add    %edx,%eax
  8020c9:	48                   	dec    %eax
  8020ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8020d5:	f7 75 f4             	divl   -0xc(%ebp)
  8020d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020db:	29 d0                	sub    %edx,%eax
  8020dd:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8020e0:	e8 3c 08 00 00       	call   802921 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020e5:	85 c0                	test   %eax,%eax
  8020e7:	74 2d                	je     802116 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8020e9:	83 ec 0c             	sub    $0xc,%esp
  8020ec:	ff 75 08             	pushl  0x8(%ebp)
  8020ef:	e8 3e 0f 00 00       	call   803032 <alloc_block_FF>
  8020f4:	83 c4 10             	add    $0x10,%esp
  8020f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8020fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020fe:	74 16                	je     802116 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  802100:	83 ec 0c             	sub    $0xc,%esp
  802103:	ff 75 ec             	pushl  -0x14(%ebp)
  802106:	e8 48 0c 00 00       	call   802d53 <insert_sorted_allocList>
  80210b:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  80210e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802111:	8b 40 08             	mov    0x8(%eax),%eax
  802114:	eb 05                	jmp    80211b <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  802116:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
  802120:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802131:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	83 ec 08             	sub    $0x8,%esp
  80213a:	50                   	push   %eax
  80213b:	68 40 50 80 00       	push   $0x805040
  802140:	e8 71 0b 00 00       	call   802cb6 <find_block>
  802145:	83 c4 10             	add    $0x10,%esp
  802148:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  80214b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214e:	8b 50 0c             	mov    0xc(%eax),%edx
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	83 ec 08             	sub    $0x8,%esp
  802157:	52                   	push   %edx
  802158:	50                   	push   %eax
  802159:	e8 bd 03 00 00       	call   80251b <sys_free_user_mem>
  80215e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  802161:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802165:	75 14                	jne    80217b <free+0x5e>
  802167:	83 ec 04             	sub    $0x4,%esp
  80216a:	68 15 46 80 00       	push   $0x804615
  80216f:	6a 71                	push   $0x71
  802171:	68 33 46 80 00       	push   $0x804633
  802176:	e8 47 ed ff ff       	call   800ec2 <_panic>
  80217b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217e:	8b 00                	mov    (%eax),%eax
  802180:	85 c0                	test   %eax,%eax
  802182:	74 10                	je     802194 <free+0x77>
  802184:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802187:	8b 00                	mov    (%eax),%eax
  802189:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80218c:	8b 52 04             	mov    0x4(%edx),%edx
  80218f:	89 50 04             	mov    %edx,0x4(%eax)
  802192:	eb 0b                	jmp    80219f <free+0x82>
  802194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802197:	8b 40 04             	mov    0x4(%eax),%eax
  80219a:	a3 44 50 80 00       	mov    %eax,0x805044
  80219f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a2:	8b 40 04             	mov    0x4(%eax),%eax
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	74 0f                	je     8021b8 <free+0x9b>
  8021a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ac:	8b 40 04             	mov    0x4(%eax),%eax
  8021af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021b2:	8b 12                	mov    (%edx),%edx
  8021b4:	89 10                	mov    %edx,(%eax)
  8021b6:	eb 0a                	jmp    8021c2 <free+0xa5>
  8021b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bb:	8b 00                	mov    (%eax),%eax
  8021bd:	a3 40 50 80 00       	mov    %eax,0x805040
  8021c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021d5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021da:	48                   	dec    %eax
  8021db:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  8021e0:	83 ec 0c             	sub    $0xc,%esp
  8021e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8021e6:	e8 83 12 00 00       	call   80346e <insert_sorted_with_merge_freeList>
  8021eb:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8021ee:	90                   	nop
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
  8021f4:	83 ec 28             	sub    $0x28,%esp
  8021f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8021fa:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021fd:	e8 fe fc ff ff       	call   801f00 <InitializeUHeap>
	if (size == 0) return NULL ;
  802202:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802206:	75 0a                	jne    802212 <smalloc+0x21>
  802208:	b8 00 00 00 00       	mov    $0x0,%eax
  80220d:	e9 86 00 00 00       	jmp    802298 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  802212:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802219:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221f:	01 d0                	add    %edx,%eax
  802221:	48                   	dec    %eax
  802222:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802225:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802228:	ba 00 00 00 00       	mov    $0x0,%edx
  80222d:	f7 75 f4             	divl   -0xc(%ebp)
  802230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802233:	29 d0                	sub    %edx,%eax
  802235:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802238:	e8 e4 06 00 00       	call   802921 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80223d:	85 c0                	test   %eax,%eax
  80223f:	74 52                	je     802293 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  802241:	83 ec 0c             	sub    $0xc,%esp
  802244:	ff 75 0c             	pushl  0xc(%ebp)
  802247:	e8 e6 0d 00 00       	call   803032 <alloc_block_FF>
  80224c:	83 c4 10             	add    $0x10,%esp
  80224f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  802252:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802256:	75 07                	jne    80225f <smalloc+0x6e>
			return NULL ;
  802258:	b8 00 00 00 00       	mov    $0x0,%eax
  80225d:	eb 39                	jmp    802298 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  80225f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802262:	8b 40 08             	mov    0x8(%eax),%eax
  802265:	89 c2                	mov    %eax,%edx
  802267:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80226b:	52                   	push   %edx
  80226c:	50                   	push   %eax
  80226d:	ff 75 0c             	pushl  0xc(%ebp)
  802270:	ff 75 08             	pushl  0x8(%ebp)
  802273:	e8 2e 04 00 00       	call   8026a6 <sys_createSharedObject>
  802278:	83 c4 10             	add    $0x10,%esp
  80227b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  80227e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802282:	79 07                	jns    80228b <smalloc+0x9a>
			return (void*)NULL ;
  802284:	b8 00 00 00 00       	mov    $0x0,%eax
  802289:	eb 0d                	jmp    802298 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  80228b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80228e:	8b 40 08             	mov    0x8(%eax),%eax
  802291:	eb 05                	jmp    802298 <smalloc+0xa7>
		}
		return (void*)NULL ;
  802293:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8022a0:	e8 5b fc ff ff       	call   801f00 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8022a5:	83 ec 08             	sub    $0x8,%esp
  8022a8:	ff 75 0c             	pushl  0xc(%ebp)
  8022ab:	ff 75 08             	pushl  0x8(%ebp)
  8022ae:	e8 1d 04 00 00       	call   8026d0 <sys_getSizeOfSharedObject>
  8022b3:	83 c4 10             	add    $0x10,%esp
  8022b6:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8022b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022bd:	75 0a                	jne    8022c9 <sget+0x2f>
			return NULL ;
  8022bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c4:	e9 83 00 00 00       	jmp    80234c <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8022c9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8022d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d6:	01 d0                	add    %edx,%eax
  8022d8:	48                   	dec    %eax
  8022d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8022dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022df:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e4:	f7 75 f0             	divl   -0x10(%ebp)
  8022e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ea:	29 d0                	sub    %edx,%eax
  8022ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8022ef:	e8 2d 06 00 00       	call   802921 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8022f4:	85 c0                	test   %eax,%eax
  8022f6:	74 4f                	je     802347 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fb:	83 ec 0c             	sub    $0xc,%esp
  8022fe:	50                   	push   %eax
  8022ff:	e8 2e 0d 00 00       	call   803032 <alloc_block_FF>
  802304:	83 c4 10             	add    $0x10,%esp
  802307:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  80230a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80230e:	75 07                	jne    802317 <sget+0x7d>
					return (void*)NULL ;
  802310:	b8 00 00 00 00       	mov    $0x0,%eax
  802315:	eb 35                	jmp    80234c <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  802317:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80231a:	8b 40 08             	mov    0x8(%eax),%eax
  80231d:	83 ec 04             	sub    $0x4,%esp
  802320:	50                   	push   %eax
  802321:	ff 75 0c             	pushl  0xc(%ebp)
  802324:	ff 75 08             	pushl  0x8(%ebp)
  802327:	e8 c1 03 00 00       	call   8026ed <sys_getSharedObject>
  80232c:	83 c4 10             	add    $0x10,%esp
  80232f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  802332:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802336:	79 07                	jns    80233f <sget+0xa5>
				return (void*)NULL ;
  802338:	b8 00 00 00 00       	mov    $0x0,%eax
  80233d:	eb 0d                	jmp    80234c <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  80233f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802342:	8b 40 08             	mov    0x8(%eax),%eax
  802345:	eb 05                	jmp    80234c <sget+0xb2>


		}
	return (void*)NULL ;
  802347:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80234c:	c9                   	leave  
  80234d:	c3                   	ret    

0080234e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
  802351:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802354:	e8 a7 fb ff ff       	call   801f00 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802359:	83 ec 04             	sub    $0x4,%esp
  80235c:	68 40 46 80 00       	push   $0x804640
  802361:	68 f9 00 00 00       	push   $0xf9
  802366:	68 33 46 80 00       	push   $0x804633
  80236b:	e8 52 eb ff ff       	call   800ec2 <_panic>

00802370 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802376:	83 ec 04             	sub    $0x4,%esp
  802379:	68 68 46 80 00       	push   $0x804668
  80237e:	68 0d 01 00 00       	push   $0x10d
  802383:	68 33 46 80 00       	push   $0x804633
  802388:	e8 35 eb ff ff       	call   800ec2 <_panic>

0080238d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
  802390:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802393:	83 ec 04             	sub    $0x4,%esp
  802396:	68 8c 46 80 00       	push   $0x80468c
  80239b:	68 18 01 00 00       	push   $0x118
  8023a0:	68 33 46 80 00       	push   $0x804633
  8023a5:	e8 18 eb ff ff       	call   800ec2 <_panic>

008023aa <shrink>:

}
void shrink(uint32 newSize)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
  8023ad:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023b0:	83 ec 04             	sub    $0x4,%esp
  8023b3:	68 8c 46 80 00       	push   $0x80468c
  8023b8:	68 1d 01 00 00       	push   $0x11d
  8023bd:	68 33 46 80 00       	push   $0x804633
  8023c2:	e8 fb ea ff ff       	call   800ec2 <_panic>

008023c7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8023c7:	55                   	push   %ebp
  8023c8:	89 e5                	mov    %esp,%ebp
  8023ca:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023cd:	83 ec 04             	sub    $0x4,%esp
  8023d0:	68 8c 46 80 00       	push   $0x80468c
  8023d5:	68 22 01 00 00       	push   $0x122
  8023da:	68 33 46 80 00       	push   $0x804633
  8023df:	e8 de ea ff ff       	call   800ec2 <_panic>

008023e4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	57                   	push   %edi
  8023e8:	56                   	push   %esi
  8023e9:	53                   	push   %ebx
  8023ea:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8023ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023f9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8023fc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8023ff:	cd 30                	int    $0x30
  802401:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802404:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802407:	83 c4 10             	add    $0x10,%esp
  80240a:	5b                   	pop    %ebx
  80240b:	5e                   	pop    %esi
  80240c:	5f                   	pop    %edi
  80240d:	5d                   	pop    %ebp
  80240e:	c3                   	ret    

0080240f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80240f:	55                   	push   %ebp
  802410:	89 e5                	mov    %esp,%ebp
  802412:	83 ec 04             	sub    $0x4,%esp
  802415:	8b 45 10             	mov    0x10(%ebp),%eax
  802418:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80241b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80241f:	8b 45 08             	mov    0x8(%ebp),%eax
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	52                   	push   %edx
  802427:	ff 75 0c             	pushl  0xc(%ebp)
  80242a:	50                   	push   %eax
  80242b:	6a 00                	push   $0x0
  80242d:	e8 b2 ff ff ff       	call   8023e4 <syscall>
  802432:	83 c4 18             	add    $0x18,%esp
}
  802435:	90                   	nop
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <sys_cgetc>:

int
sys_cgetc(void)
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	6a 00                	push   $0x0
  802445:	6a 01                	push   $0x1
  802447:	e8 98 ff ff ff       	call   8023e4 <syscall>
  80244c:	83 c4 18             	add    $0x18,%esp
}
  80244f:	c9                   	leave  
  802450:	c3                   	ret    

00802451 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802451:	55                   	push   %ebp
  802452:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802454:	8b 55 0c             	mov    0xc(%ebp),%edx
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	52                   	push   %edx
  802461:	50                   	push   %eax
  802462:	6a 05                	push   $0x5
  802464:	e8 7b ff ff ff       	call   8023e4 <syscall>
  802469:	83 c4 18             	add    $0x18,%esp
}
  80246c:	c9                   	leave  
  80246d:	c3                   	ret    

0080246e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80246e:	55                   	push   %ebp
  80246f:	89 e5                	mov    %esp,%ebp
  802471:	56                   	push   %esi
  802472:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802473:	8b 75 18             	mov    0x18(%ebp),%esi
  802476:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802479:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80247c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	56                   	push   %esi
  802483:	53                   	push   %ebx
  802484:	51                   	push   %ecx
  802485:	52                   	push   %edx
  802486:	50                   	push   %eax
  802487:	6a 06                	push   $0x6
  802489:	e8 56 ff ff ff       	call   8023e4 <syscall>
  80248e:	83 c4 18             	add    $0x18,%esp
}
  802491:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802494:	5b                   	pop    %ebx
  802495:	5e                   	pop    %esi
  802496:	5d                   	pop    %ebp
  802497:	c3                   	ret    

00802498 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80249b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249e:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	52                   	push   %edx
  8024a8:	50                   	push   %eax
  8024a9:	6a 07                	push   $0x7
  8024ab:	e8 34 ff ff ff       	call   8023e4 <syscall>
  8024b0:	83 c4 18             	add    $0x18,%esp
}
  8024b3:	c9                   	leave  
  8024b4:	c3                   	ret    

008024b5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	ff 75 0c             	pushl  0xc(%ebp)
  8024c1:	ff 75 08             	pushl  0x8(%ebp)
  8024c4:	6a 08                	push   $0x8
  8024c6:	e8 19 ff ff ff       	call   8023e4 <syscall>
  8024cb:	83 c4 18             	add    $0x18,%esp
}
  8024ce:	c9                   	leave  
  8024cf:	c3                   	ret    

008024d0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 09                	push   $0x9
  8024df:	e8 00 ff ff ff       	call   8023e4 <syscall>
  8024e4:	83 c4 18             	add    $0x18,%esp
}
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    

008024e9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 0a                	push   $0xa
  8024f8:	e8 e7 fe ff ff       	call   8023e4 <syscall>
  8024fd:	83 c4 18             	add    $0x18,%esp
}
  802500:	c9                   	leave  
  802501:	c3                   	ret    

00802502 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802502:	55                   	push   %ebp
  802503:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	6a 00                	push   $0x0
  80250b:	6a 00                	push   $0x0
  80250d:	6a 00                	push   $0x0
  80250f:	6a 0b                	push   $0xb
  802511:	e8 ce fe ff ff       	call   8023e4 <syscall>
  802516:	83 c4 18             	add    $0x18,%esp
}
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	ff 75 0c             	pushl  0xc(%ebp)
  802527:	ff 75 08             	pushl  0x8(%ebp)
  80252a:	6a 0f                	push   $0xf
  80252c:	e8 b3 fe ff ff       	call   8023e4 <syscall>
  802531:	83 c4 18             	add    $0x18,%esp
	return;
  802534:	90                   	nop
}
  802535:	c9                   	leave  
  802536:	c3                   	ret    

00802537 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802537:	55                   	push   %ebp
  802538:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80253a:	6a 00                	push   $0x0
  80253c:	6a 00                	push   $0x0
  80253e:	6a 00                	push   $0x0
  802540:	ff 75 0c             	pushl  0xc(%ebp)
  802543:	ff 75 08             	pushl  0x8(%ebp)
  802546:	6a 10                	push   $0x10
  802548:	e8 97 fe ff ff       	call   8023e4 <syscall>
  80254d:	83 c4 18             	add    $0x18,%esp
	return ;
  802550:	90                   	nop
}
  802551:	c9                   	leave  
  802552:	c3                   	ret    

00802553 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	ff 75 10             	pushl  0x10(%ebp)
  80255d:	ff 75 0c             	pushl  0xc(%ebp)
  802560:	ff 75 08             	pushl  0x8(%ebp)
  802563:	6a 11                	push   $0x11
  802565:	e8 7a fe ff ff       	call   8023e4 <syscall>
  80256a:	83 c4 18             	add    $0x18,%esp
	return ;
  80256d:	90                   	nop
}
  80256e:	c9                   	leave  
  80256f:	c3                   	ret    

00802570 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 0c                	push   $0xc
  80257f:	e8 60 fe ff ff       	call   8023e4 <syscall>
  802584:	83 c4 18             	add    $0x18,%esp
}
  802587:	c9                   	leave  
  802588:	c3                   	ret    

00802589 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802589:	55                   	push   %ebp
  80258a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	ff 75 08             	pushl  0x8(%ebp)
  802597:	6a 0d                	push   $0xd
  802599:	e8 46 fe ff ff       	call   8023e4 <syscall>
  80259e:	83 c4 18             	add    $0x18,%esp
}
  8025a1:	c9                   	leave  
  8025a2:	c3                   	ret    

008025a3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8025a3:	55                   	push   %ebp
  8025a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 0e                	push   $0xe
  8025b2:	e8 2d fe ff ff       	call   8023e4 <syscall>
  8025b7:	83 c4 18             	add    $0x18,%esp
}
  8025ba:	90                   	nop
  8025bb:	c9                   	leave  
  8025bc:	c3                   	ret    

008025bd <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8025bd:	55                   	push   %ebp
  8025be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 00                	push   $0x0
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 13                	push   $0x13
  8025cc:	e8 13 fe ff ff       	call   8023e4 <syscall>
  8025d1:	83 c4 18             	add    $0x18,%esp
}
  8025d4:	90                   	nop
  8025d5:	c9                   	leave  
  8025d6:	c3                   	ret    

008025d7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8025d7:	55                   	push   %ebp
  8025d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 14                	push   $0x14
  8025e6:	e8 f9 fd ff ff       	call   8023e4 <syscall>
  8025eb:	83 c4 18             	add    $0x18,%esp
}
  8025ee:	90                   	nop
  8025ef:	c9                   	leave  
  8025f0:	c3                   	ret    

008025f1 <sys_cputc>:


void
sys_cputc(const char c)
{
  8025f1:	55                   	push   %ebp
  8025f2:	89 e5                	mov    %esp,%ebp
  8025f4:	83 ec 04             	sub    $0x4,%esp
  8025f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8025fd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 00                	push   $0x0
  802609:	50                   	push   %eax
  80260a:	6a 15                	push   $0x15
  80260c:	e8 d3 fd ff ff       	call   8023e4 <syscall>
  802611:	83 c4 18             	add    $0x18,%esp
}
  802614:	90                   	nop
  802615:	c9                   	leave  
  802616:	c3                   	ret    

00802617 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	6a 16                	push   $0x16
  802626:	e8 b9 fd ff ff       	call   8023e4 <syscall>
  80262b:	83 c4 18             	add    $0x18,%esp
}
  80262e:	90                   	nop
  80262f:	c9                   	leave  
  802630:	c3                   	ret    

00802631 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802634:	8b 45 08             	mov    0x8(%ebp),%eax
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	ff 75 0c             	pushl  0xc(%ebp)
  802640:	50                   	push   %eax
  802641:	6a 17                	push   $0x17
  802643:	e8 9c fd ff ff       	call   8023e4 <syscall>
  802648:	83 c4 18             	add    $0x18,%esp
}
  80264b:	c9                   	leave  
  80264c:	c3                   	ret    

0080264d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802650:	8b 55 0c             	mov    0xc(%ebp),%edx
  802653:	8b 45 08             	mov    0x8(%ebp),%eax
  802656:	6a 00                	push   $0x0
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	52                   	push   %edx
  80265d:	50                   	push   %eax
  80265e:	6a 1a                	push   $0x1a
  802660:	e8 7f fd ff ff       	call   8023e4 <syscall>
  802665:	83 c4 18             	add    $0x18,%esp
}
  802668:	c9                   	leave  
  802669:	c3                   	ret    

0080266a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80266a:	55                   	push   %ebp
  80266b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80266d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802670:	8b 45 08             	mov    0x8(%ebp),%eax
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	52                   	push   %edx
  80267a:	50                   	push   %eax
  80267b:	6a 18                	push   $0x18
  80267d:	e8 62 fd ff ff       	call   8023e4 <syscall>
  802682:	83 c4 18             	add    $0x18,%esp
}
  802685:	90                   	nop
  802686:	c9                   	leave  
  802687:	c3                   	ret    

00802688 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80268b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80268e:	8b 45 08             	mov    0x8(%ebp),%eax
  802691:	6a 00                	push   $0x0
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	52                   	push   %edx
  802698:	50                   	push   %eax
  802699:	6a 19                	push   $0x19
  80269b:	e8 44 fd ff ff       	call   8023e4 <syscall>
  8026a0:	83 c4 18             	add    $0x18,%esp
}
  8026a3:	90                   	nop
  8026a4:	c9                   	leave  
  8026a5:	c3                   	ret    

008026a6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
  8026a9:	83 ec 04             	sub    $0x4,%esp
  8026ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8026af:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8026b2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026b5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8026b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bc:	6a 00                	push   $0x0
  8026be:	51                   	push   %ecx
  8026bf:	52                   	push   %edx
  8026c0:	ff 75 0c             	pushl  0xc(%ebp)
  8026c3:	50                   	push   %eax
  8026c4:	6a 1b                	push   $0x1b
  8026c6:	e8 19 fd ff ff       	call   8023e4 <syscall>
  8026cb:	83 c4 18             	add    $0x18,%esp
}
  8026ce:	c9                   	leave  
  8026cf:	c3                   	ret    

008026d0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8026d0:	55                   	push   %ebp
  8026d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8026d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 00                	push   $0x0
  8026df:	52                   	push   %edx
  8026e0:	50                   	push   %eax
  8026e1:	6a 1c                	push   $0x1c
  8026e3:	e8 fc fc ff ff       	call   8023e4 <syscall>
  8026e8:	83 c4 18             	add    $0x18,%esp
}
  8026eb:	c9                   	leave  
  8026ec:	c3                   	ret    

008026ed <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8026ed:	55                   	push   %ebp
  8026ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8026f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f9:	6a 00                	push   $0x0
  8026fb:	6a 00                	push   $0x0
  8026fd:	51                   	push   %ecx
  8026fe:	52                   	push   %edx
  8026ff:	50                   	push   %eax
  802700:	6a 1d                	push   $0x1d
  802702:	e8 dd fc ff ff       	call   8023e4 <syscall>
  802707:	83 c4 18             	add    $0x18,%esp
}
  80270a:	c9                   	leave  
  80270b:	c3                   	ret    

0080270c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80270c:	55                   	push   %ebp
  80270d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80270f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802712:	8b 45 08             	mov    0x8(%ebp),%eax
  802715:	6a 00                	push   $0x0
  802717:	6a 00                	push   $0x0
  802719:	6a 00                	push   $0x0
  80271b:	52                   	push   %edx
  80271c:	50                   	push   %eax
  80271d:	6a 1e                	push   $0x1e
  80271f:	e8 c0 fc ff ff       	call   8023e4 <syscall>
  802724:	83 c4 18             	add    $0x18,%esp
}
  802727:	c9                   	leave  
  802728:	c3                   	ret    

00802729 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802729:	55                   	push   %ebp
  80272a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80272c:	6a 00                	push   $0x0
  80272e:	6a 00                	push   $0x0
  802730:	6a 00                	push   $0x0
  802732:	6a 00                	push   $0x0
  802734:	6a 00                	push   $0x0
  802736:	6a 1f                	push   $0x1f
  802738:	e8 a7 fc ff ff       	call   8023e4 <syscall>
  80273d:	83 c4 18             	add    $0x18,%esp
}
  802740:	c9                   	leave  
  802741:	c3                   	ret    

00802742 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802742:	55                   	push   %ebp
  802743:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802745:	8b 45 08             	mov    0x8(%ebp),%eax
  802748:	6a 00                	push   $0x0
  80274a:	ff 75 14             	pushl  0x14(%ebp)
  80274d:	ff 75 10             	pushl  0x10(%ebp)
  802750:	ff 75 0c             	pushl  0xc(%ebp)
  802753:	50                   	push   %eax
  802754:	6a 20                	push   $0x20
  802756:	e8 89 fc ff ff       	call   8023e4 <syscall>
  80275b:	83 c4 18             	add    $0x18,%esp
}
  80275e:	c9                   	leave  
  80275f:	c3                   	ret    

00802760 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802760:	55                   	push   %ebp
  802761:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802763:	8b 45 08             	mov    0x8(%ebp),%eax
  802766:	6a 00                	push   $0x0
  802768:	6a 00                	push   $0x0
  80276a:	6a 00                	push   $0x0
  80276c:	6a 00                	push   $0x0
  80276e:	50                   	push   %eax
  80276f:	6a 21                	push   $0x21
  802771:	e8 6e fc ff ff       	call   8023e4 <syscall>
  802776:	83 c4 18             	add    $0x18,%esp
}
  802779:	90                   	nop
  80277a:	c9                   	leave  
  80277b:	c3                   	ret    

0080277c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80277c:	55                   	push   %ebp
  80277d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80277f:	8b 45 08             	mov    0x8(%ebp),%eax
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	6a 00                	push   $0x0
  802788:	6a 00                	push   $0x0
  80278a:	50                   	push   %eax
  80278b:	6a 22                	push   $0x22
  80278d:	e8 52 fc ff ff       	call   8023e4 <syscall>
  802792:	83 c4 18             	add    $0x18,%esp
}
  802795:	c9                   	leave  
  802796:	c3                   	ret    

00802797 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802797:	55                   	push   %ebp
  802798:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 02                	push   $0x2
  8027a6:	e8 39 fc ff ff       	call   8023e4 <syscall>
  8027ab:	83 c4 18             	add    $0x18,%esp
}
  8027ae:	c9                   	leave  
  8027af:	c3                   	ret    

008027b0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8027b3:	6a 00                	push   $0x0
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 00                	push   $0x0
  8027bd:	6a 03                	push   $0x3
  8027bf:	e8 20 fc ff ff       	call   8023e4 <syscall>
  8027c4:	83 c4 18             	add    $0x18,%esp
}
  8027c7:	c9                   	leave  
  8027c8:	c3                   	ret    

008027c9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8027c9:	55                   	push   %ebp
  8027ca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8027cc:	6a 00                	push   $0x0
  8027ce:	6a 00                	push   $0x0
  8027d0:	6a 00                	push   $0x0
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 00                	push   $0x0
  8027d6:	6a 04                	push   $0x4
  8027d8:	e8 07 fc ff ff       	call   8023e4 <syscall>
  8027dd:	83 c4 18             	add    $0x18,%esp
}
  8027e0:	c9                   	leave  
  8027e1:	c3                   	ret    

008027e2 <sys_exit_env>:


void sys_exit_env(void)
{
  8027e2:	55                   	push   %ebp
  8027e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8027e5:	6a 00                	push   $0x0
  8027e7:	6a 00                	push   $0x0
  8027e9:	6a 00                	push   $0x0
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 23                	push   $0x23
  8027f1:	e8 ee fb ff ff       	call   8023e4 <syscall>
  8027f6:	83 c4 18             	add    $0x18,%esp
}
  8027f9:	90                   	nop
  8027fa:	c9                   	leave  
  8027fb:	c3                   	ret    

008027fc <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8027fc:	55                   	push   %ebp
  8027fd:	89 e5                	mov    %esp,%ebp
  8027ff:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802802:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802805:	8d 50 04             	lea    0x4(%eax),%edx
  802808:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80280b:	6a 00                	push   $0x0
  80280d:	6a 00                	push   $0x0
  80280f:	6a 00                	push   $0x0
  802811:	52                   	push   %edx
  802812:	50                   	push   %eax
  802813:	6a 24                	push   $0x24
  802815:	e8 ca fb ff ff       	call   8023e4 <syscall>
  80281a:	83 c4 18             	add    $0x18,%esp
	return result;
  80281d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802820:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802823:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802826:	89 01                	mov    %eax,(%ecx)
  802828:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80282b:	8b 45 08             	mov    0x8(%ebp),%eax
  80282e:	c9                   	leave  
  80282f:	c2 04 00             	ret    $0x4

00802832 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802832:	55                   	push   %ebp
  802833:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802835:	6a 00                	push   $0x0
  802837:	6a 00                	push   $0x0
  802839:	ff 75 10             	pushl  0x10(%ebp)
  80283c:	ff 75 0c             	pushl  0xc(%ebp)
  80283f:	ff 75 08             	pushl  0x8(%ebp)
  802842:	6a 12                	push   $0x12
  802844:	e8 9b fb ff ff       	call   8023e4 <syscall>
  802849:	83 c4 18             	add    $0x18,%esp
	return ;
  80284c:	90                   	nop
}
  80284d:	c9                   	leave  
  80284e:	c3                   	ret    

0080284f <sys_rcr2>:
uint32 sys_rcr2()
{
  80284f:	55                   	push   %ebp
  802850:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802852:	6a 00                	push   $0x0
  802854:	6a 00                	push   $0x0
  802856:	6a 00                	push   $0x0
  802858:	6a 00                	push   $0x0
  80285a:	6a 00                	push   $0x0
  80285c:	6a 25                	push   $0x25
  80285e:	e8 81 fb ff ff       	call   8023e4 <syscall>
  802863:	83 c4 18             	add    $0x18,%esp
}
  802866:	c9                   	leave  
  802867:	c3                   	ret    

00802868 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802868:	55                   	push   %ebp
  802869:	89 e5                	mov    %esp,%ebp
  80286b:	83 ec 04             	sub    $0x4,%esp
  80286e:	8b 45 08             	mov    0x8(%ebp),%eax
  802871:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802874:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802878:	6a 00                	push   $0x0
  80287a:	6a 00                	push   $0x0
  80287c:	6a 00                	push   $0x0
  80287e:	6a 00                	push   $0x0
  802880:	50                   	push   %eax
  802881:	6a 26                	push   $0x26
  802883:	e8 5c fb ff ff       	call   8023e4 <syscall>
  802888:	83 c4 18             	add    $0x18,%esp
	return ;
  80288b:	90                   	nop
}
  80288c:	c9                   	leave  
  80288d:	c3                   	ret    

0080288e <rsttst>:
void rsttst()
{
  80288e:	55                   	push   %ebp
  80288f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802891:	6a 00                	push   $0x0
  802893:	6a 00                	push   $0x0
  802895:	6a 00                	push   $0x0
  802897:	6a 00                	push   $0x0
  802899:	6a 00                	push   $0x0
  80289b:	6a 28                	push   $0x28
  80289d:	e8 42 fb ff ff       	call   8023e4 <syscall>
  8028a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8028a5:	90                   	nop
}
  8028a6:	c9                   	leave  
  8028a7:	c3                   	ret    

008028a8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8028a8:	55                   	push   %ebp
  8028a9:	89 e5                	mov    %esp,%ebp
  8028ab:	83 ec 04             	sub    $0x4,%esp
  8028ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8028b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8028b4:	8b 55 18             	mov    0x18(%ebp),%edx
  8028b7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028bb:	52                   	push   %edx
  8028bc:	50                   	push   %eax
  8028bd:	ff 75 10             	pushl  0x10(%ebp)
  8028c0:	ff 75 0c             	pushl  0xc(%ebp)
  8028c3:	ff 75 08             	pushl  0x8(%ebp)
  8028c6:	6a 27                	push   $0x27
  8028c8:	e8 17 fb ff ff       	call   8023e4 <syscall>
  8028cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8028d0:	90                   	nop
}
  8028d1:	c9                   	leave  
  8028d2:	c3                   	ret    

008028d3 <chktst>:
void chktst(uint32 n)
{
  8028d3:	55                   	push   %ebp
  8028d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8028d6:	6a 00                	push   $0x0
  8028d8:	6a 00                	push   $0x0
  8028da:	6a 00                	push   $0x0
  8028dc:	6a 00                	push   $0x0
  8028de:	ff 75 08             	pushl  0x8(%ebp)
  8028e1:	6a 29                	push   $0x29
  8028e3:	e8 fc fa ff ff       	call   8023e4 <syscall>
  8028e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8028eb:	90                   	nop
}
  8028ec:	c9                   	leave  
  8028ed:	c3                   	ret    

008028ee <inctst>:

void inctst()
{
  8028ee:	55                   	push   %ebp
  8028ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8028f1:	6a 00                	push   $0x0
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 00                	push   $0x0
  8028f7:	6a 00                	push   $0x0
  8028f9:	6a 00                	push   $0x0
  8028fb:	6a 2a                	push   $0x2a
  8028fd:	e8 e2 fa ff ff       	call   8023e4 <syscall>
  802902:	83 c4 18             	add    $0x18,%esp
	return ;
  802905:	90                   	nop
}
  802906:	c9                   	leave  
  802907:	c3                   	ret    

00802908 <gettst>:
uint32 gettst()
{
  802908:	55                   	push   %ebp
  802909:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80290b:	6a 00                	push   $0x0
  80290d:	6a 00                	push   $0x0
  80290f:	6a 00                	push   $0x0
  802911:	6a 00                	push   $0x0
  802913:	6a 00                	push   $0x0
  802915:	6a 2b                	push   $0x2b
  802917:	e8 c8 fa ff ff       	call   8023e4 <syscall>
  80291c:	83 c4 18             	add    $0x18,%esp
}
  80291f:	c9                   	leave  
  802920:	c3                   	ret    

00802921 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802921:	55                   	push   %ebp
  802922:	89 e5                	mov    %esp,%ebp
  802924:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802927:	6a 00                	push   $0x0
  802929:	6a 00                	push   $0x0
  80292b:	6a 00                	push   $0x0
  80292d:	6a 00                	push   $0x0
  80292f:	6a 00                	push   $0x0
  802931:	6a 2c                	push   $0x2c
  802933:	e8 ac fa ff ff       	call   8023e4 <syscall>
  802938:	83 c4 18             	add    $0x18,%esp
  80293b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80293e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802942:	75 07                	jne    80294b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802944:	b8 01 00 00 00       	mov    $0x1,%eax
  802949:	eb 05                	jmp    802950 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80294b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802950:	c9                   	leave  
  802951:	c3                   	ret    

00802952 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802952:	55                   	push   %ebp
  802953:	89 e5                	mov    %esp,%ebp
  802955:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802958:	6a 00                	push   $0x0
  80295a:	6a 00                	push   $0x0
  80295c:	6a 00                	push   $0x0
  80295e:	6a 00                	push   $0x0
  802960:	6a 00                	push   $0x0
  802962:	6a 2c                	push   $0x2c
  802964:	e8 7b fa ff ff       	call   8023e4 <syscall>
  802969:	83 c4 18             	add    $0x18,%esp
  80296c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80296f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802973:	75 07                	jne    80297c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802975:	b8 01 00 00 00       	mov    $0x1,%eax
  80297a:	eb 05                	jmp    802981 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80297c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802981:	c9                   	leave  
  802982:	c3                   	ret    

00802983 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802983:	55                   	push   %ebp
  802984:	89 e5                	mov    %esp,%ebp
  802986:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802989:	6a 00                	push   $0x0
  80298b:	6a 00                	push   $0x0
  80298d:	6a 00                	push   $0x0
  80298f:	6a 00                	push   $0x0
  802991:	6a 00                	push   $0x0
  802993:	6a 2c                	push   $0x2c
  802995:	e8 4a fa ff ff       	call   8023e4 <syscall>
  80299a:	83 c4 18             	add    $0x18,%esp
  80299d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8029a0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8029a4:	75 07                	jne    8029ad <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8029a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029ab:	eb 05                	jmp    8029b2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8029ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029b2:	c9                   	leave  
  8029b3:	c3                   	ret    

008029b4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8029b4:	55                   	push   %ebp
  8029b5:	89 e5                	mov    %esp,%ebp
  8029b7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029ba:	6a 00                	push   $0x0
  8029bc:	6a 00                	push   $0x0
  8029be:	6a 00                	push   $0x0
  8029c0:	6a 00                	push   $0x0
  8029c2:	6a 00                	push   $0x0
  8029c4:	6a 2c                	push   $0x2c
  8029c6:	e8 19 fa ff ff       	call   8023e4 <syscall>
  8029cb:	83 c4 18             	add    $0x18,%esp
  8029ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8029d1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8029d5:	75 07                	jne    8029de <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8029d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8029dc:	eb 05                	jmp    8029e3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8029de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029e3:	c9                   	leave  
  8029e4:	c3                   	ret    

008029e5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8029e5:	55                   	push   %ebp
  8029e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8029e8:	6a 00                	push   $0x0
  8029ea:	6a 00                	push   $0x0
  8029ec:	6a 00                	push   $0x0
  8029ee:	6a 00                	push   $0x0
  8029f0:	ff 75 08             	pushl  0x8(%ebp)
  8029f3:	6a 2d                	push   $0x2d
  8029f5:	e8 ea f9 ff ff       	call   8023e4 <syscall>
  8029fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8029fd:	90                   	nop
}
  8029fe:	c9                   	leave  
  8029ff:	c3                   	ret    

00802a00 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802a00:	55                   	push   %ebp
  802a01:	89 e5                	mov    %esp,%ebp
  802a03:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802a04:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a07:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a10:	6a 00                	push   $0x0
  802a12:	53                   	push   %ebx
  802a13:	51                   	push   %ecx
  802a14:	52                   	push   %edx
  802a15:	50                   	push   %eax
  802a16:	6a 2e                	push   $0x2e
  802a18:	e8 c7 f9 ff ff       	call   8023e4 <syscall>
  802a1d:	83 c4 18             	add    $0x18,%esp
}
  802a20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a23:	c9                   	leave  
  802a24:	c3                   	ret    

00802a25 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802a25:	55                   	push   %ebp
  802a26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802a28:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2e:	6a 00                	push   $0x0
  802a30:	6a 00                	push   $0x0
  802a32:	6a 00                	push   $0x0
  802a34:	52                   	push   %edx
  802a35:	50                   	push   %eax
  802a36:	6a 2f                	push   $0x2f
  802a38:	e8 a7 f9 ff ff       	call   8023e4 <syscall>
  802a3d:	83 c4 18             	add    $0x18,%esp
}
  802a40:	c9                   	leave  
  802a41:	c3                   	ret    

00802a42 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802a42:	55                   	push   %ebp
  802a43:	89 e5                	mov    %esp,%ebp
  802a45:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802a48:	83 ec 0c             	sub    $0xc,%esp
  802a4b:	68 9c 46 80 00       	push   $0x80469c
  802a50:	e8 21 e7 ff ff       	call   801176 <cprintf>
  802a55:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802a58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802a5f:	83 ec 0c             	sub    $0xc,%esp
  802a62:	68 c8 46 80 00       	push   $0x8046c8
  802a67:	e8 0a e7 ff ff       	call   801176 <cprintf>
  802a6c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802a6f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a73:	a1 38 51 80 00       	mov    0x805138,%eax
  802a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a7b:	eb 56                	jmp    802ad3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802a7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a81:	74 1c                	je     802a9f <print_mem_block_lists+0x5d>
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	8b 50 08             	mov    0x8(%eax),%edx
  802a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8c:	8b 48 08             	mov    0x8(%eax),%ecx
  802a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a92:	8b 40 0c             	mov    0xc(%eax),%eax
  802a95:	01 c8                	add    %ecx,%eax
  802a97:	39 c2                	cmp    %eax,%edx
  802a99:	73 04                	jae    802a9f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802a9b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 50 08             	mov    0x8(%eax),%edx
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	8b 40 0c             	mov    0xc(%eax),%eax
  802aab:	01 c2                	add    %eax,%edx
  802aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab0:	8b 40 08             	mov    0x8(%eax),%eax
  802ab3:	83 ec 04             	sub    $0x4,%esp
  802ab6:	52                   	push   %edx
  802ab7:	50                   	push   %eax
  802ab8:	68 dd 46 80 00       	push   $0x8046dd
  802abd:	e8 b4 e6 ff ff       	call   801176 <cprintf>
  802ac2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802acb:	a1 40 51 80 00       	mov    0x805140,%eax
  802ad0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad7:	74 07                	je     802ae0 <print_mem_block_lists+0x9e>
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	8b 00                	mov    (%eax),%eax
  802ade:	eb 05                	jmp    802ae5 <print_mem_block_lists+0xa3>
  802ae0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae5:	a3 40 51 80 00       	mov    %eax,0x805140
  802aea:	a1 40 51 80 00       	mov    0x805140,%eax
  802aef:	85 c0                	test   %eax,%eax
  802af1:	75 8a                	jne    802a7d <print_mem_block_lists+0x3b>
  802af3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af7:	75 84                	jne    802a7d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802af9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802afd:	75 10                	jne    802b0f <print_mem_block_lists+0xcd>
  802aff:	83 ec 0c             	sub    $0xc,%esp
  802b02:	68 ec 46 80 00       	push   $0x8046ec
  802b07:	e8 6a e6 ff ff       	call   801176 <cprintf>
  802b0c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802b0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802b16:	83 ec 0c             	sub    $0xc,%esp
  802b19:	68 10 47 80 00       	push   $0x804710
  802b1e:	e8 53 e6 ff ff       	call   801176 <cprintf>
  802b23:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802b26:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802b2a:	a1 40 50 80 00       	mov    0x805040,%eax
  802b2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b32:	eb 56                	jmp    802b8a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802b34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b38:	74 1c                	je     802b56 <print_mem_block_lists+0x114>
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 50 08             	mov    0x8(%eax),%edx
  802b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b43:	8b 48 08             	mov    0x8(%eax),%ecx
  802b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b49:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4c:	01 c8                	add    %ecx,%eax
  802b4e:	39 c2                	cmp    %eax,%edx
  802b50:	73 04                	jae    802b56 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802b52:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	8b 50 08             	mov    0x8(%eax),%edx
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b62:	01 c2                	add    %eax,%edx
  802b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b67:	8b 40 08             	mov    0x8(%eax),%eax
  802b6a:	83 ec 04             	sub    $0x4,%esp
  802b6d:	52                   	push   %edx
  802b6e:	50                   	push   %eax
  802b6f:	68 dd 46 80 00       	push   $0x8046dd
  802b74:	e8 fd e5 ff ff       	call   801176 <cprintf>
  802b79:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802b82:	a1 48 50 80 00       	mov    0x805048,%eax
  802b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8e:	74 07                	je     802b97 <print_mem_block_lists+0x155>
  802b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b93:	8b 00                	mov    (%eax),%eax
  802b95:	eb 05                	jmp    802b9c <print_mem_block_lists+0x15a>
  802b97:	b8 00 00 00 00       	mov    $0x0,%eax
  802b9c:	a3 48 50 80 00       	mov    %eax,0x805048
  802ba1:	a1 48 50 80 00       	mov    0x805048,%eax
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	75 8a                	jne    802b34 <print_mem_block_lists+0xf2>
  802baa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bae:	75 84                	jne    802b34 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802bb0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802bb4:	75 10                	jne    802bc6 <print_mem_block_lists+0x184>
  802bb6:	83 ec 0c             	sub    $0xc,%esp
  802bb9:	68 28 47 80 00       	push   $0x804728
  802bbe:	e8 b3 e5 ff ff       	call   801176 <cprintf>
  802bc3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802bc6:	83 ec 0c             	sub    $0xc,%esp
  802bc9:	68 9c 46 80 00       	push   $0x80469c
  802bce:	e8 a3 e5 ff ff       	call   801176 <cprintf>
  802bd3:	83 c4 10             	add    $0x10,%esp

}
  802bd6:	90                   	nop
  802bd7:	c9                   	leave  
  802bd8:	c3                   	ret    

00802bd9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802bd9:	55                   	push   %ebp
  802bda:	89 e5                	mov    %esp,%ebp
  802bdc:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802bdf:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802be6:	00 00 00 
  802be9:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802bf0:	00 00 00 
  802bf3:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802bfa:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802bfd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c04:	e9 9e 00 00 00       	jmp    802ca7 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802c09:	a1 50 50 80 00       	mov    0x805050,%eax
  802c0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c11:	c1 e2 04             	shl    $0x4,%edx
  802c14:	01 d0                	add    %edx,%eax
  802c16:	85 c0                	test   %eax,%eax
  802c18:	75 14                	jne    802c2e <initialize_MemBlocksList+0x55>
  802c1a:	83 ec 04             	sub    $0x4,%esp
  802c1d:	68 50 47 80 00       	push   $0x804750
  802c22:	6a 43                	push   $0x43
  802c24:	68 73 47 80 00       	push   $0x804773
  802c29:	e8 94 e2 ff ff       	call   800ec2 <_panic>
  802c2e:	a1 50 50 80 00       	mov    0x805050,%eax
  802c33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c36:	c1 e2 04             	shl    $0x4,%edx
  802c39:	01 d0                	add    %edx,%eax
  802c3b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802c41:	89 10                	mov    %edx,(%eax)
  802c43:	8b 00                	mov    (%eax),%eax
  802c45:	85 c0                	test   %eax,%eax
  802c47:	74 18                	je     802c61 <initialize_MemBlocksList+0x88>
  802c49:	a1 48 51 80 00       	mov    0x805148,%eax
  802c4e:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802c54:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802c57:	c1 e1 04             	shl    $0x4,%ecx
  802c5a:	01 ca                	add    %ecx,%edx
  802c5c:	89 50 04             	mov    %edx,0x4(%eax)
  802c5f:	eb 12                	jmp    802c73 <initialize_MemBlocksList+0x9a>
  802c61:	a1 50 50 80 00       	mov    0x805050,%eax
  802c66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c69:	c1 e2 04             	shl    $0x4,%edx
  802c6c:	01 d0                	add    %edx,%eax
  802c6e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c73:	a1 50 50 80 00       	mov    0x805050,%eax
  802c78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c7b:	c1 e2 04             	shl    $0x4,%edx
  802c7e:	01 d0                	add    %edx,%eax
  802c80:	a3 48 51 80 00       	mov    %eax,0x805148
  802c85:	a1 50 50 80 00       	mov    0x805050,%eax
  802c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8d:	c1 e2 04             	shl    $0x4,%edx
  802c90:	01 d0                	add    %edx,%eax
  802c92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c99:	a1 54 51 80 00       	mov    0x805154,%eax
  802c9e:	40                   	inc    %eax
  802c9f:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802ca4:	ff 45 f4             	incl   -0xc(%ebp)
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cad:	0f 82 56 ff ff ff    	jb     802c09 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802cb3:	90                   	nop
  802cb4:	c9                   	leave  
  802cb5:	c3                   	ret    

00802cb6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802cb6:	55                   	push   %ebp
  802cb7:	89 e5                	mov    %esp,%ebp
  802cb9:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802cbc:	a1 38 51 80 00       	mov    0x805138,%eax
  802cc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802cc4:	eb 18                	jmp    802cde <find_block+0x28>
	{
		if (ele->sva==va)
  802cc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802cc9:	8b 40 08             	mov    0x8(%eax),%eax
  802ccc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ccf:	75 05                	jne    802cd6 <find_block+0x20>
			return ele;
  802cd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802cd4:	eb 7b                	jmp    802d51 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802cd6:	a1 40 51 80 00       	mov    0x805140,%eax
  802cdb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802cde:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802ce2:	74 07                	je     802ceb <find_block+0x35>
  802ce4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	eb 05                	jmp    802cf0 <find_block+0x3a>
  802ceb:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf0:	a3 40 51 80 00       	mov    %eax,0x805140
  802cf5:	a1 40 51 80 00       	mov    0x805140,%eax
  802cfa:	85 c0                	test   %eax,%eax
  802cfc:	75 c8                	jne    802cc6 <find_block+0x10>
  802cfe:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802d02:	75 c2                	jne    802cc6 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802d04:	a1 40 50 80 00       	mov    0x805040,%eax
  802d09:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802d0c:	eb 18                	jmp    802d26 <find_block+0x70>
	{
		if (ele->sva==va)
  802d0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d11:	8b 40 08             	mov    0x8(%eax),%eax
  802d14:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d17:	75 05                	jne    802d1e <find_block+0x68>
					return ele;
  802d19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d1c:	eb 33                	jmp    802d51 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802d1e:	a1 48 50 80 00       	mov    0x805048,%eax
  802d23:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802d26:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802d2a:	74 07                	je     802d33 <find_block+0x7d>
  802d2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d2f:	8b 00                	mov    (%eax),%eax
  802d31:	eb 05                	jmp    802d38 <find_block+0x82>
  802d33:	b8 00 00 00 00       	mov    $0x0,%eax
  802d38:	a3 48 50 80 00       	mov    %eax,0x805048
  802d3d:	a1 48 50 80 00       	mov    0x805048,%eax
  802d42:	85 c0                	test   %eax,%eax
  802d44:	75 c8                	jne    802d0e <find_block+0x58>
  802d46:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802d4a:	75 c2                	jne    802d0e <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802d4c:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802d51:	c9                   	leave  
  802d52:	c3                   	ret    

00802d53 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802d53:	55                   	push   %ebp
  802d54:	89 e5                	mov    %esp,%ebp
  802d56:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802d59:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d5e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802d61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d65:	75 62                	jne    802dc9 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802d67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d6b:	75 14                	jne    802d81 <insert_sorted_allocList+0x2e>
  802d6d:	83 ec 04             	sub    $0x4,%esp
  802d70:	68 50 47 80 00       	push   $0x804750
  802d75:	6a 69                	push   $0x69
  802d77:	68 73 47 80 00       	push   $0x804773
  802d7c:	e8 41 e1 ff ff       	call   800ec2 <_panic>
  802d81:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802d87:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8a:	89 10                	mov    %edx,(%eax)
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	8b 00                	mov    (%eax),%eax
  802d91:	85 c0                	test   %eax,%eax
  802d93:	74 0d                	je     802da2 <insert_sorted_allocList+0x4f>
  802d95:	a1 40 50 80 00       	mov    0x805040,%eax
  802d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9d:	89 50 04             	mov    %edx,0x4(%eax)
  802da0:	eb 08                	jmp    802daa <insert_sorted_allocList+0x57>
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	a3 44 50 80 00       	mov    %eax,0x805044
  802daa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dad:	a3 40 50 80 00       	mov    %eax,0x805040
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dbc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802dc1:	40                   	inc    %eax
  802dc2:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802dc7:	eb 72                	jmp    802e3b <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802dc9:	a1 40 50 80 00       	mov    0x805040,%eax
  802dce:	8b 50 08             	mov    0x8(%eax),%edx
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	8b 40 08             	mov    0x8(%eax),%eax
  802dd7:	39 c2                	cmp    %eax,%edx
  802dd9:	76 60                	jbe    802e3b <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802ddb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ddf:	75 14                	jne    802df5 <insert_sorted_allocList+0xa2>
  802de1:	83 ec 04             	sub    $0x4,%esp
  802de4:	68 50 47 80 00       	push   $0x804750
  802de9:	6a 6d                	push   $0x6d
  802deb:	68 73 47 80 00       	push   $0x804773
  802df0:	e8 cd e0 ff ff       	call   800ec2 <_panic>
  802df5:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	89 10                	mov    %edx,(%eax)
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	8b 00                	mov    (%eax),%eax
  802e05:	85 c0                	test   %eax,%eax
  802e07:	74 0d                	je     802e16 <insert_sorted_allocList+0xc3>
  802e09:	a1 40 50 80 00       	mov    0x805040,%eax
  802e0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e11:	89 50 04             	mov    %edx,0x4(%eax)
  802e14:	eb 08                	jmp    802e1e <insert_sorted_allocList+0xcb>
  802e16:	8b 45 08             	mov    0x8(%ebp),%eax
  802e19:	a3 44 50 80 00       	mov    %eax,0x805044
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	a3 40 50 80 00       	mov    %eax,0x805040
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e30:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e35:	40                   	inc    %eax
  802e36:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802e3b:	a1 40 50 80 00       	mov    0x805040,%eax
  802e40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e43:	e9 b9 01 00 00       	jmp    803001 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802e48:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4b:	8b 50 08             	mov    0x8(%eax),%edx
  802e4e:	a1 40 50 80 00       	mov    0x805040,%eax
  802e53:	8b 40 08             	mov    0x8(%eax),%eax
  802e56:	39 c2                	cmp    %eax,%edx
  802e58:	76 7c                	jbe    802ed6 <insert_sorted_allocList+0x183>
  802e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5d:	8b 50 08             	mov    0x8(%eax),%edx
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	8b 40 08             	mov    0x8(%eax),%eax
  802e66:	39 c2                	cmp    %eax,%edx
  802e68:	73 6c                	jae    802ed6 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802e6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6e:	74 06                	je     802e76 <insert_sorted_allocList+0x123>
  802e70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e74:	75 14                	jne    802e8a <insert_sorted_allocList+0x137>
  802e76:	83 ec 04             	sub    $0x4,%esp
  802e79:	68 8c 47 80 00       	push   $0x80478c
  802e7e:	6a 75                	push   $0x75
  802e80:	68 73 47 80 00       	push   $0x804773
  802e85:	e8 38 e0 ff ff       	call   800ec2 <_panic>
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	8b 50 04             	mov    0x4(%eax),%edx
  802e90:	8b 45 08             	mov    0x8(%ebp),%eax
  802e93:	89 50 04             	mov    %edx,0x4(%eax)
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e9c:	89 10                	mov    %edx,(%eax)
  802e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea1:	8b 40 04             	mov    0x4(%eax),%eax
  802ea4:	85 c0                	test   %eax,%eax
  802ea6:	74 0d                	je     802eb5 <insert_sorted_allocList+0x162>
  802ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eab:	8b 40 04             	mov    0x4(%eax),%eax
  802eae:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb1:	89 10                	mov    %edx,(%eax)
  802eb3:	eb 08                	jmp    802ebd <insert_sorted_allocList+0x16a>
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	a3 40 50 80 00       	mov    %eax,0x805040
  802ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec3:	89 50 04             	mov    %edx,0x4(%eax)
  802ec6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ecb:	40                   	inc    %eax
  802ecc:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  802ed1:	e9 59 01 00 00       	jmp    80302f <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed9:	8b 50 08             	mov    0x8(%eax),%edx
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 40 08             	mov    0x8(%eax),%eax
  802ee2:	39 c2                	cmp    %eax,%edx
  802ee4:	0f 86 98 00 00 00    	jbe    802f82 <insert_sorted_allocList+0x22f>
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	8b 50 08             	mov    0x8(%eax),%edx
  802ef0:	a1 44 50 80 00       	mov    0x805044,%eax
  802ef5:	8b 40 08             	mov    0x8(%eax),%eax
  802ef8:	39 c2                	cmp    %eax,%edx
  802efa:	0f 83 82 00 00 00    	jae    802f82 <insert_sorted_allocList+0x22f>
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	8b 50 08             	mov    0x8(%eax),%edx
  802f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f09:	8b 00                	mov    (%eax),%eax
  802f0b:	8b 40 08             	mov    0x8(%eax),%eax
  802f0e:	39 c2                	cmp    %eax,%edx
  802f10:	73 70                	jae    802f82 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802f12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f16:	74 06                	je     802f1e <insert_sorted_allocList+0x1cb>
  802f18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f1c:	75 14                	jne    802f32 <insert_sorted_allocList+0x1df>
  802f1e:	83 ec 04             	sub    $0x4,%esp
  802f21:	68 c4 47 80 00       	push   $0x8047c4
  802f26:	6a 7c                	push   $0x7c
  802f28:	68 73 47 80 00       	push   $0x804773
  802f2d:	e8 90 df ff ff       	call   800ec2 <_panic>
  802f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f35:	8b 10                	mov    (%eax),%edx
  802f37:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3a:	89 10                	mov    %edx,(%eax)
  802f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3f:	8b 00                	mov    (%eax),%eax
  802f41:	85 c0                	test   %eax,%eax
  802f43:	74 0b                	je     802f50 <insert_sorted_allocList+0x1fd>
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	8b 00                	mov    (%eax),%eax
  802f4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f4d:	89 50 04             	mov    %edx,0x4(%eax)
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	8b 55 08             	mov    0x8(%ebp),%edx
  802f56:	89 10                	mov    %edx,(%eax)
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f5e:	89 50 04             	mov    %edx,0x4(%eax)
  802f61:	8b 45 08             	mov    0x8(%ebp),%eax
  802f64:	8b 00                	mov    (%eax),%eax
  802f66:	85 c0                	test   %eax,%eax
  802f68:	75 08                	jne    802f72 <insert_sorted_allocList+0x21f>
  802f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6d:	a3 44 50 80 00       	mov    %eax,0x805044
  802f72:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802f77:	40                   	inc    %eax
  802f78:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802f7d:	e9 ad 00 00 00       	jmp    80302f <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802f82:	8b 45 08             	mov    0x8(%ebp),%eax
  802f85:	8b 50 08             	mov    0x8(%eax),%edx
  802f88:	a1 44 50 80 00       	mov    0x805044,%eax
  802f8d:	8b 40 08             	mov    0x8(%eax),%eax
  802f90:	39 c2                	cmp    %eax,%edx
  802f92:	76 65                	jbe    802ff9 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802f94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f98:	75 17                	jne    802fb1 <insert_sorted_allocList+0x25e>
  802f9a:	83 ec 04             	sub    $0x4,%esp
  802f9d:	68 f8 47 80 00       	push   $0x8047f8
  802fa2:	68 80 00 00 00       	push   $0x80
  802fa7:	68 73 47 80 00       	push   $0x804773
  802fac:	e8 11 df ff ff       	call   800ec2 <_panic>
  802fb1:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	89 50 04             	mov    %edx,0x4(%eax)
  802fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc0:	8b 40 04             	mov    0x4(%eax),%eax
  802fc3:	85 c0                	test   %eax,%eax
  802fc5:	74 0c                	je     802fd3 <insert_sorted_allocList+0x280>
  802fc7:	a1 44 50 80 00       	mov    0x805044,%eax
  802fcc:	8b 55 08             	mov    0x8(%ebp),%edx
  802fcf:	89 10                	mov    %edx,(%eax)
  802fd1:	eb 08                	jmp    802fdb <insert_sorted_allocList+0x288>
  802fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd6:	a3 40 50 80 00       	mov    %eax,0x805040
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	a3 44 50 80 00       	mov    %eax,0x805044
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fec:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ff1:	40                   	inc    %eax
  802ff2:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802ff7:	eb 36                	jmp    80302f <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802ff9:	a1 48 50 80 00       	mov    0x805048,%eax
  802ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803001:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803005:	74 07                	je     80300e <insert_sorted_allocList+0x2bb>
  803007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300a:	8b 00                	mov    (%eax),%eax
  80300c:	eb 05                	jmp    803013 <insert_sorted_allocList+0x2c0>
  80300e:	b8 00 00 00 00       	mov    $0x0,%eax
  803013:	a3 48 50 80 00       	mov    %eax,0x805048
  803018:	a1 48 50 80 00       	mov    0x805048,%eax
  80301d:	85 c0                	test   %eax,%eax
  80301f:	0f 85 23 fe ff ff    	jne    802e48 <insert_sorted_allocList+0xf5>
  803025:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803029:	0f 85 19 fe ff ff    	jne    802e48 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  80302f:	90                   	nop
  803030:	c9                   	leave  
  803031:	c3                   	ret    

00803032 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  803032:	55                   	push   %ebp
  803033:	89 e5                	mov    %esp,%ebp
  803035:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  803038:	a1 38 51 80 00       	mov    0x805138,%eax
  80303d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803040:	e9 7c 01 00 00       	jmp    8031c1 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  803045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803048:	8b 40 0c             	mov    0xc(%eax),%eax
  80304b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80304e:	0f 85 90 00 00 00    	jne    8030e4 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  803054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803057:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  80305a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80305e:	75 17                	jne    803077 <alloc_block_FF+0x45>
  803060:	83 ec 04             	sub    $0x4,%esp
  803063:	68 1b 48 80 00       	push   $0x80481b
  803068:	68 ba 00 00 00       	push   $0xba
  80306d:	68 73 47 80 00       	push   $0x804773
  803072:	e8 4b de ff ff       	call   800ec2 <_panic>
  803077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307a:	8b 00                	mov    (%eax),%eax
  80307c:	85 c0                	test   %eax,%eax
  80307e:	74 10                	je     803090 <alloc_block_FF+0x5e>
  803080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803083:	8b 00                	mov    (%eax),%eax
  803085:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803088:	8b 52 04             	mov    0x4(%edx),%edx
  80308b:	89 50 04             	mov    %edx,0x4(%eax)
  80308e:	eb 0b                	jmp    80309b <alloc_block_FF+0x69>
  803090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803093:	8b 40 04             	mov    0x4(%eax),%eax
  803096:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80309b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309e:	8b 40 04             	mov    0x4(%eax),%eax
  8030a1:	85 c0                	test   %eax,%eax
  8030a3:	74 0f                	je     8030b4 <alloc_block_FF+0x82>
  8030a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a8:	8b 40 04             	mov    0x4(%eax),%eax
  8030ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ae:	8b 12                	mov    (%edx),%edx
  8030b0:	89 10                	mov    %edx,(%eax)
  8030b2:	eb 0a                	jmp    8030be <alloc_block_FF+0x8c>
  8030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b7:	8b 00                	mov    (%eax),%eax
  8030b9:	a3 38 51 80 00       	mov    %eax,0x805138
  8030be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d1:	a1 44 51 80 00       	mov    0x805144,%eax
  8030d6:	48                   	dec    %eax
  8030d7:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  8030dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030df:	e9 10 01 00 00       	jmp    8031f4 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8030e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030ed:	0f 86 c6 00 00 00    	jbe    8031b9 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8030f3:	a1 48 51 80 00       	mov    0x805148,%eax
  8030f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8030fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030ff:	75 17                	jne    803118 <alloc_block_FF+0xe6>
  803101:	83 ec 04             	sub    $0x4,%esp
  803104:	68 1b 48 80 00       	push   $0x80481b
  803109:	68 c2 00 00 00       	push   $0xc2
  80310e:	68 73 47 80 00       	push   $0x804773
  803113:	e8 aa dd ff ff       	call   800ec2 <_panic>
  803118:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311b:	8b 00                	mov    (%eax),%eax
  80311d:	85 c0                	test   %eax,%eax
  80311f:	74 10                	je     803131 <alloc_block_FF+0xff>
  803121:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803124:	8b 00                	mov    (%eax),%eax
  803126:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803129:	8b 52 04             	mov    0x4(%edx),%edx
  80312c:	89 50 04             	mov    %edx,0x4(%eax)
  80312f:	eb 0b                	jmp    80313c <alloc_block_FF+0x10a>
  803131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803134:	8b 40 04             	mov    0x4(%eax),%eax
  803137:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80313c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313f:	8b 40 04             	mov    0x4(%eax),%eax
  803142:	85 c0                	test   %eax,%eax
  803144:	74 0f                	je     803155 <alloc_block_FF+0x123>
  803146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803149:	8b 40 04             	mov    0x4(%eax),%eax
  80314c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80314f:	8b 12                	mov    (%edx),%edx
  803151:	89 10                	mov    %edx,(%eax)
  803153:	eb 0a                	jmp    80315f <alloc_block_FF+0x12d>
  803155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803158:	8b 00                	mov    (%eax),%eax
  80315a:	a3 48 51 80 00       	mov    %eax,0x805148
  80315f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803162:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803172:	a1 54 51 80 00       	mov    0x805154,%eax
  803177:	48                   	dec    %eax
  803178:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  80317d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803180:	8b 50 08             	mov    0x8(%eax),%edx
  803183:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803186:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  803189:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318c:	8b 55 08             	mov    0x8(%ebp),%edx
  80318f:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  803192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803195:	8b 40 0c             	mov    0xc(%eax),%eax
  803198:	2b 45 08             	sub    0x8(%ebp),%eax
  80319b:	89 c2                	mov    %eax,%edx
  80319d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a0:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	8b 50 08             	mov    0x8(%eax),%edx
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	01 c2                	add    %eax,%edx
  8031ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b1:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8031b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b7:	eb 3b                	jmp    8031f4 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8031b9:	a1 40 51 80 00       	mov    0x805140,%eax
  8031be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c5:	74 07                	je     8031ce <alloc_block_FF+0x19c>
  8031c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ca:	8b 00                	mov    (%eax),%eax
  8031cc:	eb 05                	jmp    8031d3 <alloc_block_FF+0x1a1>
  8031ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d3:	a3 40 51 80 00       	mov    %eax,0x805140
  8031d8:	a1 40 51 80 00       	mov    0x805140,%eax
  8031dd:	85 c0                	test   %eax,%eax
  8031df:	0f 85 60 fe ff ff    	jne    803045 <alloc_block_FF+0x13>
  8031e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e9:	0f 85 56 fe ff ff    	jne    803045 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8031ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f4:	c9                   	leave  
  8031f5:	c3                   	ret    

008031f6 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8031f6:	55                   	push   %ebp
  8031f7:	89 e5                	mov    %esp,%ebp
  8031f9:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8031fc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  803203:	a1 38 51 80 00       	mov    0x805138,%eax
  803208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80320b:	eb 3a                	jmp    803247 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  80320d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803210:	8b 40 0c             	mov    0xc(%eax),%eax
  803213:	3b 45 08             	cmp    0x8(%ebp),%eax
  803216:	72 27                	jb     80323f <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  803218:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80321c:	75 0b                	jne    803229 <alloc_block_BF+0x33>
					best_size= element->size;
  80321e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803221:	8b 40 0c             	mov    0xc(%eax),%eax
  803224:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803227:	eb 16                	jmp    80323f <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  803229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322c:	8b 50 0c             	mov    0xc(%eax),%edx
  80322f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803232:	39 c2                	cmp    %eax,%edx
  803234:	77 09                	ja     80323f <alloc_block_BF+0x49>
					best_size=element->size;
  803236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803239:	8b 40 0c             	mov    0xc(%eax),%eax
  80323c:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80323f:	a1 40 51 80 00       	mov    0x805140,%eax
  803244:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803247:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80324b:	74 07                	je     803254 <alloc_block_BF+0x5e>
  80324d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	eb 05                	jmp    803259 <alloc_block_BF+0x63>
  803254:	b8 00 00 00 00       	mov    $0x0,%eax
  803259:	a3 40 51 80 00       	mov    %eax,0x805140
  80325e:	a1 40 51 80 00       	mov    0x805140,%eax
  803263:	85 c0                	test   %eax,%eax
  803265:	75 a6                	jne    80320d <alloc_block_BF+0x17>
  803267:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80326b:	75 a0                	jne    80320d <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  80326d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803271:	0f 84 d3 01 00 00    	je     80344a <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  803277:	a1 38 51 80 00       	mov    0x805138,%eax
  80327c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80327f:	e9 98 01 00 00       	jmp    80341c <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  803284:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803287:	3b 45 08             	cmp    0x8(%ebp),%eax
  80328a:	0f 86 da 00 00 00    	jbe    80336a <alloc_block_BF+0x174>
  803290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803293:	8b 50 0c             	mov    0xc(%eax),%edx
  803296:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803299:	39 c2                	cmp    %eax,%edx
  80329b:	0f 85 c9 00 00 00    	jne    80336a <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  8032a1:	a1 48 51 80 00       	mov    0x805148,%eax
  8032a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8032a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032ad:	75 17                	jne    8032c6 <alloc_block_BF+0xd0>
  8032af:	83 ec 04             	sub    $0x4,%esp
  8032b2:	68 1b 48 80 00       	push   $0x80481b
  8032b7:	68 ea 00 00 00       	push   $0xea
  8032bc:	68 73 47 80 00       	push   $0x804773
  8032c1:	e8 fc db ff ff       	call   800ec2 <_panic>
  8032c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c9:	8b 00                	mov    (%eax),%eax
  8032cb:	85 c0                	test   %eax,%eax
  8032cd:	74 10                	je     8032df <alloc_block_BF+0xe9>
  8032cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d2:	8b 00                	mov    (%eax),%eax
  8032d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032d7:	8b 52 04             	mov    0x4(%edx),%edx
  8032da:	89 50 04             	mov    %edx,0x4(%eax)
  8032dd:	eb 0b                	jmp    8032ea <alloc_block_BF+0xf4>
  8032df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e2:	8b 40 04             	mov    0x4(%eax),%eax
  8032e5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ed:	8b 40 04             	mov    0x4(%eax),%eax
  8032f0:	85 c0                	test   %eax,%eax
  8032f2:	74 0f                	je     803303 <alloc_block_BF+0x10d>
  8032f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f7:	8b 40 04             	mov    0x4(%eax),%eax
  8032fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032fd:	8b 12                	mov    (%edx),%edx
  8032ff:	89 10                	mov    %edx,(%eax)
  803301:	eb 0a                	jmp    80330d <alloc_block_BF+0x117>
  803303:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803306:	8b 00                	mov    (%eax),%eax
  803308:	a3 48 51 80 00       	mov    %eax,0x805148
  80330d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803310:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803316:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803319:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803320:	a1 54 51 80 00       	mov    0x805154,%eax
  803325:	48                   	dec    %eax
  803326:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  80332b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332e:	8b 50 08             	mov    0x8(%eax),%edx
  803331:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803334:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  803337:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80333a:	8b 55 08             	mov    0x8(%ebp),%edx
  80333d:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  803340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803343:	8b 40 0c             	mov    0xc(%eax),%eax
  803346:	2b 45 08             	sub    0x8(%ebp),%eax
  803349:	89 c2                	mov    %eax,%edx
  80334b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334e:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  803351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803354:	8b 50 08             	mov    0x8(%eax),%edx
  803357:	8b 45 08             	mov    0x8(%ebp),%eax
  80335a:	01 c2                	add    %eax,%edx
  80335c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335f:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  803362:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803365:	e9 e5 00 00 00       	jmp    80344f <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  80336a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336d:	8b 50 0c             	mov    0xc(%eax),%edx
  803370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803373:	39 c2                	cmp    %eax,%edx
  803375:	0f 85 99 00 00 00    	jne    803414 <alloc_block_BF+0x21e>
  80337b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803381:	0f 85 8d 00 00 00    	jne    803414 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  803387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  80338d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803391:	75 17                	jne    8033aa <alloc_block_BF+0x1b4>
  803393:	83 ec 04             	sub    $0x4,%esp
  803396:	68 1b 48 80 00       	push   $0x80481b
  80339b:	68 f7 00 00 00       	push   $0xf7
  8033a0:	68 73 47 80 00       	push   $0x804773
  8033a5:	e8 18 db ff ff       	call   800ec2 <_panic>
  8033aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ad:	8b 00                	mov    (%eax),%eax
  8033af:	85 c0                	test   %eax,%eax
  8033b1:	74 10                	je     8033c3 <alloc_block_BF+0x1cd>
  8033b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b6:	8b 00                	mov    (%eax),%eax
  8033b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033bb:	8b 52 04             	mov    0x4(%edx),%edx
  8033be:	89 50 04             	mov    %edx,0x4(%eax)
  8033c1:	eb 0b                	jmp    8033ce <alloc_block_BF+0x1d8>
  8033c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c6:	8b 40 04             	mov    0x4(%eax),%eax
  8033c9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d1:	8b 40 04             	mov    0x4(%eax),%eax
  8033d4:	85 c0                	test   %eax,%eax
  8033d6:	74 0f                	je     8033e7 <alloc_block_BF+0x1f1>
  8033d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033db:	8b 40 04             	mov    0x4(%eax),%eax
  8033de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033e1:	8b 12                	mov    (%edx),%edx
  8033e3:	89 10                	mov    %edx,(%eax)
  8033e5:	eb 0a                	jmp    8033f1 <alloc_block_BF+0x1fb>
  8033e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ea:	8b 00                	mov    (%eax),%eax
  8033ec:	a3 38 51 80 00       	mov    %eax,0x805138
  8033f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803404:	a1 44 51 80 00       	mov    0x805144,%eax
  803409:	48                   	dec    %eax
  80340a:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  80340f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803412:	eb 3b                	jmp    80344f <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  803414:	a1 40 51 80 00       	mov    0x805140,%eax
  803419:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80341c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803420:	74 07                	je     803429 <alloc_block_BF+0x233>
  803422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803425:	8b 00                	mov    (%eax),%eax
  803427:	eb 05                	jmp    80342e <alloc_block_BF+0x238>
  803429:	b8 00 00 00 00       	mov    $0x0,%eax
  80342e:	a3 40 51 80 00       	mov    %eax,0x805140
  803433:	a1 40 51 80 00       	mov    0x805140,%eax
  803438:	85 c0                	test   %eax,%eax
  80343a:	0f 85 44 fe ff ff    	jne    803284 <alloc_block_BF+0x8e>
  803440:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803444:	0f 85 3a fe ff ff    	jne    803284 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  80344a:	b8 00 00 00 00       	mov    $0x0,%eax
  80344f:	c9                   	leave  
  803450:	c3                   	ret    

00803451 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803451:	55                   	push   %ebp
  803452:	89 e5                	mov    %esp,%ebp
  803454:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  803457:	83 ec 04             	sub    $0x4,%esp
  80345a:	68 3c 48 80 00       	push   $0x80483c
  80345f:	68 04 01 00 00       	push   $0x104
  803464:	68 73 47 80 00       	push   $0x804773
  803469:	e8 54 da ff ff       	call   800ec2 <_panic>

0080346e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  80346e:	55                   	push   %ebp
  80346f:	89 e5                	mov    %esp,%ebp
  803471:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  803474:	a1 38 51 80 00       	mov    0x805138,%eax
  803479:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  80347c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803481:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  803484:	a1 38 51 80 00       	mov    0x805138,%eax
  803489:	85 c0                	test   %eax,%eax
  80348b:	75 68                	jne    8034f5 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  80348d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803491:	75 17                	jne    8034aa <insert_sorted_with_merge_freeList+0x3c>
  803493:	83 ec 04             	sub    $0x4,%esp
  803496:	68 50 47 80 00       	push   $0x804750
  80349b:	68 14 01 00 00       	push   $0x114
  8034a0:	68 73 47 80 00       	push   $0x804773
  8034a5:	e8 18 da ff ff       	call   800ec2 <_panic>
  8034aa:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8034b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b3:	89 10                	mov    %edx,(%eax)
  8034b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b8:	8b 00                	mov    (%eax),%eax
  8034ba:	85 c0                	test   %eax,%eax
  8034bc:	74 0d                	je     8034cb <insert_sorted_with_merge_freeList+0x5d>
  8034be:	a1 38 51 80 00       	mov    0x805138,%eax
  8034c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c6:	89 50 04             	mov    %edx,0x4(%eax)
  8034c9:	eb 08                	jmp    8034d3 <insert_sorted_with_merge_freeList+0x65>
  8034cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ce:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d6:	a3 38 51 80 00       	mov    %eax,0x805138
  8034db:	8b 45 08             	mov    0x8(%ebp),%eax
  8034de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e5:	a1 44 51 80 00       	mov    0x805144,%eax
  8034ea:	40                   	inc    %eax
  8034eb:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  8034f0:	e9 d2 06 00 00       	jmp    803bc7 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8034f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f8:	8b 50 08             	mov    0x8(%eax),%edx
  8034fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034fe:	8b 40 08             	mov    0x8(%eax),%eax
  803501:	39 c2                	cmp    %eax,%edx
  803503:	0f 83 22 01 00 00    	jae    80362b <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  803509:	8b 45 08             	mov    0x8(%ebp),%eax
  80350c:	8b 50 08             	mov    0x8(%eax),%edx
  80350f:	8b 45 08             	mov    0x8(%ebp),%eax
  803512:	8b 40 0c             	mov    0xc(%eax),%eax
  803515:	01 c2                	add    %eax,%edx
  803517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80351a:	8b 40 08             	mov    0x8(%eax),%eax
  80351d:	39 c2                	cmp    %eax,%edx
  80351f:	0f 85 9e 00 00 00    	jne    8035c3 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  803525:	8b 45 08             	mov    0x8(%ebp),%eax
  803528:	8b 50 08             	mov    0x8(%eax),%edx
  80352b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352e:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  803531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803534:	8b 50 0c             	mov    0xc(%eax),%edx
  803537:	8b 45 08             	mov    0x8(%ebp),%eax
  80353a:	8b 40 0c             	mov    0xc(%eax),%eax
  80353d:	01 c2                	add    %eax,%edx
  80353f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803542:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  803545:	8b 45 08             	mov    0x8(%ebp),%eax
  803548:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80354f:	8b 45 08             	mov    0x8(%ebp),%eax
  803552:	8b 50 08             	mov    0x8(%eax),%edx
  803555:	8b 45 08             	mov    0x8(%ebp),%eax
  803558:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80355b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80355f:	75 17                	jne    803578 <insert_sorted_with_merge_freeList+0x10a>
  803561:	83 ec 04             	sub    $0x4,%esp
  803564:	68 50 47 80 00       	push   $0x804750
  803569:	68 21 01 00 00       	push   $0x121
  80356e:	68 73 47 80 00       	push   $0x804773
  803573:	e8 4a d9 ff ff       	call   800ec2 <_panic>
  803578:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80357e:	8b 45 08             	mov    0x8(%ebp),%eax
  803581:	89 10                	mov    %edx,(%eax)
  803583:	8b 45 08             	mov    0x8(%ebp),%eax
  803586:	8b 00                	mov    (%eax),%eax
  803588:	85 c0                	test   %eax,%eax
  80358a:	74 0d                	je     803599 <insert_sorted_with_merge_freeList+0x12b>
  80358c:	a1 48 51 80 00       	mov    0x805148,%eax
  803591:	8b 55 08             	mov    0x8(%ebp),%edx
  803594:	89 50 04             	mov    %edx,0x4(%eax)
  803597:	eb 08                	jmp    8035a1 <insert_sorted_with_merge_freeList+0x133>
  803599:	8b 45 08             	mov    0x8(%ebp),%eax
  80359c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a4:	a3 48 51 80 00       	mov    %eax,0x805148
  8035a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b3:	a1 54 51 80 00       	mov    0x805154,%eax
  8035b8:	40                   	inc    %eax
  8035b9:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  8035be:	e9 04 06 00 00       	jmp    803bc7 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8035c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035c7:	75 17                	jne    8035e0 <insert_sorted_with_merge_freeList+0x172>
  8035c9:	83 ec 04             	sub    $0x4,%esp
  8035cc:	68 50 47 80 00       	push   $0x804750
  8035d1:	68 26 01 00 00       	push   $0x126
  8035d6:	68 73 47 80 00       	push   $0x804773
  8035db:	e8 e2 d8 ff ff       	call   800ec2 <_panic>
  8035e0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8035e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e9:	89 10                	mov    %edx,(%eax)
  8035eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ee:	8b 00                	mov    (%eax),%eax
  8035f0:	85 c0                	test   %eax,%eax
  8035f2:	74 0d                	je     803601 <insert_sorted_with_merge_freeList+0x193>
  8035f4:	a1 38 51 80 00       	mov    0x805138,%eax
  8035f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8035fc:	89 50 04             	mov    %edx,0x4(%eax)
  8035ff:	eb 08                	jmp    803609 <insert_sorted_with_merge_freeList+0x19b>
  803601:	8b 45 08             	mov    0x8(%ebp),%eax
  803604:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803609:	8b 45 08             	mov    0x8(%ebp),%eax
  80360c:	a3 38 51 80 00       	mov    %eax,0x805138
  803611:	8b 45 08             	mov    0x8(%ebp),%eax
  803614:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80361b:	a1 44 51 80 00       	mov    0x805144,%eax
  803620:	40                   	inc    %eax
  803621:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803626:	e9 9c 05 00 00       	jmp    803bc7 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  80362b:	8b 45 08             	mov    0x8(%ebp),%eax
  80362e:	8b 50 08             	mov    0x8(%eax),%edx
  803631:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803634:	8b 40 08             	mov    0x8(%eax),%eax
  803637:	39 c2                	cmp    %eax,%edx
  803639:	0f 86 16 01 00 00    	jbe    803755 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  80363f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803642:	8b 50 08             	mov    0x8(%eax),%edx
  803645:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803648:	8b 40 0c             	mov    0xc(%eax),%eax
  80364b:	01 c2                	add    %eax,%edx
  80364d:	8b 45 08             	mov    0x8(%ebp),%eax
  803650:	8b 40 08             	mov    0x8(%eax),%eax
  803653:	39 c2                	cmp    %eax,%edx
  803655:	0f 85 92 00 00 00    	jne    8036ed <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  80365b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80365e:	8b 50 0c             	mov    0xc(%eax),%edx
  803661:	8b 45 08             	mov    0x8(%ebp),%eax
  803664:	8b 40 0c             	mov    0xc(%eax),%eax
  803667:	01 c2                	add    %eax,%edx
  803669:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80366c:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  80366f:	8b 45 08             	mov    0x8(%ebp),%eax
  803672:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803679:	8b 45 08             	mov    0x8(%ebp),%eax
  80367c:	8b 50 08             	mov    0x8(%eax),%edx
  80367f:	8b 45 08             	mov    0x8(%ebp),%eax
  803682:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803685:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803689:	75 17                	jne    8036a2 <insert_sorted_with_merge_freeList+0x234>
  80368b:	83 ec 04             	sub    $0x4,%esp
  80368e:	68 50 47 80 00       	push   $0x804750
  803693:	68 31 01 00 00       	push   $0x131
  803698:	68 73 47 80 00       	push   $0x804773
  80369d:	e8 20 d8 ff ff       	call   800ec2 <_panic>
  8036a2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ab:	89 10                	mov    %edx,(%eax)
  8036ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b0:	8b 00                	mov    (%eax),%eax
  8036b2:	85 c0                	test   %eax,%eax
  8036b4:	74 0d                	je     8036c3 <insert_sorted_with_merge_freeList+0x255>
  8036b6:	a1 48 51 80 00       	mov    0x805148,%eax
  8036bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8036be:	89 50 04             	mov    %edx,0x4(%eax)
  8036c1:	eb 08                	jmp    8036cb <insert_sorted_with_merge_freeList+0x25d>
  8036c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ce:	a3 48 51 80 00       	mov    %eax,0x805148
  8036d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036dd:	a1 54 51 80 00       	mov    0x805154,%eax
  8036e2:	40                   	inc    %eax
  8036e3:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  8036e8:	e9 da 04 00 00       	jmp    803bc7 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  8036ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036f1:	75 17                	jne    80370a <insert_sorted_with_merge_freeList+0x29c>
  8036f3:	83 ec 04             	sub    $0x4,%esp
  8036f6:	68 f8 47 80 00       	push   $0x8047f8
  8036fb:	68 37 01 00 00       	push   $0x137
  803700:	68 73 47 80 00       	push   $0x804773
  803705:	e8 b8 d7 ff ff       	call   800ec2 <_panic>
  80370a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803710:	8b 45 08             	mov    0x8(%ebp),%eax
  803713:	89 50 04             	mov    %edx,0x4(%eax)
  803716:	8b 45 08             	mov    0x8(%ebp),%eax
  803719:	8b 40 04             	mov    0x4(%eax),%eax
  80371c:	85 c0                	test   %eax,%eax
  80371e:	74 0c                	je     80372c <insert_sorted_with_merge_freeList+0x2be>
  803720:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803725:	8b 55 08             	mov    0x8(%ebp),%edx
  803728:	89 10                	mov    %edx,(%eax)
  80372a:	eb 08                	jmp    803734 <insert_sorted_with_merge_freeList+0x2c6>
  80372c:	8b 45 08             	mov    0x8(%ebp),%eax
  80372f:	a3 38 51 80 00       	mov    %eax,0x805138
  803734:	8b 45 08             	mov    0x8(%ebp),%eax
  803737:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80373c:	8b 45 08             	mov    0x8(%ebp),%eax
  80373f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803745:	a1 44 51 80 00       	mov    0x805144,%eax
  80374a:	40                   	inc    %eax
  80374b:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803750:	e9 72 04 00 00       	jmp    803bc7 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803755:	a1 38 51 80 00       	mov    0x805138,%eax
  80375a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80375d:	e9 35 04 00 00       	jmp    803b97 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  803762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803765:	8b 00                	mov    (%eax),%eax
  803767:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  80376a:	8b 45 08             	mov    0x8(%ebp),%eax
  80376d:	8b 50 08             	mov    0x8(%eax),%edx
  803770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803773:	8b 40 08             	mov    0x8(%eax),%eax
  803776:	39 c2                	cmp    %eax,%edx
  803778:	0f 86 11 04 00 00    	jbe    803b8f <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  80377e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803781:	8b 50 08             	mov    0x8(%eax),%edx
  803784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803787:	8b 40 0c             	mov    0xc(%eax),%eax
  80378a:	01 c2                	add    %eax,%edx
  80378c:	8b 45 08             	mov    0x8(%ebp),%eax
  80378f:	8b 40 08             	mov    0x8(%eax),%eax
  803792:	39 c2                	cmp    %eax,%edx
  803794:	0f 83 8b 00 00 00    	jae    803825 <insert_sorted_with_merge_freeList+0x3b7>
  80379a:	8b 45 08             	mov    0x8(%ebp),%eax
  80379d:	8b 50 08             	mov    0x8(%eax),%edx
  8037a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8037a6:	01 c2                	add    %eax,%edx
  8037a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ab:	8b 40 08             	mov    0x8(%eax),%eax
  8037ae:	39 c2                	cmp    %eax,%edx
  8037b0:	73 73                	jae    803825 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  8037b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037b6:	74 06                	je     8037be <insert_sorted_with_merge_freeList+0x350>
  8037b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037bc:	75 17                	jne    8037d5 <insert_sorted_with_merge_freeList+0x367>
  8037be:	83 ec 04             	sub    $0x4,%esp
  8037c1:	68 c4 47 80 00       	push   $0x8047c4
  8037c6:	68 48 01 00 00       	push   $0x148
  8037cb:	68 73 47 80 00       	push   $0x804773
  8037d0:	e8 ed d6 ff ff       	call   800ec2 <_panic>
  8037d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d8:	8b 10                	mov    (%eax),%edx
  8037da:	8b 45 08             	mov    0x8(%ebp),%eax
  8037dd:	89 10                	mov    %edx,(%eax)
  8037df:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e2:	8b 00                	mov    (%eax),%eax
  8037e4:	85 c0                	test   %eax,%eax
  8037e6:	74 0b                	je     8037f3 <insert_sorted_with_merge_freeList+0x385>
  8037e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037eb:	8b 00                	mov    (%eax),%eax
  8037ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8037f0:	89 50 04             	mov    %edx,0x4(%eax)
  8037f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8037f9:	89 10                	mov    %edx,(%eax)
  8037fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803801:	89 50 04             	mov    %edx,0x4(%eax)
  803804:	8b 45 08             	mov    0x8(%ebp),%eax
  803807:	8b 00                	mov    (%eax),%eax
  803809:	85 c0                	test   %eax,%eax
  80380b:	75 08                	jne    803815 <insert_sorted_with_merge_freeList+0x3a7>
  80380d:	8b 45 08             	mov    0x8(%ebp),%eax
  803810:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803815:	a1 44 51 80 00       	mov    0x805144,%eax
  80381a:	40                   	inc    %eax
  80381b:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  803820:	e9 a2 03 00 00       	jmp    803bc7 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803825:	8b 45 08             	mov    0x8(%ebp),%eax
  803828:	8b 50 08             	mov    0x8(%eax),%edx
  80382b:	8b 45 08             	mov    0x8(%ebp),%eax
  80382e:	8b 40 0c             	mov    0xc(%eax),%eax
  803831:	01 c2                	add    %eax,%edx
  803833:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803836:	8b 40 08             	mov    0x8(%eax),%eax
  803839:	39 c2                	cmp    %eax,%edx
  80383b:	0f 83 ae 00 00 00    	jae    8038ef <insert_sorted_with_merge_freeList+0x481>
  803841:	8b 45 08             	mov    0x8(%ebp),%eax
  803844:	8b 50 08             	mov    0x8(%eax),%edx
  803847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384a:	8b 48 08             	mov    0x8(%eax),%ecx
  80384d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803850:	8b 40 0c             	mov    0xc(%eax),%eax
  803853:	01 c8                	add    %ecx,%eax
  803855:	39 c2                	cmp    %eax,%edx
  803857:	0f 85 92 00 00 00    	jne    8038ef <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  80385d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803860:	8b 50 0c             	mov    0xc(%eax),%edx
  803863:	8b 45 08             	mov    0x8(%ebp),%eax
  803866:	8b 40 0c             	mov    0xc(%eax),%eax
  803869:	01 c2                	add    %eax,%edx
  80386b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386e:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  803871:	8b 45 08             	mov    0x8(%ebp),%eax
  803874:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80387b:	8b 45 08             	mov    0x8(%ebp),%eax
  80387e:	8b 50 08             	mov    0x8(%eax),%edx
  803881:	8b 45 08             	mov    0x8(%ebp),%eax
  803884:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803887:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80388b:	75 17                	jne    8038a4 <insert_sorted_with_merge_freeList+0x436>
  80388d:	83 ec 04             	sub    $0x4,%esp
  803890:	68 50 47 80 00       	push   $0x804750
  803895:	68 51 01 00 00       	push   $0x151
  80389a:	68 73 47 80 00       	push   $0x804773
  80389f:	e8 1e d6 ff ff       	call   800ec2 <_panic>
  8038a4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ad:	89 10                	mov    %edx,(%eax)
  8038af:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b2:	8b 00                	mov    (%eax),%eax
  8038b4:	85 c0                	test   %eax,%eax
  8038b6:	74 0d                	je     8038c5 <insert_sorted_with_merge_freeList+0x457>
  8038b8:	a1 48 51 80 00       	mov    0x805148,%eax
  8038bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8038c0:	89 50 04             	mov    %edx,0x4(%eax)
  8038c3:	eb 08                	jmp    8038cd <insert_sorted_with_merge_freeList+0x45f>
  8038c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d0:	a3 48 51 80 00       	mov    %eax,0x805148
  8038d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038df:	a1 54 51 80 00       	mov    0x805154,%eax
  8038e4:	40                   	inc    %eax
  8038e5:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  8038ea:	e9 d8 02 00 00       	jmp    803bc7 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  8038ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f2:	8b 50 08             	mov    0x8(%eax),%edx
  8038f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8038fb:	01 c2                	add    %eax,%edx
  8038fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803900:	8b 40 08             	mov    0x8(%eax),%eax
  803903:	39 c2                	cmp    %eax,%edx
  803905:	0f 85 ba 00 00 00    	jne    8039c5 <insert_sorted_with_merge_freeList+0x557>
  80390b:	8b 45 08             	mov    0x8(%ebp),%eax
  80390e:	8b 50 08             	mov    0x8(%eax),%edx
  803911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803914:	8b 48 08             	mov    0x8(%eax),%ecx
  803917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391a:	8b 40 0c             	mov    0xc(%eax),%eax
  80391d:	01 c8                	add    %ecx,%eax
  80391f:	39 c2                	cmp    %eax,%edx
  803921:	0f 86 9e 00 00 00    	jbe    8039c5 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  803927:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80392a:	8b 50 0c             	mov    0xc(%eax),%edx
  80392d:	8b 45 08             	mov    0x8(%ebp),%eax
  803930:	8b 40 0c             	mov    0xc(%eax),%eax
  803933:	01 c2                	add    %eax,%edx
  803935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803938:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  80393b:	8b 45 08             	mov    0x8(%ebp),%eax
  80393e:	8b 50 08             	mov    0x8(%eax),%edx
  803941:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803944:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  803947:	8b 45 08             	mov    0x8(%ebp),%eax
  80394a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803951:	8b 45 08             	mov    0x8(%ebp),%eax
  803954:	8b 50 08             	mov    0x8(%eax),%edx
  803957:	8b 45 08             	mov    0x8(%ebp),%eax
  80395a:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80395d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803961:	75 17                	jne    80397a <insert_sorted_with_merge_freeList+0x50c>
  803963:	83 ec 04             	sub    $0x4,%esp
  803966:	68 50 47 80 00       	push   $0x804750
  80396b:	68 5b 01 00 00       	push   $0x15b
  803970:	68 73 47 80 00       	push   $0x804773
  803975:	e8 48 d5 ff ff       	call   800ec2 <_panic>
  80397a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803980:	8b 45 08             	mov    0x8(%ebp),%eax
  803983:	89 10                	mov    %edx,(%eax)
  803985:	8b 45 08             	mov    0x8(%ebp),%eax
  803988:	8b 00                	mov    (%eax),%eax
  80398a:	85 c0                	test   %eax,%eax
  80398c:	74 0d                	je     80399b <insert_sorted_with_merge_freeList+0x52d>
  80398e:	a1 48 51 80 00       	mov    0x805148,%eax
  803993:	8b 55 08             	mov    0x8(%ebp),%edx
  803996:	89 50 04             	mov    %edx,0x4(%eax)
  803999:	eb 08                	jmp    8039a3 <insert_sorted_with_merge_freeList+0x535>
  80399b:	8b 45 08             	mov    0x8(%ebp),%eax
  80399e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a6:	a3 48 51 80 00       	mov    %eax,0x805148
  8039ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b5:	a1 54 51 80 00       	mov    0x805154,%eax
  8039ba:	40                   	inc    %eax
  8039bb:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8039c0:	e9 02 02 00 00       	jmp    803bc7 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8039c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c8:	8b 50 08             	mov    0x8(%eax),%edx
  8039cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8039d1:	01 c2                	add    %eax,%edx
  8039d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d6:	8b 40 08             	mov    0x8(%eax),%eax
  8039d9:	39 c2                	cmp    %eax,%edx
  8039db:	0f 85 ae 01 00 00    	jne    803b8f <insert_sorted_with_merge_freeList+0x721>
  8039e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e4:	8b 50 08             	mov    0x8(%eax),%edx
  8039e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ea:	8b 48 08             	mov    0x8(%eax),%ecx
  8039ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8039f3:	01 c8                	add    %ecx,%eax
  8039f5:	39 c2                	cmp    %eax,%edx
  8039f7:	0f 85 92 01 00 00    	jne    803b8f <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  8039fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a00:	8b 50 0c             	mov    0xc(%eax),%edx
  803a03:	8b 45 08             	mov    0x8(%ebp),%eax
  803a06:	8b 40 0c             	mov    0xc(%eax),%eax
  803a09:	01 c2                	add    %eax,%edx
  803a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0e:	8b 40 0c             	mov    0xc(%eax),%eax
  803a11:	01 c2                	add    %eax,%edx
  803a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a16:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  803a19:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803a23:	8b 45 08             	mov    0x8(%ebp),%eax
  803a26:	8b 50 08             	mov    0x8(%eax),%edx
  803a29:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2c:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803a2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3c:	8b 50 08             	mov    0x8(%eax),%edx
  803a3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a42:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  803a45:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a49:	75 17                	jne    803a62 <insert_sorted_with_merge_freeList+0x5f4>
  803a4b:	83 ec 04             	sub    $0x4,%esp
  803a4e:	68 1b 48 80 00       	push   $0x80481b
  803a53:	68 63 01 00 00       	push   $0x163
  803a58:	68 73 47 80 00       	push   $0x804773
  803a5d:	e8 60 d4 ff ff       	call   800ec2 <_panic>
  803a62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a65:	8b 00                	mov    (%eax),%eax
  803a67:	85 c0                	test   %eax,%eax
  803a69:	74 10                	je     803a7b <insert_sorted_with_merge_freeList+0x60d>
  803a6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a6e:	8b 00                	mov    (%eax),%eax
  803a70:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a73:	8b 52 04             	mov    0x4(%edx),%edx
  803a76:	89 50 04             	mov    %edx,0x4(%eax)
  803a79:	eb 0b                	jmp    803a86 <insert_sorted_with_merge_freeList+0x618>
  803a7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a7e:	8b 40 04             	mov    0x4(%eax),%eax
  803a81:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a89:	8b 40 04             	mov    0x4(%eax),%eax
  803a8c:	85 c0                	test   %eax,%eax
  803a8e:	74 0f                	je     803a9f <insert_sorted_with_merge_freeList+0x631>
  803a90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a93:	8b 40 04             	mov    0x4(%eax),%eax
  803a96:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a99:	8b 12                	mov    (%edx),%edx
  803a9b:	89 10                	mov    %edx,(%eax)
  803a9d:	eb 0a                	jmp    803aa9 <insert_sorted_with_merge_freeList+0x63b>
  803a9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa2:	8b 00                	mov    (%eax),%eax
  803aa4:	a3 38 51 80 00       	mov    %eax,0x805138
  803aa9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ab2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803abc:	a1 44 51 80 00       	mov    0x805144,%eax
  803ac1:	48                   	dec    %eax
  803ac2:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  803ac7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803acb:	75 17                	jne    803ae4 <insert_sorted_with_merge_freeList+0x676>
  803acd:	83 ec 04             	sub    $0x4,%esp
  803ad0:	68 50 47 80 00       	push   $0x804750
  803ad5:	68 64 01 00 00       	push   $0x164
  803ada:	68 73 47 80 00       	push   $0x804773
  803adf:	e8 de d3 ff ff       	call   800ec2 <_panic>
  803ae4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803aea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aed:	89 10                	mov    %edx,(%eax)
  803aef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803af2:	8b 00                	mov    (%eax),%eax
  803af4:	85 c0                	test   %eax,%eax
  803af6:	74 0d                	je     803b05 <insert_sorted_with_merge_freeList+0x697>
  803af8:	a1 48 51 80 00       	mov    0x805148,%eax
  803afd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b00:	89 50 04             	mov    %edx,0x4(%eax)
  803b03:	eb 08                	jmp    803b0d <insert_sorted_with_merge_freeList+0x69f>
  803b05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b08:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b10:	a3 48 51 80 00       	mov    %eax,0x805148
  803b15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b1f:	a1 54 51 80 00       	mov    0x805154,%eax
  803b24:	40                   	inc    %eax
  803b25:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803b2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b2e:	75 17                	jne    803b47 <insert_sorted_with_merge_freeList+0x6d9>
  803b30:	83 ec 04             	sub    $0x4,%esp
  803b33:	68 50 47 80 00       	push   $0x804750
  803b38:	68 65 01 00 00       	push   $0x165
  803b3d:	68 73 47 80 00       	push   $0x804773
  803b42:	e8 7b d3 ff ff       	call   800ec2 <_panic>
  803b47:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b50:	89 10                	mov    %edx,(%eax)
  803b52:	8b 45 08             	mov    0x8(%ebp),%eax
  803b55:	8b 00                	mov    (%eax),%eax
  803b57:	85 c0                	test   %eax,%eax
  803b59:	74 0d                	je     803b68 <insert_sorted_with_merge_freeList+0x6fa>
  803b5b:	a1 48 51 80 00       	mov    0x805148,%eax
  803b60:	8b 55 08             	mov    0x8(%ebp),%edx
  803b63:	89 50 04             	mov    %edx,0x4(%eax)
  803b66:	eb 08                	jmp    803b70 <insert_sorted_with_merge_freeList+0x702>
  803b68:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b70:	8b 45 08             	mov    0x8(%ebp),%eax
  803b73:	a3 48 51 80 00       	mov    %eax,0x805148
  803b78:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b82:	a1 54 51 80 00       	mov    0x805154,%eax
  803b87:	40                   	inc    %eax
  803b88:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803b8d:	eb 38                	jmp    803bc7 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803b8f:	a1 40 51 80 00       	mov    0x805140,%eax
  803b94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b9b:	74 07                	je     803ba4 <insert_sorted_with_merge_freeList+0x736>
  803b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba0:	8b 00                	mov    (%eax),%eax
  803ba2:	eb 05                	jmp    803ba9 <insert_sorted_with_merge_freeList+0x73b>
  803ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  803ba9:	a3 40 51 80 00       	mov    %eax,0x805140
  803bae:	a1 40 51 80 00       	mov    0x805140,%eax
  803bb3:	85 c0                	test   %eax,%eax
  803bb5:	0f 85 a7 fb ff ff    	jne    803762 <insert_sorted_with_merge_freeList+0x2f4>
  803bbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bbf:	0f 85 9d fb ff ff    	jne    803762 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  803bc5:	eb 00                	jmp    803bc7 <insert_sorted_with_merge_freeList+0x759>
  803bc7:	90                   	nop
  803bc8:	c9                   	leave  
  803bc9:	c3                   	ret    
  803bca:	66 90                	xchg   %ax,%ax

00803bcc <__udivdi3>:
  803bcc:	55                   	push   %ebp
  803bcd:	57                   	push   %edi
  803bce:	56                   	push   %esi
  803bcf:	53                   	push   %ebx
  803bd0:	83 ec 1c             	sub    $0x1c,%esp
  803bd3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803bd7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803bdb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bdf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803be3:	89 ca                	mov    %ecx,%edx
  803be5:	89 f8                	mov    %edi,%eax
  803be7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803beb:	85 f6                	test   %esi,%esi
  803bed:	75 2d                	jne    803c1c <__udivdi3+0x50>
  803bef:	39 cf                	cmp    %ecx,%edi
  803bf1:	77 65                	ja     803c58 <__udivdi3+0x8c>
  803bf3:	89 fd                	mov    %edi,%ebp
  803bf5:	85 ff                	test   %edi,%edi
  803bf7:	75 0b                	jne    803c04 <__udivdi3+0x38>
  803bf9:	b8 01 00 00 00       	mov    $0x1,%eax
  803bfe:	31 d2                	xor    %edx,%edx
  803c00:	f7 f7                	div    %edi
  803c02:	89 c5                	mov    %eax,%ebp
  803c04:	31 d2                	xor    %edx,%edx
  803c06:	89 c8                	mov    %ecx,%eax
  803c08:	f7 f5                	div    %ebp
  803c0a:	89 c1                	mov    %eax,%ecx
  803c0c:	89 d8                	mov    %ebx,%eax
  803c0e:	f7 f5                	div    %ebp
  803c10:	89 cf                	mov    %ecx,%edi
  803c12:	89 fa                	mov    %edi,%edx
  803c14:	83 c4 1c             	add    $0x1c,%esp
  803c17:	5b                   	pop    %ebx
  803c18:	5e                   	pop    %esi
  803c19:	5f                   	pop    %edi
  803c1a:	5d                   	pop    %ebp
  803c1b:	c3                   	ret    
  803c1c:	39 ce                	cmp    %ecx,%esi
  803c1e:	77 28                	ja     803c48 <__udivdi3+0x7c>
  803c20:	0f bd fe             	bsr    %esi,%edi
  803c23:	83 f7 1f             	xor    $0x1f,%edi
  803c26:	75 40                	jne    803c68 <__udivdi3+0x9c>
  803c28:	39 ce                	cmp    %ecx,%esi
  803c2a:	72 0a                	jb     803c36 <__udivdi3+0x6a>
  803c2c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c30:	0f 87 9e 00 00 00    	ja     803cd4 <__udivdi3+0x108>
  803c36:	b8 01 00 00 00       	mov    $0x1,%eax
  803c3b:	89 fa                	mov    %edi,%edx
  803c3d:	83 c4 1c             	add    $0x1c,%esp
  803c40:	5b                   	pop    %ebx
  803c41:	5e                   	pop    %esi
  803c42:	5f                   	pop    %edi
  803c43:	5d                   	pop    %ebp
  803c44:	c3                   	ret    
  803c45:	8d 76 00             	lea    0x0(%esi),%esi
  803c48:	31 ff                	xor    %edi,%edi
  803c4a:	31 c0                	xor    %eax,%eax
  803c4c:	89 fa                	mov    %edi,%edx
  803c4e:	83 c4 1c             	add    $0x1c,%esp
  803c51:	5b                   	pop    %ebx
  803c52:	5e                   	pop    %esi
  803c53:	5f                   	pop    %edi
  803c54:	5d                   	pop    %ebp
  803c55:	c3                   	ret    
  803c56:	66 90                	xchg   %ax,%ax
  803c58:	89 d8                	mov    %ebx,%eax
  803c5a:	f7 f7                	div    %edi
  803c5c:	31 ff                	xor    %edi,%edi
  803c5e:	89 fa                	mov    %edi,%edx
  803c60:	83 c4 1c             	add    $0x1c,%esp
  803c63:	5b                   	pop    %ebx
  803c64:	5e                   	pop    %esi
  803c65:	5f                   	pop    %edi
  803c66:	5d                   	pop    %ebp
  803c67:	c3                   	ret    
  803c68:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c6d:	89 eb                	mov    %ebp,%ebx
  803c6f:	29 fb                	sub    %edi,%ebx
  803c71:	89 f9                	mov    %edi,%ecx
  803c73:	d3 e6                	shl    %cl,%esi
  803c75:	89 c5                	mov    %eax,%ebp
  803c77:	88 d9                	mov    %bl,%cl
  803c79:	d3 ed                	shr    %cl,%ebp
  803c7b:	89 e9                	mov    %ebp,%ecx
  803c7d:	09 f1                	or     %esi,%ecx
  803c7f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c83:	89 f9                	mov    %edi,%ecx
  803c85:	d3 e0                	shl    %cl,%eax
  803c87:	89 c5                	mov    %eax,%ebp
  803c89:	89 d6                	mov    %edx,%esi
  803c8b:	88 d9                	mov    %bl,%cl
  803c8d:	d3 ee                	shr    %cl,%esi
  803c8f:	89 f9                	mov    %edi,%ecx
  803c91:	d3 e2                	shl    %cl,%edx
  803c93:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c97:	88 d9                	mov    %bl,%cl
  803c99:	d3 e8                	shr    %cl,%eax
  803c9b:	09 c2                	or     %eax,%edx
  803c9d:	89 d0                	mov    %edx,%eax
  803c9f:	89 f2                	mov    %esi,%edx
  803ca1:	f7 74 24 0c          	divl   0xc(%esp)
  803ca5:	89 d6                	mov    %edx,%esi
  803ca7:	89 c3                	mov    %eax,%ebx
  803ca9:	f7 e5                	mul    %ebp
  803cab:	39 d6                	cmp    %edx,%esi
  803cad:	72 19                	jb     803cc8 <__udivdi3+0xfc>
  803caf:	74 0b                	je     803cbc <__udivdi3+0xf0>
  803cb1:	89 d8                	mov    %ebx,%eax
  803cb3:	31 ff                	xor    %edi,%edi
  803cb5:	e9 58 ff ff ff       	jmp    803c12 <__udivdi3+0x46>
  803cba:	66 90                	xchg   %ax,%ax
  803cbc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803cc0:	89 f9                	mov    %edi,%ecx
  803cc2:	d3 e2                	shl    %cl,%edx
  803cc4:	39 c2                	cmp    %eax,%edx
  803cc6:	73 e9                	jae    803cb1 <__udivdi3+0xe5>
  803cc8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ccb:	31 ff                	xor    %edi,%edi
  803ccd:	e9 40 ff ff ff       	jmp    803c12 <__udivdi3+0x46>
  803cd2:	66 90                	xchg   %ax,%ax
  803cd4:	31 c0                	xor    %eax,%eax
  803cd6:	e9 37 ff ff ff       	jmp    803c12 <__udivdi3+0x46>
  803cdb:	90                   	nop

00803cdc <__umoddi3>:
  803cdc:	55                   	push   %ebp
  803cdd:	57                   	push   %edi
  803cde:	56                   	push   %esi
  803cdf:	53                   	push   %ebx
  803ce0:	83 ec 1c             	sub    $0x1c,%esp
  803ce3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ce7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ceb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cf3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cf7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cfb:	89 f3                	mov    %esi,%ebx
  803cfd:	89 fa                	mov    %edi,%edx
  803cff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d03:	89 34 24             	mov    %esi,(%esp)
  803d06:	85 c0                	test   %eax,%eax
  803d08:	75 1a                	jne    803d24 <__umoddi3+0x48>
  803d0a:	39 f7                	cmp    %esi,%edi
  803d0c:	0f 86 a2 00 00 00    	jbe    803db4 <__umoddi3+0xd8>
  803d12:	89 c8                	mov    %ecx,%eax
  803d14:	89 f2                	mov    %esi,%edx
  803d16:	f7 f7                	div    %edi
  803d18:	89 d0                	mov    %edx,%eax
  803d1a:	31 d2                	xor    %edx,%edx
  803d1c:	83 c4 1c             	add    $0x1c,%esp
  803d1f:	5b                   	pop    %ebx
  803d20:	5e                   	pop    %esi
  803d21:	5f                   	pop    %edi
  803d22:	5d                   	pop    %ebp
  803d23:	c3                   	ret    
  803d24:	39 f0                	cmp    %esi,%eax
  803d26:	0f 87 ac 00 00 00    	ja     803dd8 <__umoddi3+0xfc>
  803d2c:	0f bd e8             	bsr    %eax,%ebp
  803d2f:	83 f5 1f             	xor    $0x1f,%ebp
  803d32:	0f 84 ac 00 00 00    	je     803de4 <__umoddi3+0x108>
  803d38:	bf 20 00 00 00       	mov    $0x20,%edi
  803d3d:	29 ef                	sub    %ebp,%edi
  803d3f:	89 fe                	mov    %edi,%esi
  803d41:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d45:	89 e9                	mov    %ebp,%ecx
  803d47:	d3 e0                	shl    %cl,%eax
  803d49:	89 d7                	mov    %edx,%edi
  803d4b:	89 f1                	mov    %esi,%ecx
  803d4d:	d3 ef                	shr    %cl,%edi
  803d4f:	09 c7                	or     %eax,%edi
  803d51:	89 e9                	mov    %ebp,%ecx
  803d53:	d3 e2                	shl    %cl,%edx
  803d55:	89 14 24             	mov    %edx,(%esp)
  803d58:	89 d8                	mov    %ebx,%eax
  803d5a:	d3 e0                	shl    %cl,%eax
  803d5c:	89 c2                	mov    %eax,%edx
  803d5e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d62:	d3 e0                	shl    %cl,%eax
  803d64:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d68:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d6c:	89 f1                	mov    %esi,%ecx
  803d6e:	d3 e8                	shr    %cl,%eax
  803d70:	09 d0                	or     %edx,%eax
  803d72:	d3 eb                	shr    %cl,%ebx
  803d74:	89 da                	mov    %ebx,%edx
  803d76:	f7 f7                	div    %edi
  803d78:	89 d3                	mov    %edx,%ebx
  803d7a:	f7 24 24             	mull   (%esp)
  803d7d:	89 c6                	mov    %eax,%esi
  803d7f:	89 d1                	mov    %edx,%ecx
  803d81:	39 d3                	cmp    %edx,%ebx
  803d83:	0f 82 87 00 00 00    	jb     803e10 <__umoddi3+0x134>
  803d89:	0f 84 91 00 00 00    	je     803e20 <__umoddi3+0x144>
  803d8f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d93:	29 f2                	sub    %esi,%edx
  803d95:	19 cb                	sbb    %ecx,%ebx
  803d97:	89 d8                	mov    %ebx,%eax
  803d99:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d9d:	d3 e0                	shl    %cl,%eax
  803d9f:	89 e9                	mov    %ebp,%ecx
  803da1:	d3 ea                	shr    %cl,%edx
  803da3:	09 d0                	or     %edx,%eax
  803da5:	89 e9                	mov    %ebp,%ecx
  803da7:	d3 eb                	shr    %cl,%ebx
  803da9:	89 da                	mov    %ebx,%edx
  803dab:	83 c4 1c             	add    $0x1c,%esp
  803dae:	5b                   	pop    %ebx
  803daf:	5e                   	pop    %esi
  803db0:	5f                   	pop    %edi
  803db1:	5d                   	pop    %ebp
  803db2:	c3                   	ret    
  803db3:	90                   	nop
  803db4:	89 fd                	mov    %edi,%ebp
  803db6:	85 ff                	test   %edi,%edi
  803db8:	75 0b                	jne    803dc5 <__umoddi3+0xe9>
  803dba:	b8 01 00 00 00       	mov    $0x1,%eax
  803dbf:	31 d2                	xor    %edx,%edx
  803dc1:	f7 f7                	div    %edi
  803dc3:	89 c5                	mov    %eax,%ebp
  803dc5:	89 f0                	mov    %esi,%eax
  803dc7:	31 d2                	xor    %edx,%edx
  803dc9:	f7 f5                	div    %ebp
  803dcb:	89 c8                	mov    %ecx,%eax
  803dcd:	f7 f5                	div    %ebp
  803dcf:	89 d0                	mov    %edx,%eax
  803dd1:	e9 44 ff ff ff       	jmp    803d1a <__umoddi3+0x3e>
  803dd6:	66 90                	xchg   %ax,%ax
  803dd8:	89 c8                	mov    %ecx,%eax
  803dda:	89 f2                	mov    %esi,%edx
  803ddc:	83 c4 1c             	add    $0x1c,%esp
  803ddf:	5b                   	pop    %ebx
  803de0:	5e                   	pop    %esi
  803de1:	5f                   	pop    %edi
  803de2:	5d                   	pop    %ebp
  803de3:	c3                   	ret    
  803de4:	3b 04 24             	cmp    (%esp),%eax
  803de7:	72 06                	jb     803def <__umoddi3+0x113>
  803de9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ded:	77 0f                	ja     803dfe <__umoddi3+0x122>
  803def:	89 f2                	mov    %esi,%edx
  803df1:	29 f9                	sub    %edi,%ecx
  803df3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803df7:	89 14 24             	mov    %edx,(%esp)
  803dfa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dfe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e02:	8b 14 24             	mov    (%esp),%edx
  803e05:	83 c4 1c             	add    $0x1c,%esp
  803e08:	5b                   	pop    %ebx
  803e09:	5e                   	pop    %esi
  803e0a:	5f                   	pop    %edi
  803e0b:	5d                   	pop    %ebp
  803e0c:	c3                   	ret    
  803e0d:	8d 76 00             	lea    0x0(%esi),%esi
  803e10:	2b 04 24             	sub    (%esp),%eax
  803e13:	19 fa                	sbb    %edi,%edx
  803e15:	89 d1                	mov    %edx,%ecx
  803e17:	89 c6                	mov    %eax,%esi
  803e19:	e9 71 ff ff ff       	jmp    803d8f <__umoddi3+0xb3>
  803e1e:	66 90                	xchg   %ax,%ax
  803e20:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e24:	72 ea                	jb     803e10 <__umoddi3+0x134>
  803e26:	89 d9                	mov    %ebx,%ecx
  803e28:	e9 62 ff ff ff       	jmp    803d8f <__umoddi3+0xb3>
