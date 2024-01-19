#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdlib.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define __COUNT_MAX 1000
 
int main(void)
{
	int fd;
	uint32_t i,j;
	uint32_t wdata;
	uint32_t rdata;
	void *cfg;
	char *name = "/dev/mem";
	char flag = 0x00;
	
	uint32_t Tdata[4096];
	uint16_t Adata;
	char CbyteDT[2];
	char DACbyteDT[2];
	char AbyteDT[2];
	char TbyteDT[4];
	char	labcomand = 0xff;
	uint32_t		datacnt;
	uint32_t DACdata;
	uint16_t SCAdata;
	
	char comand;
	char roop=1;
	FILE *fp;
	
	fp = fopen("osilo.csv","w");
	
	
	/////////////////////////////////////////////////////////
	/* gpio処理 */
	if((fd = open(name, O_RDWR)) < 0) {
    perror("open");
    return 1;
	}
	/* map the memory */
	cfg = mmap(NULL, sysconf(_SC_PAGESIZE), 
             PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x42000000);
	//////////////////////////////////////////////////////////
	
	
	
	while(roop){
		printf("comand?\n");
		scanf("%d",&comand);
		switch (comand){
			case 0://reset
				*((uint32_t *)(cfg + 0)) = 0x00000001;
				*((uint32_t *)(cfg + 0)) = 0x00000000;
				break;
				
			case 1://read
				*((uint32_t *)(cfg + 0)) = 0x00000002;
				datacnt = *((uint16_t *)(cfg + 8));
				*((uint32_t *)(cfg + 0)) = 0x00000000;
				printf("cnt=%04x\n",datacnt);
			
				for(i=0; i<datacnt; i++){
					*((uint32_t *)(cfg + 0)) = 0x00000004;
					Adata = *((uint16_t *)(cfg + 8));
					*((uint32_t *)(cfg + 0)) = 0x00000000;
					printf("%5d,%04x\n",i,Adata);
					fprintf(fp,"%5d,%04x,%d\n",i,Adata,Adata);
					}
				break;
				
			case 2://trg
				DACdata = 0x00002300;
				*((uint32_t *)(cfg + 0)) = 0x00000020+((DACdata<<16)&0xffff0000);
				*((uint32_t *)(cfg + 0)) = 0x00000000+((DACdata<<16)&0xffff0000);
				*((uint32_t *)(cfg + 0)) = 0x00000000;
				*((uint32_t *)(cfg + 0)) = 0x00000001;
				*((uint32_t *)(cfg + 0)) = 0x00000000;
				break;
			case 3://end
				roop = 0;
				break;
		}
	}
	fclose(fp);
	return 0;
}