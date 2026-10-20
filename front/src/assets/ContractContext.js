import { Contract } from "ethers";
export class ContractContext {

    constructor(address, abi, signer) {
        this.contract = new Contract(address, abi, signer);
    }

    async supply(amount) {
        await this.contract.supply(amount)
    }
    async withdraw(amount) {
        await this.contract.withdraw(amount)
    }
    async borrow(amount) {
        await this.contract.borrow(amount)
    }
    async repay(amount) {
        await this.contract.repay(amount)
    }
    async getMarket() {
        return await this.contract.getMarket();
    }
    async getUser() {
        return await this.contract.getUser()
    }
    async depositVault(amount) {
        await this.contract.depositVault(amount)
    }
    async withdrawVault(amount) {
        await this.contract.withdrawVault(amount)
    }
    async getVault() {
        return await this.contract.getVault()
    }
} 