/*
 * paging_helpers.c
 *
 *  Created on: Sep 30, 2022
 *      Author: HP
 */
#include "memory_manager.h"

/*[2.1] PAGE TABLE ENTRIES MANIPULATION */
inline void pt_set_page_permissions(uint32* page_directory, uint32 virtual_address, uint32 permissions_to_set, uint32 permissions_to_clear)
{
	uint32 dirIndex = PDX(virtual_address);
		uint32 pageIndex = PTX(virtual_address);
		uint32 dirctore_entry = page_directory[dirIndex];
		uint32 *ptr = NULL;
		int ch = get_page_table(page_directory, virtual_address, &ptr);
		if (ptr == NULL) {
			panic("Invalid virtual address");
		} else {
			if (permissions_to_clear == 0) {
				ptr[pageIndex] = ptr[pageIndex] | permissions_to_set;
			} else if (permissions_to_set == 0) {
				ptr[pageIndex] = ptr[pageIndex] & ~permissions_to_clear;
			} else {
				ptr[pageIndex] = ptr[pageIndex] | permissions_to_set;
				ptr[pageIndex] = ptr[pageIndex] & ~permissions_to_clear;
			}

		}
		tlb_invalidate((void *) NULL, (void *) virtual_address);
}

inline int pt_get_page_permissions(uint32* page_directory, uint32 virtual_address )
{
	uint32 *ptr = NULL ;
		get_page_table(page_directory,virtual_address,&ptr);
		if(ptr != NULL)
		{		// page entry 	+ offset -> 111111111111 12bit
			uint32 permissions = ptr[PTX(virtual_address)] & 0x00FFF ;
			return permissions ;
		}
			return -1 ;
}
inline void pt_clear_page_table_entry(uint32* page_directory, uint32 virtual_address)
{
	uint32 dirIndex = PDX(virtual_address);
	uint32 pageIndex = PTX(virtual_address);
	uint32 dirctore_entry = page_directory[dirIndex];
	uint32 *ptr = NULL;
	int ch = get_page_table(page_directory,virtual_address,&ptr);
	if(ptr == NULL)
	{
	panic("Invalid va");
	}
	else{
		ptr[pageIndex] = 0;
		}
	tlb_invalidate((void *)NULL,(void *)virtual_address);
}

/***********************************************************************************************/

/*[2.2] ADDRESS CONVERTION*/
inline int virtual_to_physical(uint32* page_directory, uint32 virtual_address)
{uint32 dirIndex = PDX(virtual_address);
	uint32 pageIndex = PTX(virtual_address);
	uint32 dirctore_entry = page_directory[dirIndex];
	uint32 *ptr = NULL;
	int ch = get_page_table(page_directory, virtual_address, &ptr);
	uint32 PhysicalAddress;
	if (ptr == NULL) {
		return -1;
	} else {
		uint32 pageEntry = ptr[pageIndex];
		uint32 numOfFramOfpage = pageEntry >> 12;
		PhysicalAddress = numOfFramOfpage * PAGE_SIZE;
		return PhysicalAddress;
	}}
/***********************************************************************************************/

/***********************************************************************************************/
/***********************************************************************************************/
/***********************************************************************************************/
/***********************************************************************************************/
/***********************************************************************************************/

///============================================================================================
/// Dealing with page directory entry flags

inline uint32 pd_is_table_used(uint32* page_directory, uint32 virtual_address)
{
	return ( (page_directory[PDX(virtual_address)] & PERM_USED) == PERM_USED ? 1 : 0);
}

inline void pd_set_table_unused(uint32* page_directory, uint32 virtual_address)
{
	page_directory[PDX(virtual_address)] &= (~PERM_USED);
	tlb_invalidate((void *)NULL, (void *)virtual_address);
}

inline void pd_clear_page_dir_entry(uint32* page_directory, uint32 virtual_address)
{
	page_directory[PDX(virtual_address)] = 0 ;
	tlbflush();
}
