/*
 * chunk_operations.c
 *
 *  Created on: Oct 12, 2022
 *      Author: HP
 */

#include <kern/trap/fault_handler.h>
#include <kern/disk/pagefile_manager.h>
#include "kheap.h"
#include "memory_manager.h"

/******************************/
/*[1] RAM CHUNKS MANIPULATION */
/******************************/

//===============================
// 1) CUT-PASTE PAGES IN RAM:
//===============================
//This function should cut-paste the given number of pages from source_va to dest_va
//if the page table at any destination page in the range is not exist, it should create it
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int cut_paste_pages(uint32* page_directory, uint32 source_va, uint32 dest_va,
		uint32 num_of_pages) {
	source_va = ROUNDDOWN(source_va, PAGE_SIZE);
	dest_va = ROUNDDOWN(dest_va, PAGE_SIZE);
	uint32 dest_vacopy = ROUNDDOWN(dest_va, PAGE_SIZE);
	int found = 0;
	for (int i = 0; i < num_of_pages; i++) {
		uint32 *ptr_pages = NULL, *ptr_tables = NULL;
		struct FrameInfo *result_return_from_get_frame_info = get_frame_info(
				page_directory, dest_vacopy, &ptr_pages);
		if (result_return_from_get_frame_info != NULL) {
			found = 1;
			return -1;
		}
		dest_vacopy += PAGE_SIZE;
	}
	if (!found) {
		for (int i = 0; i < num_of_pages; i++) {
			uint32 *ptr_pages = NULL, *ptr_tables = NULL;
			int result_return_from_get_page_table = get_page_table(
					page_directory, dest_va, &ptr_tables);
			struct FrameInfo *result_return_from_get_frame_info =
					get_frame_info(page_directory, dest_va, &ptr_pages);
			if (result_return_from_get_frame_info != NULL) {
				return -1;
			} else {
				if (result_return_from_get_page_table == TABLE_NOT_EXIST) {
					ptr_pages = create_page_table(page_directory, dest_va);
				}
				struct FrameInfo *result_return_from_get_frame_info_source =
						get_frame_info(page_directory, source_va, &ptr_pages);
				uint32 perms = pt_get_page_permissions(page_directory,
						source_va);
				int re = map_frame(page_directory,
						result_return_from_get_frame_info_source, dest_va,
						perms);
				unmap_frame(page_directory, source_va);
				dest_va += PAGE_SIZE;
				source_va += PAGE_SIZE;
			}
		}
	}
	return 0;
}

//===============================
// 2) COPY-PASTE RANGE IN RAM:
//===============================
//This function should copy-paste the given size from source_va to dest_va
//if the page table at any destination page in the range is not exist, it should create it
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int copy_paste_chunk(uint32* page_directory, uint32 source_va, uint32 dest_va,
		uint32 size) {
	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] copy_paste_chunk
	// Write your code here, remove the panic and write your code
	uint32 s = source_va;
	uint32 d = dest_va;
	uint32 st = source_va;
	uint32 end = source_va + size;
	uint32 descopy = dest_va;
	uint32 copDest = dest_va;
	for (int i = descopy; i < dest_va + size; i++) {
		uint32 *ptr_pages = NULL, *ptr_tables = NULL;
		uint32 *ptr = NULL;
		int ch = get_page_table(page_directory, copDest, &ptr);
		if (ch == TABLE_NOT_EXIST) {
			create_page_table(page_directory, i);
		}
		struct FrameInfo *result_return_from_get_frame_info = get_frame_info(
				page_directory, copDest, &ptr_pages);
		if (result_return_from_get_frame_info== NULL)
		{
			//allocate_frame(result_return_from_get_frame_info);
			int x= pt_get_page_permissions(page_directory,s++);
			map_frame(page_directory,result_return_from_get_frame_info,i,PERM_WRITEABLE | x );
		}
		if (result_return_from_get_frame_info != NULL) {

			if ((ptr[PTX(copDest)] & PERM_WRITEABLE)!=PERM_WRITEABLE) {
				return -1;
			}
		}
		copDest ++;
	}

	for (int i = st; i < end; i += PAGE_SIZE) {

		uint32 *ptr_pages = NULL, *ptr_tables = NULL;
		int result_return_from_get_page_table = get_page_table(page_directory,
				d, &ptr_tables);
		struct FrameInfo *result_return_from_get_frame_info = get_frame_info(
				page_directory, d, &ptr_pages);
		if (result_return_from_get_page_table == TABLE_NOT_EXIST) {
			ptr_pages = create_page_table(page_directory, d);
		}
		if (result_return_from_get_frame_info != NULL) {
			char *ptr_source = (char*) s;
			char *ptr_dest = (char*) d;
			//			for (int t = source_va; t < source_va + PAGE_SIZE; t += 1) {
			//				*ptr_dest = *ptr_source;
			//				ptr_dest += 1;
			//				ptr_source += 1;
			//			}
			while (1) {
				if (ptr_source > (char*) (source_va + PAGE_SIZE)) {
					break;
				}
				*ptr_dest = *ptr_source;
				ptr_dest += 1;
				ptr_source += 1;
			}
			//			*ptr_dest = *ptr_source;
		} else {
			struct FrameInfo *frInfo;
			int r = allocate_frame(&frInfo);
			uint32 p = pt_get_page_permissions(page_directory, s) & PERM_USER;
			int a = map_frame(page_directory, frInfo, d,
			PERM_WRITEABLE | p);
			char *ptr_source = (char*) s;
			char *ptr_dest = (char*) d;
			for (int t = source_va; t < source_va + PAGE_SIZE; t += 1) {
				*ptr_dest = *ptr_source;
				ptr_dest += 1;
				ptr_source += 1;
			}
		}
		d += PAGE_SIZE;
		s += PAGE_SIZE;

	}
	return 0;
}

