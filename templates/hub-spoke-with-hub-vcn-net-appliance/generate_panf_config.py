"""Generate Palo Alto bootstrap XML for OCI deployments."""

from __future__ import annotations

import argparse
import ipaddress
import sys
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Sequence, TextIO


TEMPLATE_XML = """<?xml version="1.0"?>
<config>
  <devices>
    <entry name="localhost.localdomain">
      <network>
        <interface>
          <ethernet>
            <entry name="ethernet1/1">
              <layer3>
                <ndp-proxy>
                  <enabled>no</enabled>
                </ndp-proxy>
                <sdwan-link-settings>
                  <upstream-nat>
                    <enable>no</enable>
                    <static-ip/>
                  </upstream-nat>
                  <enable>no</enable>
                  <ipv6-enable>no</ipv6-enable>
                </sdwan-link-settings>
                <lldp>
                  <enable>no</enable>
                </lldp>
                <ip>
                  <entry name="{UNTRUST_IP}"/>
                </ip>
                <interface-management-profile>allow-all-basic-profile</interface-management-profile>
              </layer3>
              <comment>Untrust</comment>
            </entry>
            <entry name="ethernet1/2">
              <layer3>
                <ndp-proxy>
                  <enabled>no</enabled>
                </ndp-proxy>
                <sdwan-link-settings>
                  <upstream-nat>
                    <enable>no</enable>
                    <static-ip/>
                  </upstream-nat>
                  <enable>no</enable>
                  <ipv6-enable>no</ipv6-enable>
                </sdwan-link-settings>
                <ip>
                  <entry name="{TRUST_IP}"/>
                </ip>
                <lldp>
                  <enable>no</enable>
                </lldp>
                <interface-management-profile>allow-all-basic-profile</interface-management-profile>
              </layer3>
              <comment>Trust</comment>
            </entry>
          </ethernet>
        </interface>
        <profiles>
          <monitor-profile>
            <entry name="default">
              <interval>3</interval>
              <threshold>5</threshold>
              <action>wait-recover</action>
            </entry>
          </monitor-profile>
          <interface-management-profile>
            <entry name="allow-all-basic-profile">
              <permitted-ip>
                <entry name="{TRUST_SUBNET}"/>
                <entry name="{UNTRUST_SUBNET}"/>
              </permitted-ip>
              <ssh>yes</ssh>
            </entry>
          </interface-management-profile>
        </profiles>
        <ike>
          <crypto-profiles>
            <ike-crypto-profiles>
              <entry name="default">
                <encryption>
                  <member>aes-128-cbc</member>
                  <member>3des</member>
                </encryption>
                <hash>
                  <member>sha1</member>
                </hash>
                <dh-group>
                  <member>group2</member>
                </dh-group>
                <lifetime>
                  <hours>8</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-128">
                <encryption>
                  <member>aes-128-cbc</member>
                </encryption>
                <hash>
                  <member>sha256</member>
                </hash>
                <dh-group>
                  <member>group19</member>
                </dh-group>
                <lifetime>
                  <hours>8</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-256">
                <encryption>
                  <member>aes-256-cbc</member>
                </encryption>
                <hash>
                  <member>sha384</member>
                </hash>
                <dh-group>
                  <member>group20</member>
                </dh-group>
                <lifetime>
                  <hours>8</hours>
                </lifetime>
              </entry>
            </ike-crypto-profiles>
            <ipsec-crypto-profiles>
              <entry name="default">
                <esp>
                  <encryption>
                    <member>aes-128-cbc</member>
                    <member>3des</member>
                  </encryption>
                  <authentication>
                    <member>sha1</member>
                  </authentication>
                </esp>
                <dh-group>group2</dh-group>
                <lifetime>
                  <hours>1</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-128">
                <esp>
                  <encryption>
                    <member>aes-128-gcm</member>
                  </encryption>
                  <authentication>
                    <member>none</member>
                  </authentication>
                </esp>
                <dh-group>group19</dh-group>
                <lifetime>
                  <hours>1</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-256">
                <esp>
                  <encryption>
                    <member>aes-256-gcm</member>
                  </encryption>
                  <authentication>
                    <member>none</member>
                  </authentication>
                </esp>
                <dh-group>group20</dh-group>
                <lifetime>
                  <hours>1</hours>
                </lifetime>
              </entry>
            </ipsec-crypto-profiles>
            <global-protect-app-crypto-profiles>
              <entry name="default">
                <encryption>
                  <member>aes-128-cbc</member>
                </encryption>
                <authentication>
                  <member>sha1</member>
                </authentication>
              </entry>
            </global-protect-app-crypto-profiles>
          </crypto-profiles>
        </ike>
        <qos>
          <profile>
            <entry name="default">
              <class-bandwidth-type>
                <mbps>
                  <class>
                    <entry name="class1">
                      <priority>real-time</priority>
                    </entry>
                    <entry name="class2">
                      <priority>high</priority>
                    </entry>
                    <entry name="class3">
                      <priority>high</priority>
                    </entry>
                    <entry name="class4">
                      <priority>medium</priority>
                    </entry>
                    <entry name="class5">
                      <priority>medium</priority>
                    </entry>
                    <entry name="class6">
                      <priority>low</priority>
                    </entry>
                    <entry name="class7">
                      <priority>low</priority>
                    </entry>
                    <entry name="class8">
                      <priority>low</priority>
                    </entry>
                  </class>
                </mbps>
              </class-bandwidth-type>
            </entry>
          </profile>
        </qos>
        <virtual-router>
          <entry name="default">
            <protocol>
              <bgp>
                <enable>no</enable>
                <dampening-profile>
                  <entry name="default">
                    <cutoff>1.25</cutoff>
                    <reuse>0.5</reuse>
                    <max-hold-time>900</max-hold-time>
                    <decay-half-life-reachable>300</decay-half-life-reachable>
                    <decay-half-life-unreachable>900</decay-half-life-unreachable>
                    <enable>yes</enable>
                  </entry>
                </dampening-profile>
              </bgp>
            </protocol>
          </entry>
          <entry name="OCI">
            <ecmp>
              <algorithm>
                <ip-modulo/>
              </algorithm>
            </ecmp>
            <protocol>
              <bgp>
                <routing-options>
                  <graceful-restart>
                    <enable>yes</enable>
                  </graceful-restart>
                </routing-options>
                <enable>no</enable>
              </bgp>
              <rip>
                <enable>no</enable>
              </rip>
              <ospf>
                <enable>no</enable>
              </ospf>
              <ospfv3>
                <enable>no</enable>
              </ospfv3>
            </protocol>
            <interface>
              <member>ethernet1/1</member>
              <member>ethernet1/2</member>
            </interface>
            <routing-table>
              <ip>
                <static-route>
                  <entry name="RFC_192">
                    <nexthop>
                      <ip-address>{TRUST_ROUTER_IP}</ip-address>
                    </nexthop>
                    <bfd>
                      <profile>None</profile>
                    </bfd>
                    <interface>ethernet1/2</interface>
                    <metric>10</metric>
                    <destination>192.168.0.0/24</destination>
                    <route-table>
                      <unicast/>
                    </route-table>
                  </entry>
                  <entry name="External-LB">
                    <nexthop>
                      <ip-address>{UNTRUST_ROUTER_IP}</ip-address>
                    </nexthop>
                    <bfd>
                      <profile>None</profile>
                    </bfd>
                    <interface>ethernet1/1</interface>
                    <metric>10</metric>
                    <destination>{EXTERNAL_LB_SUBNET}</destination>
                    <route-table>
                      <unicast/>
                    </route-table>
                  </entry>
                  <entry name="Default">
                    <nexthop>
                      <ip-address>{UNTRUST_ROUTER_IP}</ip-address>
                    </nexthop>
                    <bfd>
                      <profile>None</profile>
                    </bfd>
                    <interface>ethernet1/1</interface>
                    <metric>10</metric>
                    <destination>0.0.0.0/0</destination>
                    <route-table>
                      <unicast/>
                    </route-table>
                  </entry>
                  <entry name="RFC_10">
                    <nexthop>
                      <ip-address>{TRUST_ROUTER_IP}</ip-address>
                    </nexthop>
                    <bfd>
                      <profile>None</profile>
                    </bfd>
                    <interface>ethernet1/2</interface>
                    <metric>10</metric>
                    <destination>10.0.0.0/8</destination>
                    <route-table>
                      <unicast/>
                    </route-table>
                  </entry>
                  <entry name="RFC_172">
                    <nexthop>
                      <ip-address>{TRUST_ROUTER_IP}</ip-address>
                    </nexthop>
                    <bfd>
                      <profile>None</profile>
                    </bfd>
                    <interface>ethernet1/2</interface>
                    <metric>10</metric>
                    <destination>172.16.0.0/12</destination>
                    <route-table>
                      <unicast/>
                    </route-table>
                  </entry>
                </static-route>
              </ip>
            </routing-table>
          </entry>
        </virtual-router>
      </network>
      <deviceconfig>
        <system>
          <type>
            <dhcp-client>
              <send-hostname>yes</send-hostname>
              <send-client-id>no</send-client-id>
              <accept-dhcp-hostname>no</accept-dhcp-hostname>
              <accept-dhcp-domain>no</accept-dhcp-domain>
            </dhcp-client>
          </type>
          <update-server>updates.paloaltonetworks.com</update-server>
          <update-schedule>
            <threats>
              <recurring>
                <weekly>
                  <day-of-week>wednesday</day-of-week>
                  <at>01:02</at>
                  <action>download-only</action>
                </weekly>
              </recurring>
            </threats>
          </update-schedule>
          <timezone>UTC</timezone>
          <service>
            <disable-telnet>yes</disable-telnet>
            <disable-http>yes</disable-http>
          </service>
          <hostname>PA-VM</hostname>
          <device-telemetry>
            <device-health-performance>yes</device-health-performance>
            <product-usage>yes</product-usage>
            <threat-prevention>yes</threat-prevention>
            <region>Americas</region>
          </device-telemetry>
          <ntp-servers>
            <primary-ntp-server>
              <ntp-server-address>169.254.169.254</ntp-server-address>
              <authentication-type>
                <none/>
              </authentication-type>
            </primary-ntp-server>
          </ntp-servers>
        </system>
        <setting>
          <config>
            <rematch>yes</rematch>
          </config>
          <management>
            <hostname-type-in-syslog>FQDN</hostname-type-in-syslog>
            <initcfg>
              <type>
                <dhcp-client>
                  <send-hostname>yes</send-hostname>
                  <send-client-id>no</send-client-id>
                  <accept-dhcp-hostname>no</accept-dhcp-hostname>
                  <accept-dhcp-domain>no</accept-dhcp-domain>
                </dhcp-client>
              </type>
              <public-key>c3NoLXJzYSBBQUFBQjNOemFDMXljMkVBQUFBREFRQUJBQUFDQVFETEZGVHJiNmxhaVhVdUh1SnpYNEltNjdEVEtScU1GTVdsZDN2VGUydDRNZTU0N0xPbEhjZ0R4TER4Nm8wMERjQlA0TCtxOXRYQVVybm9Ydi84NUxvN0lDNzVkSGVrM0RRWU5xQXNIeVEyaTJ2dzZPcTRGL2JxUHBtUTYwL1V1OWFKOTI1TlF4UTNEMDEyUTY2Qy9PUjlrU2NvZE9SRk1uVHprdjVoQUt2MnN6aUN1L0h4VVpBemMyM1hCUnU1S1E3NTB2UVlaY1d5M1RxVWViVTcrVmNBRkUwdVpWZmYzYU9uV1c3UFNENHlRMC9HM3hvTE1iMVgvYktnSndpQVpuZW9BQmxvcmJaMExJSzRaNXdVTWQ1NGV5MkhlK0I4YjhBWnRXemdZcnJlWHp0RlgwMnhwdnJxTnVwYkNNVWlaMVhKWFAvNk1Hc2wwcjRZbU82YU1pYVhhbERhTVpZOGtPb0J1TXR6M3JpbnY4cnZkRE9qellVMjFoaFF5VkZhRFR2c1FXWkhvYlYxam5ZRUUxSk54ZUZoMTRDeWVGRmVSTTBDN1lBaVdJT056Q2dGUmNNTlJlUm4ydXM3TW9HYlVPTU52UmJZT1U3M0lvUG9kYS81TE5YaExkZVR4TG95RWpST2VGWlRxVjlyMDFGT25DOTVneExaWms5R3Z2THNTa2F0c2VYZHdMSEd0bHV0UlhTdWc0amRQWTI1ZHpDaTZFQjhVSWhDNWVsQkN2M2k5Vy9UYmR1Ry95Y1ZYbUQxaUZwNlBLeTcydkt4SDhJMC90c3hpSWpQTHlyaklvK2F0WFJyQk81ajNrUDJUOW1hTTVNUTBLeGtZc0J2bzZLOHlFWVVOQzJ4ekVkWnhGdkY5cXBYVW5Wd3VoR3cyNzN6K1Jib1FUUTN2UWNSZ1E9PSB1c2VyQGV4YW1wbGUuY29t</public-key>
            </initcfg>
          </management>
          <auto-mac-detect>yes</auto-mac-detect>
          <session>
            <packet-buffer-protection-latency-alert>50</packet-buffer-protection-latency-alert>
            <packet-buffer-protection-latency-activate>200</packet-buffer-protection-latency-activate>
            <packet-buffer-protection-latency-max-tolerate>500</packet-buffer-protection-latency-max-tolerate>
            <packet-buffer-protection-latency-block-countdown>500</packet-buffer-protection-latency-block-countdown>
          </session>
          <jumbo-frame>
            <mtu>9192</mtu>
          </jumbo-frame>
        </setting>
      </deviceconfig>
      <vsys>
        <entry name="vsys1">
          <application/>
          <application-group/>
          <zone>
            <entry name="Trust">
              <network>
                <layer3>
                  <member>ethernet1/2</member>
                </layer3>
              </network>
            </entry>
            <entry name="Untrust">
              <network>
                <layer3>
                  <member>ethernet1/1</member>
                </layer3>
              </network>
            </entry>
          </zone>
          <service/>
          <service-group/>
          <schedule/>
          <rulebase>
            <security>
              <rules>
                <entry name="Allow-all-traffic" uuid="dcece1b9-cbec-4b15-8023-c4e2976a976c">
                  <to>
                    <member>any</member>
                  </to>
                  <from>
                    <member>any</member>
                  </from>
                  <source>
                    <member>any</member>
                  </source>
                  <destination>
                    <member>any</member>
                  </destination>
                  <source-user>
                    <member>any</member>
                  </source-user>
                  <category>
                    <member>any</member>
                  </category>
                  <application>
                    <member>any</member>
                  </application>
                  <service>
                    <member>any</member>
                  </service>
                  <source-hip>
                    <member>any</member>
                  </source-hip>
                  <destination-hip>
                    <member>any</member>
                  </destination-hip>
                  <action>allow</action>
                  <log-start>yes</log-start>
                  <log-end>yes</log-end>
                </entry>
              </rules>
            </security>
            <nat>
              <rules>
                <entry name="Internet-Outbound" uuid="597b3e9f-65f0-4d60-be53-66d51aae5a24">
                  <source-translation>
                    <dynamic-ip-and-port>
                      <interface-address>
                        <interface>ethernet1/1</interface>
                      </interface-address>
                    </dynamic-ip-and-port>
                  </source-translation>
                  <to>
                    <member>Untrust</member>
                  </to>
                  <from>
                    <member>Trust</member>
                  </from>
                  <source>
                    <member>any</member>
                  </source>
                  <destination>
                    <member>any</member>
                  </destination>
                  <service>any</service>
                </entry>
              </rules>
            </nat>
          </rulebase>
          <import>
            <network>
              <interface>
                <member>ethernet1/1</member>
                <member>ethernet1/2</member>
              </interface>
            </network>
          </import>
        </entry>
      </vsys>
    </entry>
  </devices>
</config>
"""


