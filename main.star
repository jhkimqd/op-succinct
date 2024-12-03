PRIVATE_KEY = "bcdf20249abf0ed6d944c0288fad489e33f66b3960d9e6229c1cd214ed3bbe31"
ETHERSCAN_API_KEY = "QS2P4PDUN9HUAXYCYPB13RAUVJPPX7PJ7P"
VERIFIER_ADDRESS = "0xb4B46bdAA835F8E4b4d8e208B6559cD267851051"
L2OO_ADDRESS = "0x703848F4c85f18e3acd8196c8eC91eb0b7Bd0797"
OP_SUCCINCT_MOCK = "true"

def run(plan, args):

    l1_el_client = plan.get_service(
        name="el-1-geth-lighthouse"
    )
    l1_cl_client = plan.get_service(
        name="cl-1-lighthouse-geth"
    )
    l2_op_node_service = plan.get_service(
        name="op-cl-1-op-node-op-geth-op-kurtosis"
    )
    l2_op_el_service = plan.get_service(
        name="op-el-1-op-geth-op-node-op-kurtosis"
    )

    opsuccinct_proposer = plan.add_service(
        name = "op-succinct-proposer",
        config = ServiceConfig(
            image = "op-succinct-op-succinct-proposer:latest",
            ports = {
                "metrics": PortSpec(7300, application_protocol = "http"),
            },
            env_vars = {
                "L1_RPC": "http://{0}:{1}".format(
                    l1_el_client.ip_address, l1_el_client.ports["rpc"].number
                ),
                "L1_BEACON_RPC": "http://{0}:{1}".format(
                    l1_cl_client.ip_address, l1_cl_client.ports["http"].number
                ),
                "L2_RPC": "http://{0}:{1}".format(
                    l2_op_el_service.ip_address, l2_op_el_service.ports["rpc"].number
                ),
                "L2_NODE_RPC":  "http://{0}:{1}".format(
                    l2_op_node_service.ip_address, l2_op_node_service.ports["http"].number
                ),
                "PRIVATE_KEY": PRIVATE_KEY,
                "ETHERSCAN_API_KEY": ETHERSCAN_API_KEY,
                # Comes after deploying mock verifier
                "VERIFIER_ADDRESS": VERIFIER_ADDRESS,
                # Comes after deploying oracle
                "L2OO_ADDRESS": L2OO_ADDRESS,
                "OP_SUCCINCT_MOCK": OP_SUCCINCT_MOCK,
            },
        ),
    )

    opsuccinct_server = plan.add_service(
        name = "op-succinct-server",
        config = ServiceConfig(
            image = "op-succinct-op-succinct-server:latest",
            ports = {
                "http": PortSpec(3000, application_protocol = "http"),
            },
            env_vars = {
                "L1_RPC": "http://{0}:{1}".format(
                    l1_el_client.ip_address, l1_el_client.ports["rpc"].number
                ),
                "L1_BEACON_RPC": "http://{0}:{1}".format(
                    l1_cl_client.ip_address, l1_cl_client.ports["http"].number
                ),
                "L2_RPC": "http://{0}:{1}".format(
                    l2_op_el_service.ip_address, l2_op_el_service.ports["rpc"].number
                ),
                "L2_NODE_RPC":  "http://{0}:{1}".format(
                    l2_op_node_service.ip_address, l2_op_node_service.ports["http"].number
                ),
                "PRIVATE_KEY": PRIVATE_KEY,
                "ETHERSCAN_API_KEY": ETHERSCAN_API_KEY,
                # Comes after deploying mock verifier
                "VERIFIER_ADDRESS": VERIFIER_ADDRESS,
                # Comes after deploying oracle
                "L2OO_ADDRESS": L2OO_ADDRESS,
                "OP_SUCCINCT_MOCK": OP_SUCCINCT_MOCK,
            },
        ),
    )
    