//===============================
// 3) SHARE RANGE IN RAM:
//===============================
//This function should share the given size from dest_va with the source_va
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int share_chunk(uint32* page_directory, uint32 source_va, uint32 dest_va,
		uint32 size, uint32 perms) {
	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] share_chunk
	// Write your code here, remove the panic and write your code
	uint32 st = ROUNDDOWN(source_va, PAGE_SIZE);
	uint32 end = ROUNDUP(source_va + size, PAGE_SIZE);

	for (int i = st; i < end; i += PAGE_SIZE) {
		uint32 *ptr_pages = NULL, *ptr_tables = NULL;
		int result_return_from_get_page_table = get_page_table(page_directory,
				dest_va, &ptr_tables);
		struct FrameInfo *result_return_from_get_frame_info = get_frame_info(
				page_directory, dest_va, &ptr_pages);
		if (result_return_from_get_frame_info != NULL) {
			return -1;
		} else {
			if (result_return_from_get_page_table == TABLE_NOT_EXIST) {
				ptr_pages = create_page_table(page_directory, dest_va);
			}
			struct FrameInfo *result_return_from_get_frame_info_source =
					get_frame_info(page_directory, source_va, &ptr_pages);
			int re = map_frame(page_directory,
					result_return_from_get_frame_info_source, dest_va, perms);
			dest_va += PAGE_SIZE;
			source_va += PAGE_SIZE;
		}
	}
	return 0;
}

//===============================
// 4) ALLOCATE CHUNK IN RAM:
//===============================
//This function should allocate in RAM the given range [va, va+size)
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int allocate_chunk(uint32* page_directory, uint32 va, uint32 size, uint32 perms) {
	for (int va1 = ROUNDDOWN(va, PAGE_SIZE);
			va1 < ROUNDUP(va + size, PAGE_SIZE); va1 += PAGE_SIZE)
			{
		uint32 *ptr_pages = NULL, *ptr_tables = NULL;
		int res = get_page_table(page_directory, va1, &ptr_tables);
		struct FrameInfo *ptrframeinfo = get_frame_info(page_directory, va1,
				&ptr_pages);

		if ((ptrframeinfo == 0) || (ptrframeinfo == NULL)) {
			if (res == TABLE_NOT_EXIST) {
				ptr_pages = create_page_table(page_directory, va1);
			}

			int rest = allocate_frame(&ptrframeinfo);
			rest = map_frame(page_directory, ptrframeinfo, va1, perms);
			ptrframeinfo->va = va1;

		} else {
			return -1;
		}
	}
	return 0;

}
/*BONUS*/
//=====================================
// 5) CALCULATE ALLOCATED SPACE IN RAM:
//=====================================
void calculate_allocated_space(uint32* page_directory, uint32 sva, uint32 eva,
		uint32 *num_tables, uint32 *num_pages) {
	//TODO: [PROJECT MS2 - BONUS] [CHUNK OPERATIONS] calculate_allocated_space
	// Write your code here, remove the panic and write your code
	panic("calculate_allocated_space() is not implemented yet...!!");
}

/*BONUS*/
//=====================================
// 6) CALCULATE REQUIRED FRAMES IN RAM:
//=====================================
// calculate_required_frames:
// calculates the new allocation size required for given address+size,
// we are not interested in knowing if pages or tables actually exist in memory or the page file,
// we are interested in knowing whether they are allocated or not.
uint32 calculate_required_frames(uint32* page_directory, uint32 sva,
		uint32 size) {
	//TODO: [PROJECT MS2 - BONUS] [CHUNK OPERATIONS] calculate_required_frames
	// Write your code here, remove the panic and write your code
	panic("calculate_required_frames() is not implemented yet...!!");
}

//=================================================================================//
//===========================END RAM CHUNKS MANIPULATION ==========================//
//=================================================================================//