def parse_interface_cidr(value: str, flag: str) -> ipaddress.IPv4Interface:
    try:
        interface = ipaddress.ip_interface(value)
    except ValueError as exc:
        raise ValueError(f"{flag} must be an IPv4 interface CIDR") from exc

    if interface.version != 4:
        raise ValueError(f"{flag} must be an IPv4 interface CIDR")

    return interface


def parse_network_cidr(value: str, flag: str) -> ipaddress.IPv4Network:
    try:
        network = ipaddress.ip_network(value, strict=True)
    except ValueError as exc:
        raise ValueError(f"{flag} must be a network CIDR") from exc

    if network.version != 4:
        raise ValueError(f"{flag} must be an IPv4 network CIDR")

    return network


def first_usable_ip(subnet: str | ipaddress.IPv4Network, flag: str = "subnet") -> str:
    network = parse_network_cidr(subnet, flag) if isinstance(subnet, str) else subnet

    try:
        return str(next(network.hosts()))
    except StopIteration as exc:
        raise ValueError(f"{flag} must contain at least one usable host IP") from exc


def render_config(
    *,
    untrust_ip: str,
    trust_ip: str,
    trust_subnet: str,
    untrust_subnet: str,
    external_lb_subnet: str,
) -> str:
    untrust_interface = parse_interface_cidr(untrust_ip, "--untrust-ip")
    trust_interface = parse_interface_cidr(trust_ip, "--trust-ip")
    trust_network = parse_network_cidr(trust_subnet, "--trust-subnet")
    untrust_network = parse_network_cidr(untrust_subnet, "--untrust-subnet")
    external_lb_network = parse_network_cidr(external_lb_subnet, "--external-lb-subnet")

    if trust_interface.ip not in trust_network:
        raise ValueError("--trust-ip must be inside --trust-subnet")
    if untrust_interface.ip not in untrust_network:
        raise ValueError("--untrust-ip must be inside --untrust-subnet")

    rendered = TEMPLATE_XML.format(
        UNTRUST_IP=str(untrust_interface),
        TRUST_IP=str(trust_interface),
        TRUST_SUBNET=str(trust_network),
        UNTRUST_SUBNET=str(untrust_network),
        TRUST_ROUTER_IP=first_usable_ip(trust_network, "--trust-subnet"),
        UNTRUST_ROUTER_IP=first_usable_ip(untrust_network, "--untrust-subnet"),
        EXTERNAL_LB_SUBNET=str(external_lb_network),
    )

    try:
        ET.fromstring(rendered)
    except ET.ParseError as exc:
        raise ValueError(f"rendered template is not valid XML: {exc}") from exc

    return rendered


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Generate a Palo Alto bootstrap XML config for OCI."
    )
    parser.add_argument("--output", required=True, help="Path to write the generated XML.")
    parser.add_argument(
        "--untrust-ip",
        required=True,
        help="IP address and prefix for ethernet1/1, for example 192.168.0.14/29.",
    )
    parser.add_argument(
        "--trust-ip",
        required=True,
        help="IP address and prefix for ethernet1/2, for example 192.168.0.22/29.",
    )
    parser.add_argument(
        "--trust-subnet",
        required=True,
        help="Trust subnet CIDR, for example 192.168.0.16/29.",
    )
    parser.add_argument(
        "--untrust-subnet",
        required=True,
        help="Untrust subnet CIDR, for example 192.168.0.8/29.",
    )
    parser.add_argument(
        "--external-lb-subnet",
        required=True,
        help="External load balancer subnet CIDR, for example 192.168.0.0/29.",
    )
    return parser


def main(argv: Sequence[str] | None = None, stderr: TextIO | None = None) -> int:
    stderr = sys.stderr if stderr is None else stderr
    parser = build_parser()
    args = parser.parse_args(argv)

    try:
        rendered = render_config(
            untrust_ip=args.untrust_ip,
            trust_ip=args.trust_ip,
            trust_subnet=args.trust_subnet,
            untrust_subnet=args.untrust_subnet,
            external_lb_subnet=args.external_lb_subnet,
        )
        Path(args.output).write_text(rendered, encoding="utf-8")
    except ValueError as exc:
        print(f"error: {exc}", file=stderr)
        return 2
    except OSError as exc:
        print(f"error: could not write output {args.output}: {exc}", file=stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