/*******************************/
/*[2] USER CHUNKS MANIPULATION */
/*******************************/

//======================================================
/// functions used for USER HEAP (malloc, free, ...)
//======================================================
//=====================================
// 1) ALLOCATE USER MEMORY:
//=====================================
void allocate_user_mem(struct Env* e, uint32 virtual_address, uint32 size) {
	// Write your code here, remove the panic and write your code
	panic("allocate_user_mem() is not implemented yet...!!");
}

//=====================================
// 2) FREE USER MEMORY:
//=====================================
void free_user_mem(struct Env* e, uint32 virtual_address, uint32 size) {
	//TODO: [PROJECT MS3] [USER HEAP - KERNEL SIDE] free_user_mem
	// Write your code here, remove the panic and write your code
	virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
	uint32 sizeWithRoundUp = ROUNDUP(size, PAGE_SIZE);
	uint32 endAddress = virtual_address + size;
	struct FrameInfo *pointerForFrameInfo;
	uint32 *ptrPageTable = NULL;
	int sizeOfWorkingSet = e->page_WS_max_size;
	uint32 virAdress;

	uint32 *pointerForPageTable;
	//This function should:
	for (uint32 startAddress = virtual_address; startAddress < endAddress;
			startAddress = startAddress + PAGE_SIZE) {

		//1. Free ALL pages of the given range from the Page File
		pf_remove_env_page(e, startAddress);

		//2. Free ONLY pages that are resident in the working set from the memory
		int indexOfWorkingSet = 0;
		while (indexOfWorkingSet < sizeOfWorkingSet) {
			virAdress = env_page_ws_get_virtual_address(e, indexOfWorkingSet);
			if (virtual_address <= virAdress && virAdress < endAddress) {
				unmap_frame(e->env_page_directory, virAdress);
				env_page_ws_clear_entry(e, indexOfWorkingSet);
				e->page_last_WS_index = indexOfWorkingSet;
			}
			indexOfWorkingSet = indexOfWorkingSet + 1;

		}

		//3. Removes ONLY the empty page tables (i.e. not used) (no pages are mapped in the table)
		pointerForPageTable = NULL;
		int tableEmpty = 1;
		int return_from_get_page_table = get_page_table(e->env_page_directory,
				startAddress, &pointerForPageTable);
		if (pointerForPageTable != NULL) {
			int index_of_page = 0;
			while (index_of_page < 1024) {
				if (pointerForPageTable[index_of_page] & PERM_PRESENT) {
					tableEmpty = 0;
					break;
				}
				index_of_page = index_of_page + 1;
			}
			if (tableEmpty == 1) {
				kfree((void*) pointerForPageTable);

				//				OR
				//				pointerForFrameInfo = get_frame_info(e->env_page_directory,startAddress,&ptrPageTable);
				//				if(pointerForFrameInfo!=NULL){
				//				pointerForFrameInfo->references = 0;
				//				free_frame(pointerForFrameInfo);
				//				e->env_page_directory[PDX(startAddress)]=0;
				//				}
				//				OR
				//				unmap_frame(e->env_page_directory,startAddress);

				pd_clear_page_dir_entry(e->env_page_directory,
						(uint32) startAddress);
			}
		}
	}
	tlb_invalidate(e->env_page_directory, (void *) endAddress);

	//This function should:
	//1. Free ALL pages of the given range from the Page File
	//2. Free ONLY pages that are resident in the working set from the memory
	//3. Removes ONLY the empty page tables (i.e. not used) (no pages are mapped in the table)
}

//=====================================
// 2) FREE USER MEMORY (BUFFERING):
//=====================================
void __free_user_mem_with_buffering(struct Env* e, uint32 virtual_address,
		uint32 size) {
	// your code is here, remove the panic and write your code
	panic("__free_user_mem_with_buffering() is not implemented yet...!!");

	//This function should:
	//1. Free ALL pages of the given range from the Page File
	//2. Free ONLY pages that are resident in the working set from the memory
	//3. Free any BUFFERED pages in the given range
	//4. Removes ONLY the empty page tables (i.e. not used) (no pages are mapped in the table)
}

//=====================================
// 3) MOVE USER MEMORY:
//=====================================
void move_user_mem(struct Env* e, uint32 src_virtual_address,
		uint32 dst_virtual_address, uint32 size) {
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - KERNEL SIDE] move_user_mem
	//your code is here, remove the panic and write your code
	panic("move_user_mem() is not implemented yet...!!");

	// This function should move all pages from "src_virtual_address" to "dst_virtual_address"
	// with the given size
	// After finished, the src_virtual_address must no longer be accessed/exist in either page file
	// or main memory

	/**/
}

//=================================================================================//
//========================== END USER CHUNKS MANIPULATION =========================//
//=================================================================================//

